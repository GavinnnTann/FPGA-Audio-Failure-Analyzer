#include <Arduino.h>
#include <cstdio>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

#include "hardware.h"
#include "screen2_telemetry.h"
#include "ui.h"
#include "screens/ui_Screen3.h"
#include "wifi_config.h"
#include "wifi_uploader.h"

namespace {

constexpr uint32_t kUiUpdateIntervalMs = 200;
constexpr uint32_t kVibePulseMs = 120;
constexpr uint32_t kNoDataTimeoutMs = 400;
constexpr uint32_t kStatsUpdateIntervalMs = 2000;
constexpr uint16_t kMaxUartBytesPerLoop = 2048;
constexpr uint32_t kWifiUploadIntervalMs = UPLOAD_INTERVAL_MS;

constexpr uint32_t kFpgaUartBaud = 1000000;
constexpr int kFpgaUartRxPin = 32;
constexpr int kFpgaUartTxPin = 33;

HardwareSerial fpga_uart(2);
void* draw_buf_1 = nullptr;
void* draw_buf_2 = nullptr;
lv_display_t* disp = nullptr;

uint32_t boot_ms = 0;
uint32_t last_ui_tick_ms = 0;
uint32_t lv_last_tick_ms = 0;
uint32_t last_wifi_push_ms = 0;

struct RxStats {
  uint32_t valid = 0;
  uint32_t checksum_fail = 0;
  uint32_t sync_resets = 0;
  uint32_t seq_drop = 0;
  uint32_t seq_reorder = 0;
  uint32_t max_rx_backlog = 0;
  uint32_t max_frame_gap_ms = 0;
  uint32_t last_valid_ms = 0;
  bool seq_seen = false;
  uint8_t last_seq = 0;

