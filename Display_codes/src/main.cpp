#include <Arduino.h>
#include <atomic>
#include <cstdio>
#include <cstring>

#include <freertos/FreeRTOS.h>
#include <freertos/queue.h>
#include <freertos/semphr.h>
#include <freertos/task.h>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

#include "hardware.h"
#include "screen2_telemetry.h"
#include "settings.h"
#include "ui.h"
#include "screens/ui_Screen3.h"
#include "wifi_config.h"
#include "wifi_uploader.h"

namespace {

constexpr uint32_t kUiUpdateIntervalMs = 200;
constexpr uint32_t kVibePulseMs = 120;
constexpr uint32_t kNoDataTimeoutMs = 400;
constexpr uint32_t kStatsUpdateIntervalMs = 2000;
constexpr uint32_t kWifiUploadIntervalMs = UPLOAD_INTERVAL_MS;

constexpr uint32_t kFpgaUartBaud = 1000000;
constexpr int kFpgaUartRxPin = 32;
constexpr int kFpgaUartTxPin = 33;
constexpr size_t kFpgaUartRxBuf = 8192;
constexpr size_t kUsbSerialTxBuf = 4096;
constexpr size_t kUartChunkSize = 256;

constexpr UBaseType_t kRmsQueueDepth = 32;
constexpr UBaseType_t kSpecQueueDepth = 4;
constexpr size_t kUartTaskStack = 4096;
constexpr UBaseType_t kUartTaskPriority = 4;  // Above touch (3) and wifi_up (1).
constexpr uint32_t kUartIdleWakeMs = 50;

HardwareSerial fpga_uart(2);
void* draw_buf_1 = nullptr;
void* draw_buf_2 = nullptr;
lv_display_t* disp = nullptr;

uint32_t boot_ms = 0;
uint32_t last_ui_tick_ms = 0;
uint32_t lv_last_tick_ms = 0;
uint32_t last_wifi_push_ms = 0;

// ---- Frame structs delivered through FreeRTOS queues ---------------------

struct RmsFrame {
  uint8_t result;
  uint8_t rms;
  uint8_t flags;
  uint8_t seq;
  uint8_t metric;
  uint32_t rx_ms;
};

struct SpecFrame {
  uint16_t bins[64];
};

QueueHandle_t g_rms_queue = nullptr;
QueueHandle_t g_spec_queue = nullptr;

// ---- RX statistics -------------------------------------------------------
//
// Counters are written by the Core-0 UART task and read by the Core-1 loop.
// std::atomic with relaxed ordering is enough — they are advisory display
// values, not synchronisation primitives.

struct RxStats {
  std::atomic<uint32_t> valid{0};
  std::atomic<uint32_t> checksum_fail{0};
  std::atomic<uint32_t> sync_resets{0};
  std::atomic<uint32_t> seq_drop{0};
  std::atomic<uint32_t> seq_reorder{0};
  std::atomic<uint32_t> max_rx_backlog{0};
  std::atomic<uint32_t> max_frame_gap_ms{0};
  std::atomic<uint8_t> last_seq{0};
};

RxStats g_rx_stats;

// Loop-side change-detection snapshots used to throttle the on-screen stats
// label. These are touched only by the Core-1 loop.
struct StatsSnapshot {
  uint32_t last_stats_ui_ms = 0;
  uint32_t last_print_valid = 0;
  uint32_t last_print_checksum_fail = 0;
  uint32_t last_print_sync_resets = 0;
  uint32_t last_print_seq_drop = 0;
  uint32_t last_print_seq_reorder = 0;
  uint8_t last_print_seq = 0;
};
StatsSnapshot g_stats_snap;

bool screen3_active = false;

// ---- UART RX task --------------------------------------------------------
//
// Pinned to Core 0. Sleeps on a semaphore that the ESP32 UART event task
// gives via onReceive() whenever bytes arrive (interrupt-driven: the UART
// hardware FIFO threshold raises the IRQ which schedules the event task,
// which calls our callback). When woken, the task drains every byte
// currently available, bulk-forwards the raw chunk to USB Serial in a
// single write call, and parses framed packets out of the same chunk.

SemaphoreHandle_t g_uart_rx_sem = nullptr;

enum class RxState : uint8_t {
  WaitSync1,
  WaitSync2Rms,
  WaitSync2Spec,
  WaitRmsPayload,
  WaitSpecPayload
};

void uart_rx_event_cb() {
  if (g_uart_rx_sem != nullptr) {
    xSemaphoreGive(g_uart_rx_sem);
  }
}

void note_seq(uint8_t seq, bool& seq_seen, uint8_t& last_seq_local) {
  if (!seq_seen) {
    seq_seen = true;
  } else {
    const uint8_t expected = static_cast<uint8_t>(last_seq_local + 1U);
    if (seq != expected) {
      const uint8_t forward_delta = static_cast<uint8_t>(seq - expected);
      if (forward_delta < 128U) {
        g_rx_stats.seq_drop.fetch_add(forward_delta, std::memory_order_relaxed);
      } else {
        g_rx_stats.seq_reorder.fetch_add(1, std::memory_order_relaxed);
      }
    }
  }
  last_seq_local = seq;
  g_rx_stats.last_seq.store(seq, std::memory_order_relaxed);
}

void uart_rx_task(void* /*arg*/) {
  uint8_t chunk[kUartChunkSize];

  RxState state = RxState::WaitSync1;
  uint8_t payload[8] = {0};
  uint8_t pidx = 0;

  // Spectrogram reassembly state lives in the task — the loop only ever
  // sees a fully-populated SpecFrame on the queue, never partial bursts.
  uint16_t spec_acc[64] = {0};

  bool seq_seen = false;
  uint8_t last_seq_local = 0;
  uint32_t last_valid_ms = 0;

  for (;;) {
    // Block until the UART event task signals fresh data (interrupt path)
    // or the wake-tick fires so we can publish updated max_rx_backlog.
    xSemaphoreTake(g_uart_rx_sem, pdMS_TO_TICKS(kUartIdleWakeMs));

    while (true) {
      const int avail = fpga_uart.available();
      if (avail <= 0) {
        break;
      }
      const uint32_t backlog = static_cast<uint32_t>(avail);
      if (backlog > g_rx_stats.max_rx_backlog.load(std::memory_order_relaxed)) {
        g_rx_stats.max_rx_backlog.store(backlog, std::memory_order_relaxed);
      }

      const size_t want = (static_cast<size_t>(avail) > sizeof(chunk))
                              ? sizeof(chunk)
                              : static_cast<size_t>(avail);
      const int got = fpga_uart.readBytes(chunk, want);
      if (got <= 0) {
        break;
      }

      // Bulk forward to USB serial — one write per chunk, never per byte.
      // The TX buffer is sized to absorb a full chunk so this never blocks
      // the parser even when the host pauses briefly.
      Serial.write(chunk, static_cast<size_t>(got));

      const uint32_t now_ms = millis();

      for (int i = 0; i < got; i++) {
        const uint8_t b = chunk[i];
        switch (state) {
          case RxState::WaitSync1:
            if (b == 0xAA) {
              payload[0] = 0xAA;
              state = RxState::WaitSync2Rms;
            } else if (b == 0xDD) {
              payload[0] = 0xDD;
              state = RxState::WaitSync2Spec;
            }
            break;

          case RxState::WaitSync2Rms:
            if (b == 0x55) {
              payload[1] = 0x55;
              pidx = 2;
              state = RxState::WaitRmsPayload;
            } else if (b == 0xAA) {
              payload[0] = 0xAA;
            } else {
              g_rx_stats.sync_resets.fetch_add(1, std::memory_order_relaxed);
              state = RxState::WaitSync1;
            }
            break;

          case RxState::WaitSync2Spec:
            if (b == 0x77) {
              payload[1] = 0x77;
              pidx = 2;
              state = RxState::WaitSpecPayload;
            } else if (b == 0xDD) {
              payload[0] = 0xDD;
            } else {
              g_rx_stats.sync_resets.fetch_add(1, std::memory_order_relaxed);
              state = RxState::WaitSync1;
            }
            break;

          case RxState::WaitRmsPayload: {
            payload[pidx++] = b;
            if (pidx >= 8U) {
              const uint8_t chk = static_cast<uint8_t>(
                  payload[0] ^ payload[1] ^ payload[2] ^ payload[3] ^
                  payload[4] ^ payload[5] ^ payload[6]);
              if (chk == payload[7]) {
                g_rx_stats.valid.fetch_add(1, std::memory_order_relaxed);
                if (last_valid_ms != 0U) {
                  const uint32_t gap_ms = now_ms - last_valid_ms;
                  uint32_t prev_gap = g_rx_stats.max_frame_gap_ms.load(std::memory_order_relaxed);
                  if (gap_ms > prev_gap) {
                    g_rx_stats.max_frame_gap_ms.store(gap_ms, std::memory_order_relaxed);
                  }
                }
                last_valid_ms = now_ms;

                note_seq(payload[5], seq_seen, last_seq_local);

                RmsFrame frame;
                frame.result = payload[2];
                frame.rms    = payload[3];
                frame.flags  = payload[4];
                frame.seq    = payload[5];
                frame.metric = payload[6];
                frame.rx_ms  = now_ms;
                xQueueSend(g_rms_queue, &frame, 0);
              } else {
                g_rx_stats.checksum_fail.fetch_add(1, std::memory_order_relaxed);
              }
              state = RxState::WaitSync1;
            }
            break;
          }

          case RxState::WaitSpecPayload: {
            payload[pidx++] = b;
            if (pidx >= 6U) {
              const uint8_t chk = static_cast<uint8_t>(
                  payload[0] ^ payload[1] ^ payload[2] ^ payload[3] ^ payload[4]);
              if (chk == payload[5]) {
                const uint8_t bin_index = payload[2];
                if (bin_index < 64U) {
                  spec_acc[bin_index] = static_cast<uint16_t>(
                      static_cast<uint16_t>(payload[3]) |
                      (static_cast<uint16_t>(payload[4]) << 8));
                  if (bin_index == 63U) {
                    SpecFrame sframe;
                    std::memcpy(sframe.bins, spec_acc, sizeof(sframe.bins));
                    // Drop oldest if loop is behind — newest spectrogram wins.
                    if (xQueueSend(g_spec_queue, &sframe, 0) != pdTRUE) {
                      SpecFrame discard;
                      xQueueReceive(g_spec_queue, &discard, 0);
                      xQueueSend(g_spec_queue, &sframe, 0);
                    }
                  }
                }
              } else {
                g_rx_stats.checksum_fail.fetch_add(1, std::memory_order_relaxed);
              }
              state = RxState::WaitSync1;
            }
            break;
          }
        }
      }
    }
  }
}

void start_uart_rx_task() {
  g_uart_rx_sem = xSemaphoreCreateBinary();
  g_rms_queue = xQueueCreate(kRmsQueueDepth, sizeof(RmsFrame));
  g_spec_queue = xQueueCreate(kSpecQueueDepth, sizeof(SpecFrame));

  fpga_uart.end();
  pinMode(kFpgaUartRxPin, INPUT);
  pinMode(kFpgaUartTxPin, OUTPUT);
  fpga_uart.setRxBufferSize(kFpgaUartRxBuf);
  fpga_uart.begin(kFpgaUartBaud, SERIAL_8N1, kFpgaUartRxPin, kFpgaUartTxPin);
  // Wake our RX task when ~1/2 of the hw FIFO has filled. Smaller threshold
  // = more wakeups = lower latency; 64 keeps the task efficient at 1 Mbps.
  fpga_uart.setRxFIFOFull(64);
  fpga_uart.onReceive(uart_rx_event_cb);

  xTaskCreatePinnedToCore(
      uart_rx_task,
      "uart_rx",
      kUartTaskStack,
      nullptr,
      kUartTaskPriority,
      nullptr,
      0);  // Core 0
}

// ---- Loop-side helpers ---------------------------------------------------

void update_uart2_stats_monitor(uint32_t now_ms,
                                const screen2_telemetry::TelemetryData& telemetry) {
  const uint32_t window_ms = now_ms - g_stats_snap.last_stats_ui_ms;
  if (window_ms < kStatsUpdateIntervalMs) {
    return;
  }

  const uint32_t valid = g_rx_stats.valid.load(std::memory_order_relaxed);
  const uint32_t checksum_fail = g_rx_stats.checksum_fail.load(std::memory_order_relaxed);
  const uint32_t sync_resets = g_rx_stats.sync_resets.load(std::memory_order_relaxed);
  const uint32_t seq_drop = g_rx_stats.seq_drop.load(std::memory_order_relaxed);
  const uint32_t seq_reorder = g_rx_stats.seq_reorder.load(std::memory_order_relaxed);
  const uint32_t max_gap = g_rx_stats.max_frame_gap_ms.exchange(0, std::memory_order_relaxed);
  const uint32_t max_back = g_rx_stats.max_rx_backlog.exchange(0, std::memory_order_relaxed);

  const uint32_t valid_delta = valid - g_stats_snap.last_print_valid;
  const uint32_t fps_x10 = (window_ms > 0U) ? ((valid_delta * 10000U) / window_ms) : 0U;

  const bool changed =
      (valid != g_stats_snap.last_print_valid) ||
      (checksum_fail != g_stats_snap.last_print_checksum_fail) ||
      (sync_resets != g_stats_snap.last_print_sync_resets) ||
      (seq_drop != g_stats_snap.last_print_seq_drop) ||
      (seq_reorder != g_stats_snap.last_print_seq_reorder) ||
      (telemetry.seq != g_stats_snap.last_print_seq);
  if (!changed) {
    g_stats_snap.last_stats_ui_ms = now_ms;
    return;
  }

  char line[220];
  std::snprintf(
      line,
      sizeof(line),
      "stats fps=%lu.%lu valid=%lu chk=%lu sync=%lu drop=%lu reord=%lu gap=%lums qmax=%lu seq=%u",
      static_cast<unsigned long>(fps_x10 / 10U),
      static_cast<unsigned long>(fps_x10 % 10U),
      static_cast<unsigned long>(valid),
      static_cast<unsigned long>(checksum_fail),
      static_cast<unsigned long>(sync_resets),
      static_cast<unsigned long>(seq_drop),
      static_cast<unsigned long>(seq_reorder),
      static_cast<unsigned long>(max_gap),
      static_cast<unsigned long>(max_back),
      static_cast<unsigned>(telemetry.seq));
  ui_set_uart2_monitor_text(line);

  g_stats_snap.last_print_valid = valid;
  g_stats_snap.last_print_checksum_fail = checksum_fail;
  g_stats_snap.last_print_sync_resets = sync_resets;
  g_stats_snap.last_print_seq_drop = seq_drop;
  g_stats_snap.last_print_seq_reorder = seq_reorder;
  g_stats_snap.last_print_seq = telemetry.seq;
  g_stats_snap.last_stats_ui_ms = now_ms;
}

void drain_rms_queue(uint32_t now_ms) {
  RmsFrame frame;
  // Bound the per-iteration drain so a backlog never starves the renderer.
  for (int i = 0; i < 16; i++) {
    if (xQueueReceive(g_rms_queue, &frame, 0) != pdTRUE) {
      break;
    }
    screen2_telemetry::on_valid_packet(
        frame.result,
        frame.rms,
        frame.flags,
        frame.seq,
        frame.metric,
        now_ms,
        boot_ms,
        kVibePulseMs,
        screen3_active);
  }
}

void drain_spec_queue() {
  SpecFrame sframe;
  // Only the most recent spectrogram is worth rendering.
  bool got = false;
  while (xQueueReceive(g_spec_queue, &sframe, 0) == pdTRUE) {
    got = true;
  }
  if (got) {
    ui_screen3_update_spectrogram(sframe.bins, 64);
  }
}

}  // namespace

