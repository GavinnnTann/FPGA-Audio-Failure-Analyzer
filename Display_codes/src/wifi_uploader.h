#pragma once

#include <stdint.h>

/*  wifi_uploader  –  Non-blocking Supabase telemetry uploader.
 *
 *  Runs a FreeRTOS task pinned to Core 0 (the ESP32 radio core) so WiFi
 *  I/O and TLS never stall the display / UART loop on Core 1.
 *
 *  Usage:
 *    1. Fill in src/wifi_config.h with your WiFi + Supabase credentials.
 *    2. Call wifi_uploader::init() once in setup().
 *    3. Call wifi_uploader::push(snap) whenever you have fresh data.
 *       It is non-blocking and thread-safe — safe to call from Core 1.
 */

namespace wifi_uploader {

struct Snapshot {
  uint32_t device_ms;   // millis() at capture time
  uint8_t  rms;         // median RMS amplitude (0-255)
  uint8_t  result;      // 0 = Normal, non-zero = Anomaly
  uint8_t  flags;       // bit0=fpga_active  bit1=cnn_anomaly  bit2=cnn_ran
  uint8_t  seq;         // UART frame sequence number
  uint8_t  metric;      // CNN MAE score (valid when cnn_ran=1)
};

// Initialise the uploader and spawn the background task.
// Call once from setup(), after hardware init.
void init();

// Push a snapshot to the upload queue.
// Non-blocking and ISR/task-safe — silently drops if queue is full.
void push(const Snapshot& snap);

// Returns true if WiFi is currently associated.
// Safe to call from any core/task.
bool is_connected();

}  // namespace wifi_uploader