  uint32_t last_stats_ui_ms = 0;
  uint32_t last_print_valid = 0;
  uint32_t last_print_checksum_fail = 0;
  uint32_t last_print_sync_resets = 0;
  uint32_t last_print_seq_drop = 0;
  uint32_t last_print_seq_reorder = 0;
  uint8_t last_print_seq = 0;
};

RxStats rx_stats;

enum class RxState : uint8_t {
  WaitSync1,
  WaitSync2Rms,
  WaitSync2Spec,
  WaitRmsPayload,
  WaitSpecPayload
};

RxState rx_state = RxState::WaitSync1;
uint8_t rx_payload[8] = {0};
uint8_t rx_payload_index = 0;
uint16_t spectrogram_bins[64] = {0};
bool screen3_active = false;

void process_valid_rms_frame(uint32_t now_ms) {
  const uint8_t result = rx_payload[2];
  const uint8_t rms = rx_payload[3];
  const uint8_t flags = rx_payload[4];
  const uint8_t seq = rx_payload[5];
  const uint8_t metric = rx_payload[6];

  rx_stats.valid++;

  if (rx_stats.last_valid_ms != 0U) {
    const uint32_t gap_ms = now_ms - rx_stats.last_valid_ms;
    if (gap_ms > rx_stats.max_frame_gap_ms) {
      rx_stats.max_frame_gap_ms = gap_ms;
    }
  }
  rx_stats.last_valid_ms = now_ms;

  if (!rx_stats.seq_seen) {
    rx_stats.seq_seen = true;
  } else {
    const uint8_t expected = static_cast<uint8_t>(rx_stats.last_seq + 1U);
    if (seq != expected) {
      const uint8_t forward_delta = static_cast<uint8_t>(seq - expected);
      if (forward_delta < 128U) {
        rx_stats.seq_drop += forward_delta;
      } else {
        rx_stats.seq_reorder++;
      }
    }
  }
  rx_stats.last_seq = seq;

  screen2_telemetry::on_valid_packet(
      result,
      rms,
      flags,
      seq,
      metric,
      now_ms,
      boot_ms,
      kVibePulseMs,
      screen3_active);
}

void process_valid_spectrogram_frame() {
  const uint8_t bin_index = rx_payload[2];
  if (bin_index >= 64U) {
    return;
  }

  const uint16_t magnitude = static_cast<uint16_t>(
      static_cast<uint16_t>(rx_payload[3]) |
      (static_cast<uint16_t>(rx_payload[4]) << 8));
  spectrogram_bins[bin_index] = magnitude;

  if (bin_index == 63U) {
    ui_screen3_update_spectrogram(spectrogram_bins, 64);
  }
}

void init_fpga_uart() {
  fpga_uart.end();
  pinMode(kFpgaUartRxPin, INPUT);
  pinMode(kFpgaUartTxPin, OUTPUT);
  fpga_uart.setRxBufferSize(8192);
  fpga_uart.begin(kFpgaUartBaud, SERIAL_8N1, kFpgaUartRxPin, kFpgaUartTxPin);
}

void update_uart2_stats_monitor(uint32_t now_ms, const screen2_telemetry::TelemetryData& telemetry) {
  const uint32_t window_ms = now_ms - rx_stats.last_stats_ui_ms;
  if (window_ms < kStatsUpdateIntervalMs) {
    return;
  }

  const uint32_t valid_delta = rx_stats.valid - rx_stats.last_print_valid;
  const uint32_t fps_x10 =
      (window_ms > 0U) ? ((valid_delta * 10000U) / window_ms) : 0U;

  const bool changed =
      (rx_stats.valid != rx_stats.last_print_valid) ||
      (rx_stats.checksum_fail != rx_stats.last_print_checksum_fail) ||
      (rx_stats.sync_resets != rx_stats.last_print_sync_resets) ||
      (rx_stats.seq_drop != rx_stats.last_print_seq_drop) ||
      (rx_stats.seq_reorder != rx_stats.last_print_seq_reorder) ||
      (telemetry.seq != rx_stats.last_print_seq);
  if (!changed) {
    rx_stats.last_stats_ui_ms = now_ms;
    return;
  }

  char line[220];
  std::snprintf(
      line,
      sizeof(line),
      "stats fps=%lu.%lu valid=%lu chk=%lu sync=%lu drop=%lu reord=%lu gap=%lums qmax=%lu seq=%u",
      static_cast<unsigned long>(fps_x10 / 10U),
      static_cast<unsigned long>(fps_x10 % 10U),
      static_cast<unsigned long>(rx_stats.valid),
      static_cast<unsigned long>(rx_stats.checksum_fail),
      static_cast<unsigned long>(rx_stats.sync_resets),
      static_cast<unsigned long>(rx_stats.seq_drop),
      static_cast<unsigned long>(rx_stats.seq_reorder),
      static_cast<unsigned long>(rx_stats.max_frame_gap_ms),
      static_cast<unsigned long>(rx_stats.max_rx_backlog),
      static_cast<unsigned>(telemetry.seq));
  ui_set_uart2_monitor_text(line);

  rx_stats.last_print_valid = rx_stats.valid;
  rx_stats.last_print_checksum_fail = rx_stats.checksum_fail;
  rx_stats.last_print_sync_resets = rx_stats.sync_resets;
  rx_stats.last_print_seq_drop = rx_stats.seq_drop;
  rx_stats.last_print_seq_reorder = rx_stats.seq_reorder;
  rx_stats.last_print_seq = telemetry.seq;
  rx_stats.last_stats_ui_ms = now_ms;
  rx_stats.max_frame_gap_ms = 0;
  rx_stats.max_rx_backlog = 0;
}

void parse_uart2_stream(uint32_t now_ms, uint16_t max_bytes) {
  const uint32_t backlog = static_cast<uint32_t>(fpga_uart.available());
  if (backlog > rx_stats.max_rx_backlog) {
    rx_stats.max_rx_backlog = backlog;
  }

  uint16_t processed = 0;
  while (fpga_uart.available() > 0 && processed < max_bytes) {
    const uint8_t b = static_cast<uint8_t>(fpga_uart.read());
    processed++;

    switch (rx_state) {
      case RxState::WaitSync1:
        if (b == 0xAA) {
          rx_payload[0] = 0xAA;
          rx_state = RxState::WaitSync2Rms;
        } else if (b == 0xDD) {
          rx_payload[0] = 0xDD;
          rx_state = RxState::WaitSync2Spec;
        }
        break;

      case RxState::WaitSync2Rms:
        if (b == 0x55) {
          rx_payload[1] = 0x55;
          rx_payload_index = 2;
          rx_state = RxState::WaitRmsPayload;
        } else if (b == 0xAA) {
          rx_payload[0] = 0xAA;
          rx_state = RxState::WaitSync2Rms;
        } else {
          rx_stats.sync_resets++;
          rx_state = RxState::WaitSync1;
        }
        break;

      case RxState::WaitSync2Spec:
        if (b == 0x77) {
          rx_payload[1] = 0x77;
          rx_payload_index = 2;
          rx_state = RxState::WaitSpecPayload;
        } else if (b == 0xDD) {
          rx_payload[0] = 0xDD;
          rx_state = RxState::WaitSync2Spec;
        } else {
          rx_stats.sync_resets++;
          rx_state = RxState::WaitSync1;
        }
        break;

      case RxState::WaitRmsPayload: {
        rx_payload[rx_payload_index++] = b;
        if (rx_payload_index >= 8U) {
          const uint8_t chk = static_cast<uint8_t>(
              rx_payload[0] ^ rx_payload[1] ^ rx_payload[2] ^ rx_payload[3] ^
              rx_payload[4] ^ rx_payload[5] ^ rx_payload[6]);
          if (chk == rx_payload[7]) {
            process_valid_rms_frame(now_ms);
          } else {
            rx_stats.checksum_fail++;
          }
          rx_state = RxState::WaitSync1;
        }
        break;
      }

      case RxState::WaitSpecPayload: {
        rx_payload[rx_payload_index++] = b;
        if (rx_payload_index >= 6U) {
          const uint8_t chk = static_cast<uint8_t>(
              rx_payload[0] ^ rx_payload[1] ^ rx_payload[2] ^ rx_payload[3] ^ rx_payload[4]);
          if (chk == rx_payload[5]) {
            process_valid_spectrogram_frame();
          } else {
            rx_stats.checksum_fail++;
          }
          rx_state = RxState::WaitSync1;
        }
        break;
      }

      default:
        rx_stats.sync_resets++;
        rx_state = RxState::WaitSync1;
        break;
    }
  }
}

}  // namespace