void setup() {
  Serial.begin(1000000);  // Match FPGA baud for raw stream forwarding to PC.
  // Roomy USB-side TX buffer absorbs host pauses without back-pressuring the
  // parser. 4 KB at 1 Mbps = ~32 ms of slack.
  Serial.setTxBufferSize(kUsbSerialTxBuf);

  hardware::init_board_pins();
  hardware::init_touchscreen();

  lv_init();

  draw_buf_1 = heap_caps_malloc(
      hardware::DrawBufSize,
      MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);
  draw_buf_2 = nullptr;

  if (draw_buf_1 == nullptr) {
    while (true) {
      delay(1000);
    }
  }

  hardware::init_display_panel();
  hardware::init_backlight();

  disp = lv_display_create(hardware::TftHorRes, hardware::TftVerRes);
  lv_display_set_flush_cb(disp, hardware::flush_cb);
  lv_display_set_buffers(
      disp,
      draw_buf_1,
      draw_buf_2,
      hardware::DrawBufSize,
      LV_DISPLAY_RENDER_MODE_PARTIAL);

  lv_indev_t* indev = lv_indev_create();
  lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
  lv_indev_set_read_cb(indev, hardware::touchscreen_read);

  ui_init();

  analogWrite(hardware::VibratorPin, 255);
  delay(500);
  analogWrite(hardware::VibratorPin, 0);

  boot_ms = millis();
  last_ui_tick_ms = boot_ms;
  lv_last_tick_ms = boot_ms;

  screen2_telemetry::initialize(boot_ms);
  wifi_uploader::init();

  // Spawn the always-on Core 0 workers. UART RX must come up before any
  // FPGA traffic; the touch task before any user interaction.
  hardware::start_touch_task();
  start_uart_rx_task();

  lv_timer_handler();
  lv_tick_inc(2000);
  delay(2000);
  lv_disp_load_scr(ui_Screen2);
}

