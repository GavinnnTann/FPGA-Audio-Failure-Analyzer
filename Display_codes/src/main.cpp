#include <Arduino.h>
#include <Wire.h>
#include <TFT_eSPI.h>
#include <Adafruit_FT6206.h>
#include <cstdio>
#include <cmath>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

#include "ui.h"

#define I2C_SDA 18
#define I2C_SCL 5

#define vibratorPin 22
#define batteryPin 35
#define chargingPin 17

#define TOUCH_THRESHOLD 80

#define TFT_HOR_RES 480
#define TFT_VER_RES 320

#define DRAW_BUF_SIZE (TFT_HOR_RES * TFT_VER_RES / 10 * (LV_COLOR_DEPTH / 8))

#define FPGA_UART_BAUD 1000000
#define FPGA_UART_RX_PIN 32
#define FPGA_UART_TX_PIN 33

namespace {

constexpr uint32_t kUiUpdateIntervalMs = 200;
constexpr uint32_t kVibePulseMs = 120;
constexpr uint32_t kNoDataTimeoutMs = 400;
constexpr uint32_t kStatsUpdateIntervalMs = 2000;
constexpr uint32_t kRuntimeOverlayUpdateMs = 250;
constexpr uint16_t kMaxUartBytesPerLoop = 64;
constexpr uint16_t kRmsWindowSamples = 200;  // 10s at 50 ms frame rate
constexpr uint16_t kAnomalyEventWindowMs = 60000;
constexpr uint8_t kSeverityHighThreshold = 70;
constexpr uint8_t kDotPersistenceRevs = 3;
constexpr uint16_t kMaxFailureDots = 96;
constexpr int16_t kArcCenterX = 160;
constexpr int16_t kArcCenterY = 160;
constexpr int16_t kArcDotRadius = 132;
constexpr float kAmpAlphaAttack = 0.55f;
constexpr float kAmpAlphaRelease = 0.20f;
constexpr float kBarSlewPerSecond = 260.0f;
constexpr float kNormFloorFastAlpha = 0.18f;
constexpr float kNormFloorSlowAlpha = 0.02f;
constexpr float kNormPeakFastAlpha = 0.35f;
constexpr float kNormPeakSlowAlpha = 0.015f;
constexpr float kNormMinRange = 28.0f;
constexpr float kNormSoftK = 4.0f;

TFT_eSPI tft = TFT_eSPI();
Adafruit_FT6206 ts = Adafruit_FT6206();
HardwareSerial fpga_uart(2);  // UART2 for FPGA

void* draw_buf_1 = nullptr;
static lv_display_t* disp = nullptr;

unsigned long previousTouchTimestamp = 0;
unsigned long touchCheckInterval = 5;

struct TelemetryState {
  uint8_t result = 0;
  uint8_t rms = 0;
  uint8_t rms_display = 0;
  uint8_t flags = 0;
  uint8_t seq = 0;
  uint8_t metric = 0;
  bool has_packet = false;
  bool stale = true;
  bool last_anomaly = false;
  uint32_t last_packet_ms = 0;
  uint32_t last_anomaly_ms = 0;
  uint32_t vibe_until_ms = 0;
  float rms_filtered = 0.0f;
  float rms_floor = 0.0f;
  float rms_peak = 255.0f;
  float rms_target = 0.0f;
  uint8_t rms_hist[3] = {0, 0, 0};
  uint8_t rms_hist_count = 0;
  uint32_t last_bar_update_ms = 0;
};

TelemetryState telemetry;

struct RxStats {
  uint32_t valid = 0;
  uint32_t checksum_fail = 0;
  uint32_t sync_resets = 0;
  uint32_t seq_drop = 0;
  uint32_t seq_reorder = 0;
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
uint32_t boot_ms = 0;
uint32_t last_ui_tick_ms = 0;
uint32_t lv_last_tick_ms = 0;
uint32_t last_runtime_overlay_ms = 0;
uint8_t rms_window[kRmsWindowSamples] = {0};
uint16_t rms_window_head = 0;
uint16_t rms_window_count = 0;
uint32_t anomaly_events_ms[128] = {0};
uint16_t anomaly_events_head = 0;
uint16_t anomaly_events_count = 0;
uint32_t last_dot_total_sec = 0;

struct FailureDot {
  lv_obj_t* obj = nullptr;
  uint16_t sec_mod = 0;
  uint32_t rev = 0;
  uint8_t severity = 0;
  bool active = false;
};

FailureDot failure_dots[kMaxFailureDots];
uint16_t failure_dot_next = 0;
lv_obj_t* runtime_info_top = nullptr;
lv_obj_t* runtime_info_bottom = nullptr;

// UART2 frame parsing state machine
enum class RxState : uint8_t {
  WaitSyncA,
  WaitSyncB,
  WaitResult,
  WaitRms,
  WaitFlags,
  WaitSeq,
  WaitMetric,
  WaitChecksum
};

RxState rx_state = RxState::WaitSyncA;
uint8_t rx_result = 0;
uint8_t rx_rms = 0;
uint8_t rx_flags = 0;
uint8_t rx_seq = 0;
uint8_t rx_metric = 0;
uint8_t raw_frame_bytes[8] = {0};

uint8_t median3(uint8_t a, uint8_t b, uint8_t c) {
  if (a > b) {
    uint8_t t = a;
    a = b;
    b = t;
  }
  if (b > c) {
    uint8_t t = b;
    b = c;
    c = t;
  }
  if (a > b) {
    uint8_t t = a;
    a = b;
    b = t;
  }
  return b;
}

float absf(float x) {
  return (x >= 0.0f) ? x : -x;
}

float clampf(float x, float lo, float hi) {
  if (x < lo) return lo;
  if (x > hi) return hi;
  return x;
}

uint8_t amplitude_to_severity(uint8_t rms) {
  return static_cast<uint8_t>((static_cast<uint16_t>(rms) * 100U + 127U) / 255U);
}

const char* severity_band(uint8_t severity) {
  if (severity >= 70U) return "High";
  if (severity >= 35U) return "Med";
  return "Low";
}

void push_rms_sample(uint8_t rms) {
  const uint16_t idx = (rms_window_head + rms_window_count) % kRmsWindowSamples;
  rms_window[idx] = rms;
  if (rms_window_count < kRmsWindowSamples) {
    rms_window_count++;
  } else {
    rms_window_head = static_cast<uint16_t>((rms_window_head + 1U) % kRmsWindowSamples);
  }
}

void get_rms_window_min_max(uint8_t* min_out, uint8_t* max_out) {
  if (rms_window_count == 0) {
    *min_out = 0;
    *max_out = 0;
    return;
  }

  uint8_t min_v = 255;
  uint8_t max_v = 0;
  for (uint16_t i = 0; i < rms_window_count; i++) {
    const uint8_t v = rms_window[(rms_window_head + i) % kRmsWindowSamples];
    if (v < min_v) min_v = v;
    if (v > max_v) max_v = v;
  }
  *min_out = min_v;
  *max_out = max_v;
}

void prune_anomaly_events(uint32_t now_ms) {
  while (anomaly_events_count > 0) {
    const uint32_t oldest = anomaly_events_ms[anomaly_events_head];
    if (now_ms - oldest <= kAnomalyEventWindowMs) {
      break;
    }
    anomaly_events_head = static_cast<uint16_t>((anomaly_events_head + 1U) % 128U);
    anomaly_events_count--;
  }
}

void push_anomaly_event(uint32_t now_ms) {
  const uint16_t idx = (anomaly_events_head + anomaly_events_count) % 128U;
  anomaly_events_ms[idx] = now_ms;
  if (anomaly_events_count < 128U) {
    anomaly_events_count++;
  } else {
    anomaly_events_head = static_cast<uint16_t>((anomaly_events_head + 1U) % 128U);
  }
}

void position_dot_for_second(lv_obj_t* dot, uint16_t sec_mod) {
  const float angle_deg = static_cast<float>(sec_mod) - 90.0f;
  const float angle_rad = angle_deg * 3.1415926f / 180.0f;
  const int16_t x = static_cast<int16_t>(kArcCenterX + std::cos(angle_rad) * kArcDotRadius);
  const int16_t y = static_cast<int16_t>(kArcCenterY + std::sin(angle_rad) * kArcDotRadius);
  const int16_t w = static_cast<int16_t>(lv_obj_get_width(dot));
  const int16_t h = static_cast<int16_t>(lv_obj_get_height(dot));
  lv_obj_set_pos(dot, static_cast<int32_t>(x - (w / 2)), static_cast<int32_t>(y - (h / 2)));
}

void refresh_failure_dots(uint32_t total_sec) {
  const uint32_t now_rev = total_sec / 360U;
  for (uint16_t i = 0; i < kMaxFailureDots; i++) {
    if (!failure_dots[i].active || failure_dots[i].obj == nullptr) {
      continue;
    }

    const uint32_t age_revs = now_rev - failure_dots[i].rev;
    if (age_revs >= kDotPersistenceRevs) {
      failure_dots[i].active = false;
      lv_obj_add_flag(failure_dots[i].obj, LV_OBJ_FLAG_HIDDEN);
      continue;
    }

    lv_opa_t opa = LV_OPA_100;
    if (age_revs == 1U) {
      opa = LV_OPA_70;
    } else if (age_revs == 2U) {
      opa = LV_OPA_40;
    }
    lv_obj_set_style_bg_opa(failure_dots[i].obj, opa, LV_PART_MAIN | LV_STATE_DEFAULT);
  }
}

void add_failure_dot(uint32_t total_sec, uint8_t severity) {
  FailureDot& dot = failure_dots[failure_dot_next];
  failure_dot_next = static_cast<uint16_t>((failure_dot_next + 1U) % kMaxFailureDots);

  if (dot.obj == nullptr) {
    dot.obj = lv_obj_create(ui_Screen2);
    lv_obj_remove_style_all(dot.obj);
    lv_obj_add_flag(dot.obj, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_remove_flag(dot.obj, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_set_style_border_width(dot.obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_radius(dot.obj, LV_RADIUS_CIRCLE, LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_move_foreground(dot.obj);
  }

  dot.sec_mod = static_cast<uint16_t>(total_sec % 360U);
  dot.rev = total_sec / 360U;
  dot.severity = severity;
  dot.active = true;

  const int16_t size = (severity >= kSeverityHighThreshold) ? 8 : 5;
  lv_obj_set_size(dot.obj, size, size);
  lv_obj_set_style_bg_color(
      dot.obj,
      (severity >= kSeverityHighThreshold) ? lv_color_hex(0xFF3A3A) : lv_color_hex(0xC81010),
      LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_clear_flag(dot.obj, LV_OBJ_FLAG_HIDDEN);
  position_dot_for_second(dot.obj, dot.sec_mod);
  refresh_failure_dots(total_sec);
}

void init_runtime_overlay_labels() {
  runtime_info_top = lv_label_create(ui_Screen2);
  lv_obj_set_width(runtime_info_top, 176);
  lv_obj_set_height(runtime_info_top, LV_SIZE_CONTENT);
  lv_obj_set_align(runtime_info_top, LV_ALIGN_CENTER);
  lv_obj_set_x(runtime_info_top, 103);
  lv_obj_set_y(runtime_info_top, 6);
  lv_label_set_long_mode(runtime_info_top, LV_LABEL_LONG_WRAP);
  lv_label_set_text(runtime_info_top, "Sev 0% Low\nRMS 0 | 10s 0-0");
  lv_obj_set_style_text_color(runtime_info_top, lv_color_hex(0xD9E0E7), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_text_font(runtime_info_top, &lv_font_montserrat_10, LV_PART_MAIN | LV_STATE_DEFAULT);

  runtime_info_bottom = lv_label_create(ui_Screen2);
  lv_obj_set_width(runtime_info_bottom, 176);
  lv_obj_set_height(runtime_info_bottom, LV_SIZE_CONTENT);
  lv_obj_set_align(runtime_info_bottom, LV_ALIGN_CENTER);
  lv_obj_set_x(runtime_info_bottom, 103);
  lv_obj_set_y(runtime_info_bottom, 94);
  lv_label_set_long_mode(runtime_info_bottom, LV_LABEL_LONG_WRAP);
  lv_label_set_text(runtime_info_bottom, "Last 0s | 1m 0\nD/F/R 0/0/0");
  lv_obj_set_style_text_color(runtime_info_bottom, lv_color_hex(0xB8C2CC), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_text_font(runtime_info_bottom, &lv_font_montserrat_10, LV_PART_MAIN | LV_STATE_DEFAULT);
}

void update_runtime_overlay(uint32_t now_ms) {
  if (now_ms - last_runtime_overlay_ms < kRuntimeOverlayUpdateMs) {
    return;
  }
  last_runtime_overlay_ms = now_ms;

  prune_anomaly_events(now_ms);

  const uint8_t severity = amplitude_to_severity(telemetry.rms);
  uint8_t min_rms = 0;
  uint8_t max_rms = 0;
  get_rms_window_min_max(&min_rms, &max_rms);

  char top[120];
  std::snprintf(
      top,
      sizeof(top),
      "Sev %u%% %s\nRMS %u | 10s %u-%u",
      static_cast<unsigned>(severity),
      severity_band(severity),
      static_cast<unsigned>(telemetry.rms),
      static_cast<unsigned>(min_rms),
      static_cast<unsigned>(max_rms));
  lv_label_set_text(runtime_info_top, top);

  uint32_t last_age_s = 0;
  if (telemetry.last_anomaly_ms == 0U) {
    last_age_s = 0;
  } else {
    last_age_s = (now_ms - telemetry.last_anomaly_ms) / 1000U;
  }

  char bottom[140];
  std::snprintf(
      bottom,
      sizeof(bottom),
      "Last %lus | 1m %u\nD/F/R %lu/%lu/%lu",
      static_cast<unsigned long>(last_age_s),
      static_cast<unsigned>(anomaly_events_count),
      static_cast<unsigned long>(rx_stats.seq_drop),
      static_cast<unsigned long>(rx_stats.checksum_fail),
      static_cast<unsigned long>(rx_stats.seq_reorder));
  lv_label_set_text(runtime_info_bottom, bottom);
}

void update_status_label(bool anomaly);

void update_smoothed_bar(uint32_t now_ms) {
  if (!telemetry.has_packet) {
    return;
  }

  uint32_t dt_ms = now_ms - telemetry.last_bar_update_ms;
  if (dt_ms == 0) {
    return;
  }

  telemetry.last_bar_update_ms = now_ms;

  const float max_step = kBarSlewPerSecond * (static_cast<float>(dt_ms) / 1000.0f);
  float delta = telemetry.rms_target - static_cast<float>(telemetry.rms_display);

  if (delta > max_step) {
    delta = max_step;
  } else if (delta < -max_step) {
    delta = -max_step;
  }

  float next = static_cast<float>(telemetry.rms_display) + delta;
  if (next < 0.0f) next = 0.0f;
  if (next > 255.0f) next = 255.0f;

  uint8_t next_u8 = static_cast<uint8_t>(next + 0.5f);
  if (next_u8 != telemetry.rms_display) {
    telemetry.rms_display = next_u8;
    lv_bar_set_value(ui_Bar1, telemetry.rms_display, LV_ANIM_OFF);
  }
}

void set_telemetry_stale_ui(bool stale) {
  if (stale) {
    lv_label_set_text(ui_Label1, "No Data");
    lv_obj_set_style_text_color(ui_Label1, lv_color_hex(0x8A8A8A), LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_text(ui_Label3, "Sleep");
    lv_obj_set_style_text_color(ui_Label3, lv_color_hex(0x8A8A8A), LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(ui_Bar1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_grad_color(ui_Bar1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
  } else {
    update_status_label(telemetry.result != 0);
    lv_label_set_text(ui_Label3, ((telemetry.flags & 0x01U) != 0U) ? "Active" : "Sleep");
    lv_obj_set_style_text_color(ui_Label3, lv_color_hex(0xFFFFFF), LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_arc_color(
        ui_Arc1,
        (telemetry.result != 0) ? lv_color_hex(0xB81010) : lv_color_hex(0x20CF2A),
        LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(ui_Bar1, lv_color_hex(0xB81010), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_grad_color(ui_Bar1, lv_color_hex(0x20CF2A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
  }
}

void update_uart2_stats_monitor(uint32_t now_ms) {
  if (now_ms - rx_stats.last_stats_ui_ms < kStatsUpdateIntervalMs) {
    return;
  }

  rx_stats.last_stats_ui_ms = now_ms;

  bool changed =
      (rx_stats.valid != rx_stats.last_print_valid) ||
      (rx_stats.checksum_fail != rx_stats.last_print_checksum_fail) ||
      (rx_stats.sync_resets != rx_stats.last_print_sync_resets) ||
      (rx_stats.seq_drop != rx_stats.last_print_seq_drop) ||
      (rx_stats.seq_reorder != rx_stats.last_print_seq_reorder) ||
      (telemetry.seq != rx_stats.last_print_seq);
  if (!changed) {
    return;
  }

  char line[180];
  std::snprintf(
      line,
      sizeof(line),
      "stats valid=%lu chk_fail=%lu sync_reset=%lu seq_drop=%lu seq_reorder=%lu last_seq=%u",
      static_cast<unsigned long>(rx_stats.valid),
      static_cast<unsigned long>(rx_stats.checksum_fail),
      static_cast<unsigned long>(rx_stats.sync_resets),
      static_cast<unsigned long>(rx_stats.seq_drop),
      static_cast<unsigned long>(rx_stats.seq_reorder),
      static_cast<unsigned>(telemetry.seq));
  ui_set_uart2_monitor_text(line);

  rx_stats.last_print_valid = rx_stats.valid;
  rx_stats.last_print_checksum_fail = rx_stats.checksum_fail;
  rx_stats.last_print_sync_resets = rx_stats.sync_resets;
  rx_stats.last_print_seq_drop = rx_stats.seq_drop;
  rx_stats.last_print_seq_reorder = rx_stats.seq_reorder;
  rx_stats.last_print_seq = telemetry.seq;
}

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data) {
  (void)indev;
  unsigned long currentTouchTimestamp = millis();

  if(currentTouchTimestamp - previousTouchTimestamp > touchCheckInterval) {
    previousTouchTimestamp = currentTouchTimestamp;
    for(int i = 0; i < ts.touched(); i++) {
      TS_Point p = ts.getPoint(i);
      int16_t y = map(p.x, 317, 11, 1, TFT_VER_RES);
      int16_t x = map(p.y, 20, 480, 1, TFT_HOR_RES);

      data->state = LV_INDEV_STATE_PRESSED;
      data->point.x = x;
      data->point.y = y;
      return;
    }
  }

  data->state = LV_INDEV_STATE_RELEASED;
}

void flush_cb(lv_display_t *display, const lv_area_t *area, uint8_t *px_map) {
  const uint16_t width = static_cast<uint16_t>(area->x2 - area->x1 + 1);
  const uint16_t height = static_cast<uint16_t>(area->y2 - area->y1 + 1);

  tft.startWrite();
  tft.setAddrWindow(area->x1, area->y1, width, height);
  tft.pushColors(reinterpret_cast<uint16_t *>(px_map), static_cast<uint32_t>(width) * height, true);
  tft.endWrite();
  lv_display_flush_ready(display);
}

void update_status_label(bool anomaly) {
  lv_label_set_text(ui_Label1, anomaly ? "Abnormal" : "Normal");
  lv_obj_set_style_text_color(
      ui_Label1,
      anomaly ? lv_color_hex(0xD11F1F) : lv_color_hex(0x20CF2A),
      LV_PART_MAIN | LV_STATE_DEFAULT);
}

void update_uptime_label(uint32_t now_ms) {
  uint32_t total_sec = (now_ms - boot_ms) / 1000U;
  uint32_t hh = total_sec / 3600U;
  uint32_t mm = (total_sec % 3600U) / 60U;
  uint32_t ss = total_sec % 60U;

  char uptime[20];
  std::snprintf(uptime, sizeof(uptime), "%02lu:%02lu:%02lu",
                static_cast<unsigned long>(hh),
                static_cast<unsigned long>(mm),
                static_cast<unsigned long>(ss));
  lv_label_set_text(ui_Label2, uptime);

  // One full revolution every 6 minutes (360 seconds)
  lv_arc_set_value(ui_Arc1, static_cast<int>(total_sec % 360U));
  refresh_failure_dots(total_sec);
}

void apply_packet(uint8_t result, uint8_t rms, uint8_t flags, uint8_t seq, uint8_t metric, uint32_t now_ms) {
  bool anomaly = (result != 0);
  bool fpga_active = ((flags & 0x01U) != 0U);

  telemetry.rms_hist[0] = telemetry.rms_hist[1];
  telemetry.rms_hist[1] = telemetry.rms_hist[2];
  telemetry.rms_hist[2] = rms;
  if (telemetry.rms_hist_count < 3) {
    telemetry.rms_hist_count++;
  }

  uint8_t median_rms = rms;
  if (telemetry.rms_hist_count == 3) {
    median_rms = median3(
        telemetry.rms_hist[0], telemetry.rms_hist[1], telemetry.rms_hist[2]);
  }

  float median_f = static_cast<float>(median_rms);
  float alpha = (median_f >= telemetry.rms_filtered) ? kAmpAlphaAttack : kAmpAlphaRelease;
  telemetry.rms_filtered += alpha * (median_f - telemetry.rms_filtered);
  if (absf(telemetry.rms_filtered - median_f) < 0.01f) {
    telemetry.rms_filtered = median_f;
  }

  // Adaptive normalization: dynamic floor/peak tracking keeps the UI stable
  // across changing ambient loudness while still showing relative dynamics.
  float floor_alpha = (telemetry.rms_filtered < telemetry.rms_floor)
                          ? kNormFloorFastAlpha
                          : kNormFloorSlowAlpha;
  telemetry.rms_floor += floor_alpha * (telemetry.rms_filtered - telemetry.rms_floor);

  float peak_alpha = (telemetry.rms_filtered > telemetry.rms_peak)
                         ? kNormPeakFastAlpha
                         : kNormPeakSlowAlpha;
  telemetry.rms_peak += peak_alpha * (telemetry.rms_filtered - telemetry.rms_peak);

  if (telemetry.rms_peak < telemetry.rms_floor + kNormMinRange) {
    telemetry.rms_peak = telemetry.rms_floor + kNormMinRange;
  }

  float norm = (telemetry.rms_filtered - telemetry.rms_floor) /
               (telemetry.rms_peak - telemetry.rms_floor);
  norm = clampf(norm, 0.0f, 1.0f);

  // Soft-knee compression reduces visual jumpiness on high spikes.
  float norm_compressed = std::log1pf(kNormSoftK * norm) / std::log1pf(kNormSoftK);
  telemetry.rms_target = 255.0f * norm_compressed;

  telemetry.result = result;
  telemetry.rms = median_rms;
  telemetry.flags = flags;
  telemetry.seq = seq;
  telemetry.metric = metric;
  telemetry.has_packet = true;
  telemetry.stale = false;
  telemetry.last_packet_ms = now_ms;
  push_rms_sample(median_rms);

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

  update_status_label(anomaly);
  lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x5A5A5A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
  lv_label_set_text(ui_Label3, fpga_active ? "Active" : "Sleep");
  lv_obj_set_style_text_color(ui_Label3, lv_color_hex(0xFFFFFF), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_bg_color(ui_Bar1, lv_color_hex(0xB81010), LV_PART_INDICATOR | LV_STATE_DEFAULT);
  lv_obj_set_style_bg_grad_color(ui_Bar1, lv_color_hex(0x20CF2A), LV_PART_INDICATOR | LV_STATE_DEFAULT);

  if (anomaly && !telemetry.last_anomaly) {
    telemetry.vibe_until_ms = now_ms + kVibePulseMs;
    telemetry.last_anomaly_ms = now_ms;
    push_anomaly_event(now_ms);

    const uint32_t total_sec = (now_ms - boot_ms) / 1000U;
    if (total_sec != last_dot_total_sec) {
      add_failure_dot(total_sec, amplitude_to_severity(median_rms));
      last_dot_total_sec = total_sec;
    }
  }
  telemetry.last_anomaly = anomaly;
}

void init_fpga_uart() {
  fpga_uart.end();
  pinMode(FPGA_UART_RX_PIN, INPUT);
  pinMode(FPGA_UART_TX_PIN, OUTPUT);
  fpga_uart.setRxBufferSize(1024);
  fpga_uart.begin(FPGA_UART_BAUD, SERIAL_8N1, FPGA_UART_RX_PIN, FPGA_UART_TX_PIN);
}

void parse_uart2_stream(uint32_t now_ms, uint16_t max_bytes) {
  uint16_t processed = 0;
  while (fpga_uart.available() > 0 && processed < max_bytes) {
    uint8_t b = static_cast<uint8_t>(fpga_uart.read());
    processed++;

    switch (rx_state) {
      case RxState::WaitSyncA:
        rx_state = (b == 0xAA) ? RxState::WaitSyncB : RxState::WaitSyncA;
        break;

      case RxState::WaitSyncB:
        if (b == 0x55) {
          rx_state = RxState::WaitResult;
        } else if (b == 0xAA) {
          rx_state = RxState::WaitSyncB;
        } else {
          rx_stats.sync_resets++;
          rx_state = RxState::WaitSyncA;
        }
        break;

      case RxState::WaitResult:
        rx_result = b;
        raw_frame_bytes[0] = 0xAA;
        raw_frame_bytes[1] = 0x55;
        raw_frame_bytes[2] = rx_result;
        rx_state = RxState::WaitRms;
        break;

      case RxState::WaitRms:
        rx_rms = b;
        raw_frame_bytes[3] = rx_rms;
        rx_state = RxState::WaitFlags;
        break;

      case RxState::WaitFlags:
        rx_flags = b;
        raw_frame_bytes[4] = rx_flags;
        rx_state = RxState::WaitSeq;
        break;

      case RxState::WaitSeq:
        rx_seq = b;
        raw_frame_bytes[5] = rx_seq;
        rx_state = RxState::WaitMetric;
        break;

      case RxState::WaitMetric:
        rx_metric = b;
        raw_frame_bytes[6] = rx_metric;
        rx_state = RxState::WaitChecksum;
        break;

      case RxState::WaitChecksum: {
        uint8_t chk = static_cast<uint8_t>(
            0xAA ^ 0x55 ^ rx_result ^ rx_rms ^ rx_flags ^ rx_seq ^ rx_metric);
        raw_frame_bytes[7] = b;

        // If checksum valid, update telemetry display
        if (b == chk) {
          rx_stats.valid++;
          apply_packet(rx_result, rx_rms, rx_flags, rx_seq, rx_metric, now_ms);
        } else {
          rx_stats.checksum_fail++;
        }
        rx_state = RxState::WaitSyncA;
        break;
      }

      default:
        rx_stats.sync_resets++;
        rx_state = RxState::WaitSyncA;
        break;
    }
  }
}



}  // namespace

void setup() {
  Serial.begin(115200);

  pinMode(vibratorPin, OUTPUT);
  pinMode(batteryPin, INPUT);
  pinMode(chargingPin, INPUT);
  digitalWrite(vibratorPin, 0);

  // Initialize I2C for touchscreen
  Wire.begin(I2C_SDA, I2C_SCL);
  if (!ts.begin(TOUCH_THRESHOLD)) {
    // Touch controller init failed; UI still runs without touch input.
  }

  // Initialize UART2 for FPGA telemetry
  init_fpga_uart();

  lv_init();

  // Allocate DMA-capable buffer for LVGL
  draw_buf_1 = heap_caps_malloc(DRAW_BUF_SIZE, MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);
  
  // Initialize TFT display
  tft.init();
  tft.setRotation(1);
  tft.fillScreen(TFT_BLACK);

  // Create LVGL display and set flush callback
  disp = lv_display_create(TFT_HOR_RES, TFT_VER_RES);
  lv_display_set_flush_cb(disp, flush_cb);
  lv_display_set_buffers(
      disp,
      draw_buf_1,
      nullptr,
      DRAW_BUF_SIZE,
      LV_DISPLAY_RENDER_MODE_PARTIAL);

  lv_indev_t *indev = lv_indev_create();
  lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
  lv_indev_set_read_cb(indev, touchscreen_read);

  ui_init();

  analogWrite(vibratorPin, 255);
  delay(500);
  analogWrite(vibratorPin, 0);

  boot_ms = millis();
  last_ui_tick_ms = boot_ms;
  lv_last_tick_ms = boot_ms;
  telemetry.last_bar_update_ms = boot_ms;
  telemetry.rms_floor = 0.0f;
  telemetry.rms_peak = 255.0f;
  last_runtime_overlay_ms = boot_ms;

  lv_arc_set_range(ui_Arc1, 0, 359);
  lv_arc_set_value(ui_Arc1, 0);
  lv_arc_set_bg_angles(ui_Arc1, 0, 360);
  lv_arc_set_rotation(ui_Arc1, 270);
  lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x5A5A5A), LV_PART_INDICATOR | LV_STATE_DEFAULT);

  lv_label_set_text(ui_Label2, "00:00:00");
  lv_label_set_text(ui_Label3, "Sleep");
  set_telemetry_stale_ui(true);
  init_runtime_overlay_labels();

  // UI init loads Screen1 (preload); switch to Screen2 after short splash.
  lv_timer_handler();
  lv_tick_inc(2000);
  delay(2000);
  lv_disp_load_scr(ui_Screen2);
}

void loop() {
  const uint32_t now = millis();

  const uint32_t lv_elapsed = now - lv_last_tick_ms;
  if (lv_elapsed > 0) {
    lv_tick_inc(lv_elapsed);
    lv_last_tick_ms = now;
  }

  // Parse incoming UART2 stream from FPGA
  parse_uart2_stream(now, kMaxUartBytesPerLoop);

  if (telemetry.has_packet && (now - telemetry.last_packet_ms > kNoDataTimeoutMs)) {
    if (!telemetry.stale) {
      telemetry.stale = true;
      telemetry.rms_target = 0.0f;
      telemetry.vibe_until_ms = now;
      set_telemetry_stale_ui(true);
      ui_append_uart2_monitor_line("telemetry timeout -> stale mode");
    }
  } else if (telemetry.has_packet && telemetry.stale) {
    telemetry.stale = false;
    set_telemetry_stale_ui(false);
    ui_append_uart2_monitor_line("telemetry resumed");
  }

  // Smoothly move bar toward filtered target between packet arrivals.
  update_smoothed_bar(now);

  update_runtime_overlay(now);

  update_uart2_stats_monitor(now);

  if (now - last_ui_tick_ms >= kUiUpdateIntervalMs) {
    update_uptime_label(now);
    //ui_append_uart0_monitor_line("Loop tick");
    last_ui_tick_ms = now;
  }

  digitalWrite(vibratorPin, (now < telemetry.vibe_until_ms) ? HIGH : LOW);

  const uint32_t ms_to_next = lv_timer_handler();
  const uint32_t sleep_ms = (ms_to_next > 3U) ? 3U : ms_to_next;
  delay(sleep_ms);
}
