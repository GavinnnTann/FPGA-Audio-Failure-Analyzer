#pragma once

#include <stddef.h>
#include <stdint.h>

/*  wifi_uploader  –  Non-blocking Supabase telemetry uploader.
 *
 *  Runs a FreeRTOS task pinned to Core 0 (the ESP32 radio core) so WiFi
 *  I/O and TLS never stall the display / UART loop on Core 1.
 *
 *  Usage:
 *    1. Fill in src/wifi_config.h with your default WiFi + Supabase
 *       credentials (used as factory defaults).
 *    2. Call wifi_uploader::init() once in setup().
 *    3. Call wifi_uploader::push(snap) whenever you have fresh data.
 *       It is non-blocking and thread-safe — safe to call from Core 1.
 *
 *  Credentials are persisted in NVS once the user configures them via
 *  apply_credentials(); forget_credentials() clears the persisted entry
 *  so the device stays disconnected until new credentials are set.
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

// Copy the SSID currently in use (or stored as the active config) into
// `out`. Returns true if any non-empty SSID is set; false when the user
// has explicitly forgotten WiFi or boot defaults are blank.
// Safe to call from any thread.
bool current_ssid(char* out, size_t cap);

// Persist new credentials and request the uploader task to reconnect.
// The actual WiFi.begin() call happens on the uploader task (Core 0) so
// the radio state machine is always touched from a single context.
void apply_credentials(const char* ssid, const char* pass);

// Persist an empty SSID and ask the uploader task to disconnect. The
// device will remain unassociated across reboots until the user calls
// apply_credentials() again.
void forget_credentials();

}  // namespace wifi_uploader
