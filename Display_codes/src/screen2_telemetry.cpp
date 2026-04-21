#include "screen2_telemetry.h"

#include <cmath>
#include <cstdio>

#include "failure_dots.h"
#include "ui.h"

namespace screen2_telemetry {

namespace {

constexpr uint32_t kRuntimeOverlayUpdateMs = 500;
constexpr uint16_t kRmsWindowSamples = 200;  // 10s at 50 ms frame rate
constexpr uint16_t kAnomalyEventWindowMs = 60000;
constexpr uint16_t kSparklineSamples = 72;
constexpr int16_t kSparklineSize = 146;
constexpr float kSparklineStartDeg = 210.0f;
constexpr float kSparklineSweepDeg = 360.0f;
constexpr float kSparklineBaseRadius = 46.0f;
constexpr float kSparklineAmpRadius = 12.0f;
constexpr float kAmpAlphaAttack = 0.55f;
constexpr float kAmpAlphaRelease = 0.20f;
constexpr float kBarSlewPerSecond = 260.0f;
constexpr float kNormFloorFastAlpha = 0.18f;
constexpr float kNormFloorSlowAlpha = 0.02f;
constexpr float kNormPeakFastAlpha = 0.35f;
constexpr float kNormPeakSlowAlpha = 0.015f;
constexpr float kNormMinRange = 28.0f;
constexpr float kNormSoftK = 4.0f;
constexpr uint8_t kSeverityHighThreshold = 70;

TelemetryData telemetry;

uint32_t last_runtime_overlay_ms = 0;
uint8_t rms_window[kRmsWindowSamples] = {0};
uint16_t rms_window_head = 0;
uint16_t rms_window_count = 0;
uint32_t anomaly_events_ms[128] = {0};
uint16_t anomaly_events_head = 0;
uint16_t anomaly_events_count = 0;
uint8_t spark_samples[kSparklineSamples] = {0};
uint16_t spark_head = 0;
uint16_t spark_count = 0;
lv_point_precise_t spark_points[kSparklineSamples] = {};
uint32_t last_dot_total_sec = 0;
uint32_t last_sparkline_rebuild_ms = 0;
constexpr uint32_t kSparklineRebuildIntervalMs = 250;
bool sparkline_dirty = false;

lv_obj_t* severity_info_label = nullptr;
lv_obj_t* health_info_label = nullptr;
lv_obj_t* sparkline_obj = nullptr;

// Cached state for change-detection on LVGL style sets.
bool cached_anomaly = false;
bool cached_fpga_active = false;
bool cached_cnn_ran = false;
bool styles_need_restore = false;

uint8_t median3(uint8_t a, uint8_t b, uint8_t c) {
  if (a > b) {
    const uint8_t t = a;
    a = b;
    b = t;
  }
  if (b > c) {
    const uint8_t t = b;
    b = c;
    c = t;
  }
  if (a > b) {
    const uint8_t t = a;
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

void update_status_label(bool anomaly) {
  lv_label_set_text(ui_StatusLabel, anomaly ? "Abnormal" : "Normal");
  lv_obj_set_style_text_color(
      ui_StatusLabel,
      anomaly ? lv_color_hex(0xD11F1F) : lv_color_hex(0x20CF2A),
      LV_PART_MAIN | LV_STATE_DEFAULT);
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

void push_spark_sample(uint8_t rms) {
  const uint16_t idx = (spark_head + spark_count) % kSparklineSamples;
  spark_samples[idx] = rms;
  if (spark_count < kSparklineSamples) {
    spark_count++;
  } else {
    spark_head = static_cast<uint16_t>((spark_head + 1U) % kSparklineSamples);
  }
}

void rebuild_sparkline_points() {
  if (sparkline_obj == nullptr) {
    return;
  }

  uint16_t sample_count = spark_count;
  if (sample_count < 2U) {
    sample_count = 2U;
  }

  const uint16_t point_count = static_cast<uint16_t>(sample_count + 1U);

  const float center = static_cast<float>(kSparklineSize) * 0.5f;
  for (uint16_t i = 0; i < point_count; i++) {
    uint8_t sample = 0;
    if (spark_count == 0U) {
      sample = 0;
    } else if (i < spark_count) {
      sample = spark_samples[(spark_head + i) % kSparklineSamples];
    } else if (i == point_count - 1U) {
      sample = spark_samples[spark_head];
    } else {
      sample = spark_samples[(spark_head + spark_count - 1U) % kSparklineSamples];
    }

    const bool is_closed_end = (i == point_count - 1U);
    const float t = (point_count > 2U)
                        ? (is_closed_end
                               ? 0.0f
                               : (static_cast<float>(i) / static_cast<float>(point_count - 2U)))
                        : 0.0f;
    const float angle_deg = kSparklineStartDeg - (kSparklineSweepDeg * t);
    const float angle_rad = angle_deg * 3.1415926f / 180.0f;
    const float norm = static_cast<float>(sample) / 255.0f;
    const float radius = kSparklineBaseRadius + ((norm - 0.5f) * 2.0f * kSparklineAmpRadius);

    const float px = center + std::cos(angle_rad) * radius;
    const float py = center + std::sin(angle_rad) * radius;

    spark_points[i].x = static_cast<lv_value_precise_t>(std::lround(px));
    spark_points[i].y = static_cast<lv_value_precise_t>(std::lround(py));
  }

  lv_line_set_points(sparkline_obj, spark_points, point_count);
}

void create_center_sparkline() {
  sparkline_obj = lv_line_create(ui_Screen2);
  lv_obj_set_size(sparkline_obj, kSparklineSize, kSparklineSize);
  lv_obj_set_align(sparkline_obj, LV_ALIGN_CENTER);
  lv_obj_set_x(sparkline_obj, -112);
  lv_obj_set_y(sparkline_obj, 0);
  lv_obj_remove_flag(sparkline_obj, LV_OBJ_FLAG_CLICKABLE);
  lv_obj_remove_flag(sparkline_obj, LV_OBJ_FLAG_CLICK_FOCUSABLE);
  lv_obj_set_style_bg_opa(sparkline_obj, LV_OPA_TRANSP, LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_border_width(sparkline_obj, 0, LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_line_width(sparkline_obj, 3, LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_line_color(sparkline_obj, lv_color_hex(0x7FE7FF), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_line_opa(sparkline_obj, LV_OPA_80, LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_line_rounded(sparkline_obj, true, LV_PART_MAIN | LV_STATE_DEFAULT);

  rebuild_sparkline_points();
}

void create_overlay_labels() {
  severity_info_label = lv_label_create(ui_Screen2);
  lv_obj_set_width(severity_info_label, 176);
  lv_obj_set_height(severity_info_label, LV_SIZE_CONTENT);
  lv_obj_set_align(severity_info_label, LV_ALIGN_CENTER);
  lv_obj_set_x(severity_info_label, 118);
  lv_obj_set_y(severity_info_label, 42);
  lv_label_set_long_mode(severity_info_label, LV_LABEL_LONG_WRAP);
  lv_label_set_text(severity_info_label, "Severity:\n0% Low\nRMS 0\n10s 0-0");
  lv_obj_set_style_text_color(severity_info_label, lv_color_hex(0xD9E0E7), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_text_font(severity_info_label, &lv_font_montserrat_10, LV_PART_MAIN | LV_STATE_DEFAULT);

  health_info_label = lv_label_create(ui_Screen2);
  lv_obj_set_width(health_info_label, 176);
  lv_obj_set_height(health_info_label, LV_SIZE_CONTENT);
  lv_obj_set_align(health_info_label, LV_ALIGN_CENTER);
  lv_obj_set_x(health_info_label, 118);
  lv_obj_set_y(health_info_label, 92);
  lv_label_set_long_mode(health_info_label, LV_LABEL_LONG_WRAP);
  lv_label_set_text(health_info_label, "Health:\nLast 0s\n1m 0\nD/F/R 0/0/0");
  lv_obj_set_style_text_color(health_info_label, lv_color_hex(0xB8C2CC), LV_PART_MAIN | LV_STATE_DEFAULT);
  lv_obj_set_style_text_font(health_info_label, &lv_font_montserrat_10, LV_PART_MAIN | LV_STATE_DEFAULT);
}

}  // namespace

TelemetryData& data() {
  return telemetry;
}

void initialize(uint32_t boot_ms) {
  telemetry = TelemetryData{};
  telemetry.last_bar_update_ms = boot_ms;

  rms_window_head = 0;
  rms_window_count = 0;
  anomaly_events_head = 0;
  anomaly_events_count = 0;
  spark_head = 0;
  spark_count = 0;
  last_runtime_overlay_ms = boot_ms;
  last_sparkline_rebuild_ms = boot_ms;
  sparkline_dirty = false;
  styles_need_restore = false;
  cached_anomaly = false;
  cached_fpga_active = false;
  cached_cnn_ran = false;
  last_dot_total_sec = 0;

  lv_arc_set_range(ui_Arc1, 0, 359);
  lv_arc_set_value(ui_Arc1, 0);
  lv_arc_set_bg_angles(ui_Arc1, 0, 360);
  lv_arc_set_rotation(ui_Arc1, 270);
  lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x5A5A5A), LV_PART_INDICATOR | LV_STATE_DEFAULT);

  lv_label_set_text(ui_UptimeLabel, "00:00:00");
  lv_label_set_text(ui_FpgaStateLabel, "Sleep\nCNN Wait");
  set_stale_ui(true);

  create_center_sparkline();
  create_overlay_labels();
  failure_dots::initialize(ui_Screen2, ui_Arc1);
}

void set_stale_ui(bool stale) {
  telemetry.stale = stale;
  if (stale) {
    lv_label_set_text(ui_StatusLabel, "No Data");
    lv_obj_set_style_text_color(ui_StatusLabel, lv_color_hex(0x8A8A8A), LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_label_set_text(ui_FpgaStateLabel, "Sleep\nCNN Wait");
    lv_obj_set_style_text_color(ui_FpgaStateLabel, lv_color_hex(0x8A8A8A), LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(ui_Bar1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_grad_color(ui_Bar1, lv_color_hex(0x7A7A7A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
  } else {
    // Defer the heavy style restores to the next on_valid_packet.
    styles_need_restore = true;
    cached_anomaly = !cached_anomaly;    // Force status label refresh.
    cached_fpga_active = !cached_fpga_active; // Force fpga label refresh.
  }
}

void update_smoothed_bar(uint32_t now_ms) {
  if (!telemetry.has_packet) {
    return;
  }

  const uint32_t dt_ms = now_ms - telemetry.last_bar_update_ms;
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

  const uint8_t next_u8 = static_cast<uint8_t>(next + 0.5f);
  if (next_u8 != telemetry.rms_display) {
    telemetry.rms_display = next_u8;
    lv_bar_set_value(ui_Bar1, telemetry.rms_display, LV_ANIM_OFF);
  }
}

void tick(uint32_t now_ms) {
  // Throttled sparkline rebuild — only when dirty AND enough time has passed.
  if (sparkline_dirty && (now_ms - last_sparkline_rebuild_ms >= kSparklineRebuildIntervalMs)) {
    sparkline_dirty = false;
    last_sparkline_rebuild_ms = now_ms;
    rebuild_sparkline_points();
  }
}

void update_uptime_label(uint32_t now_ms, uint32_t boot_ms) {
  const uint32_t total_sec = (now_ms - boot_ms) / 1000U;
  const uint32_t hh = total_sec / 3600U;
  const uint32_t mm = (total_sec % 3600U) / 60U;
  const uint32_t ss = total_sec % 60U;

  char uptime[20];
  std::snprintf(
      uptime,
      sizeof(uptime),
      "%02lu:%02lu:%02lu",
      static_cast<unsigned long>(hh),
      static_cast<unsigned long>(mm),
      static_cast<unsigned long>(ss));
  lv_label_set_text(ui_UptimeLabel, uptime);

  lv_arc_set_value(ui_Arc1, static_cast<int>(total_sec % 360U));
  failure_dots::refresh(total_sec);
}

void update_runtime_overlay(uint32_t now_ms, const RuntimeStats& stats) {
  if (now_ms - last_runtime_overlay_ms < kRuntimeOverlayUpdateMs) {
    return;
  }
  last_runtime_overlay_ms = now_ms;

  prune_anomaly_events(now_ms);

  const uint8_t severity = amplitude_to_severity(telemetry.rms);
  uint8_t min_rms = 0;
  uint8_t max_rms = 0;
  get_rms_window_min_max(&min_rms, &max_rms);

  const bool cnn_ran = ((telemetry.flags & 0x04U) != 0U);
  const char* cnn_tag = cnn_ran ? (telemetry.metric >= 30U ? "ANOM" : "OK")
                                : "--";

  char top[140];
  std::snprintf(
      top,
      sizeof(top),
      "CNN MAE %u/255 [%s]\n%u%% %s | RMS %u\n10s %u-%u",
      static_cast<unsigned>(telemetry.metric),
      cnn_tag,
      static_cast<unsigned>(severity),
      severity_band(severity),
      static_cast<unsigned>(telemetry.rms),
      static_cast<unsigned>(min_rms),
      static_cast<unsigned>(max_rms));
  lv_label_set_text(severity_info_label, top);

  char bottom[140];
  std::snprintf(
      bottom,
      sizeof(bottom),
      "Health:\nLast %lus\n1m %u\nD/F/R %lu/%lu/%lu",
      static_cast<unsigned long>((telemetry.last_anomaly_ms == 0U)
                                     ? 0U
                                     : ((now_ms - telemetry.last_anomaly_ms) / 1000U)),
      static_cast<unsigned>(anomaly_events_count),
      static_cast<unsigned long>(stats.seq_drop),
      static_cast<unsigned long>(stats.checksum_fail),
      static_cast<unsigned long>(stats.seq_reorder));
  lv_label_set_text(health_info_label, bottom);
}

void on_valid_packet(
    uint8_t result,
    uint8_t rms,
    uint8_t flags,
    uint8_t seq,
    uint8_t metric,
    uint32_t now_ms,
    uint32_t boot_ms,
    uint32_t vibe_pulse_ms,
    bool skip_ui) {
  const bool anomaly = (result != 0);
  const bool fpga_active = ((flags & 0x01U) != 0U);

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

  const float median_f = static_cast<float>(median_rms);
  const float alpha = (median_f >= telemetry.rms_filtered) ? kAmpAlphaAttack : kAmpAlphaRelease;
  telemetry.rms_filtered += alpha * (median_f - telemetry.rms_filtered);
  if (absf(telemetry.rms_filtered - median_f) < 0.01f) {
    telemetry.rms_filtered = median_f;
  }

  const float floor_alpha =
      (telemetry.rms_filtered < telemetry.rms_floor) ? kNormFloorFastAlpha : kNormFloorSlowAlpha;
  telemetry.rms_floor += floor_alpha * (telemetry.rms_filtered - telemetry.rms_floor);

  const float peak_alpha =
      (telemetry.rms_filtered > telemetry.rms_peak) ? kNormPeakFastAlpha : kNormPeakSlowAlpha;
  telemetry.rms_peak += peak_alpha * (telemetry.rms_filtered - telemetry.rms_peak);

  if (telemetry.rms_peak < telemetry.rms_floor + kNormMinRange) {
    telemetry.rms_peak = telemetry.rms_floor + kNormMinRange;
  }

  // Bar displays CNN MAE score (0-255); holds at zero until CNN runs.
  const bool cnn_ran = ((flags & 0x04U) != 0U);
  telemetry.rms_target = cnn_ran ? static_cast<float>(metric) : 0.0f;

  telemetry.result = result;
  telemetry.rms = median_rms;
  telemetry.flags = flags;
  telemetry.seq = seq;
  telemetry.metric = metric;
  telemetry.has_packet = true;
  // Note: telemetry.stale is managed exclusively by the main loop.
  telemetry.last_packet_ms = now_ms;

  push_rms_sample(median_rms);
  push_spark_sample(median_rms);
  sparkline_dirty = true;

  // Skip all LVGL widget manipulation when Screen3 is active.
  // The data/filter state above is still maintained so Screen2
  // resumes smoothly once visible again.
  if (!skip_ui) {
    const bool status_changed = (anomaly != cached_anomaly);
    const bool fpga_changed = (fpga_active != cached_fpga_active ||
                               cnn_ran != cached_cnn_ran);

    if (status_changed) {
      cached_anomaly = anomaly;
      update_status_label(anomaly);
    }
    if (fpga_changed) {
      cached_fpga_active = fpga_active;
      cached_cnn_ran = cnn_ran;
      char fpga_line[32];
      std::snprintf(fpga_line, sizeof(fpga_line), "%s\n%s",
                    fpga_active ? "Active" : "Sleep",
                    cnn_ran ? "CNN Live" : "CNN Wait");
      lv_label_set_text(ui_FpgaStateLabel, fpga_line);
      // Color-code by CNN state: green=live, amber=waiting.
      lv_obj_set_style_text_color(ui_FpgaStateLabel,
          cnn_ran ? lv_color_hex(0x20CF2A) : lv_color_hex(0xE88A1A),
          LV_PART_MAIN | LV_STATE_DEFAULT);
    }
    // Restore bar/arc colors once after a stale period, not every packet.
    if (styles_need_restore) {
      styles_need_restore = false;
      lv_obj_set_style_arc_color(ui_Arc1, lv_color_hex(0x5A5A5A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
      lv_obj_set_style_bg_color(ui_Bar1, lv_color_hex(0xB81010), LV_PART_INDICATOR | LV_STATE_DEFAULT);
      lv_obj_set_style_bg_grad_color(ui_Bar1, lv_color_hex(0x20CF2A), LV_PART_INDICATOR | LV_STATE_DEFAULT);
    }
  }

  if (anomaly && !telemetry.last_anomaly) {
    telemetry.vibe_until_ms = now_ms + vibe_pulse_ms;
    telemetry.last_anomaly_ms = now_ms;
    push_anomaly_event(now_ms);

    if (!skip_ui) {
      const uint32_t total_sec = (now_ms - boot_ms) / 1000U;
      if (total_sec != last_dot_total_sec) {
        failure_dots::add_dot(total_sec, amplitude_to_severity(median_rms));
        last_dot_total_sec = total_sec;
      }
    }
  }
  telemetry.last_anomaly = anomaly;
}

}  // namespace screen2_telemetry
