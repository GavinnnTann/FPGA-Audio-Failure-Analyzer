#pragma once

#include <Arduino.h>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

namespace screen2_telemetry {

struct TelemetryData {
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

struct RuntimeStats {
  uint32_t seq_drop = 0;
  uint32_t checksum_fail = 0;
  uint32_t seq_reorder = 0;
  uint32_t anomaly_count_1m = 0;
};

TelemetryData& data();

void initialize(uint32_t boot_ms);
void set_stale_ui(bool stale);
void tick(uint32_t now_ms);
void update_smoothed_bar(uint32_t now_ms);
void update_uptime_label(uint32_t now_ms, uint32_t boot_ms);
void update_runtime_overlay(uint32_t now_ms, const RuntimeStats& stats);

void on_valid_packet(
    uint8_t result,
    uint8_t rms,
    uint8_t flags,
    uint8_t seq,
    uint8_t metric,
    uint32_t now_ms,
    uint32_t boot_ms,
    uint32_t vibe_pulse_ms,
    bool skip_ui = false);

}  // namespace screen2_telemetry