void loop() {
  const uint32_t now = millis();
  screen2_telemetry::TelemetryData& telemetry = screen2_telemetry::data();

  const uint32_t lv_elapsed = now - lv_last_tick_ms;
  if (lv_elapsed > 0) {
    lv_tick_inc(lv_elapsed);
    lv_last_tick_ms = now;
  }

  // Determine screen BEFORE consuming queues so RMS callbacks can skip
  // Screen2-only LVGL work while the spectrogram is displayed.
  static bool prev_on_screen3 = false;
  const bool on_screen3 = (lv_screen_active() == ui_Screen3);
  screen3_active = on_screen3;

  // On Screen3 → Screen2 transition the first full-screen render can take
  // long enough for the queue to grow; keep the stale timer from firing
  // during the transition.
  if (prev_on_screen3 && !on_screen3 && telemetry.has_packet) {
    telemetry.last_packet_ms = now;
  }
  prev_on_screen3 = on_screen3;

  // Pull parsed frames produced by the Core-0 UART task.
  drain_rms_queue(now);
  if (on_screen3) {
    drain_spec_queue();
  } else {
    // Discard any stale spectrogram bursts that piled up while off-screen.
    SpecFrame discard;
    while (xQueueReceive(g_spec_queue, &discard, 0) == pdTRUE) {
    }
  }

  if (telemetry.has_packet && (now - telemetry.last_packet_ms > kNoDataTimeoutMs)) {
    if (!telemetry.stale) {
      telemetry.rms_target = 0.0f;
      telemetry.vibe_until_ms = now;
      screen2_telemetry::set_stale_ui(true);
    }
  } else if (telemetry.has_packet && telemetry.stale) {
    screen2_telemetry::set_stale_ui(false);
  }

  if (on_screen3) {
    ui_screen3_tick(now);

    // Direct touch navigation, checked before lv_timer_handler() so back-nav
    // fires without waiting for the canvas render to complete. The cached
    // touch state is updated on Core 0, so this is a lock-free read.
    static bool s3_touch_prev = false;
    const bool s3_touching = hardware::is_touch_pressed();
    if (s3_touching && !s3_touch_prev) {
      lv_disp_load_scr(ui_Screen2);
    }
    s3_touch_prev = s3_touching;
  } else {
    screen2_telemetry::tick(now);
    screen2_telemetry::update_smoothed_bar(now);

    screen2_telemetry::RuntimeStats overlay_stats;
    overlay_stats.seq_drop = g_rx_stats.seq_drop.load(std::memory_order_relaxed);
    overlay_stats.checksum_fail = g_rx_stats.checksum_fail.load(std::memory_order_relaxed);
    overlay_stats.seq_reorder = g_rx_stats.seq_reorder.load(std::memory_order_relaxed);
    screen2_telemetry::update_runtime_overlay(now, overlay_stats);

    update_uart2_stats_monitor(now, telemetry);

    if (now - last_ui_tick_ms >= kUiUpdateIntervalMs) {
      screen2_telemetry::update_uptime_label(now, boot_ms);
      last_ui_tick_ms = now;
    }
  }

  if (telemetry.has_packet && !telemetry.stale &&
      settings_wifi_upload_enabled() &&
      (now - last_wifi_push_ms >= kWifiUploadIntervalMs)) {
    last_wifi_push_ms = now;
    wifi_uploader::Snapshot snap;
    snap.device_ms = now;
    snap.rms       = telemetry.rms;
    snap.result    = telemetry.result;
    snap.flags     = telemetry.flags;
    snap.seq       = telemetry.seq;
    snap.metric    = telemetry.metric;
    wifi_uploader::push(snap);
  }

  const bool buzz = settings_vibration_enabled() && (now < telemetry.vibe_until_ms);
  digitalWrite(hardware::VibratorPin, buzz ? HIGH : LOW);

  const uint32_t ms_to_next = lv_timer_handler();
  const uint32_t sleep_ms = (ms_to_next > 1U) ? 1U : ms_to_next;
  delay(sleep_ms);
}