void setup() {
  Serial.begin(115200);

  hardware::init_board_pins();
  hardware::init_touchscreen();
  init_fpga_uart();

  lv_init();

  draw_buf_1 = heap_caps_malloc(
      hardware::DrawBufSize,
      MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);

  // Single draw buffer — second buffer omitted to keep ~25 KB of internal
  // heap free for the mbedTLS handshake on Core 0.
  draw_buf_2 = nullptr;

  if (draw_buf_1 == nullptr) {
    // Display cannot run without at least one DMA buffer.
    while (true) {
      delay(1000);
    }
  }

  hardware::init_display_panel();

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

  // Determine screen BEFORE parsing so UART callbacks can skip
  // Screen2-only LVGL work while the spectrogram is displayed.
  static bool prev_on_screen3 = false;
  const bool on_screen3 = (lv_screen_active() == ui_Screen3);
  screen3_active = on_screen3;

  // On Screen3 → Screen2 transition the first full-screen render can
  // block long enough for the UART buffer to overflow, losing RMS
  // frames. Stamp last_packet_ms to now so the stale timer does not
  // fire during the transition.
  if (prev_on_screen3 && !on_screen3 && telemetry.has_packet) {
    telemetry.last_packet_ms = now;
  }
  prev_on_screen3 = on_screen3;

  parse_uart2_stream(now, kMaxUartBytesPerLoop);

  if (telemetry.has_packet && (now - telemetry.last_packet_ms > kNoDataTimeoutMs)) {
    if (!telemetry.stale) {
      telemetry.rms_target = 0.0f;
      telemetry.vibe_until_ms = now;
      screen2_telemetry::set_stale_ui(true);
    }
  } else if (telemetry.has_packet && telemetry.stale) {
    screen2_telemetry::set_stale_ui(false);
  }

  // Screen3: throttled spectrogram redraw.
  if (on_screen3) {
    ui_screen3_tick(now);
  }

  // Direct touch navigation for Screen3, checked before lv_timer_handler() so
  // back-navigation fires without waiting for the canvas render to complete.
  // LVGL's CLICKED event path can lag by up to one full render cycle (~25ms).
  if (on_screen3) {
    hardware::update_touch_state();
    static bool s3_touch_prev = false;
    const bool s3_touching = hardware::is_touch_pressed();
    if (s3_touching && !s3_touch_prev) {
      lv_disp_load_scr(ui_Screen2);
    }
    s3_touch_prev = s3_touching;
  }

  // Screen2 visual updates -- skip when not displayed to save CPU for
  // spectrogram rendering on Screen3.
  if (!on_screen3) {
    screen2_telemetry::tick(now);
    screen2_telemetry::update_smoothed_bar(now);

    screen2_telemetry::RuntimeStats overlay_stats;
    overlay_stats.seq_drop = rx_stats.seq_drop;
    overlay_stats.checksum_fail = rx_stats.checksum_fail;
    overlay_stats.seq_reorder = rx_stats.seq_reorder;
    screen2_telemetry::update_runtime_overlay(now, overlay_stats);

    update_uart2_stats_monitor(now, telemetry);

    if (now - last_ui_tick_ms >= kUiUpdateIntervalMs) {
      screen2_telemetry::update_uptime_label(now, boot_ms);
      last_ui_tick_ms = now;
    }
  }

  // Push a telemetry snapshot to WiFi uploader every UPLOAD_INTERVAL_MS.
  // Only when a valid packet has been received; non-blocking queue push.
  if (telemetry.has_packet && !telemetry.stale &&
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

  digitalWrite(hardware::VibratorPin, (now < telemetry.vibe_until_ms) ? HIGH : LOW);

  const uint32_t ms_to_next = lv_timer_handler();

  // Read again after rendering work to reduce telemetry-to-UI latency
  // when display flushing is temporarily heavy.
  parse_uart2_stream(millis(), kMaxUartBytesPerLoop);

  const uint32_t sleep_ms = (ms_to_next > 1U) ? 1U : ms_to_next;
  delay(sleep_ms);
}
