#include "wifi_uploader.h"
#include "wifi_config.h"

#include <Arduino.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>

namespace wifi_uploader {

namespace {

// ---- Configuration ----------------------------------------------------------

constexpr int      kQueueDepth     = 8;     // Drop oldest if producer outruns uploader
constexpr uint32_t kBootDelayMs    = 5000;  // Wait for system to stabilise before first POST
constexpr uint32_t kHttpTimeoutMs  = WIFI_HTTP_TIMEOUT_MS; // Max time for a single HTTP round-trip
constexpr size_t   kTaskStackBytes = 9216;  // TLS/mbedTLS needs ~5-6 KB headroom
// WIFI_CONNECT_TIMEOUT_MS and WIFI_RETRY_DELAY_MS from wifi_config.h are now
// handled by the ESP32 WiFi driver via setAutoReconnect — not used manually.

// Full Supabase REST endpoint, assembled at compile time.
static const char kUrl[] = SUPABASE_HOST "/rest/v1/" SUPABASE_TABLE;

// ---- Queue ------------------------------------------------------------------

static QueueHandle_t snap_queue = nullptr;

// ---- WiFi helpers -----------------------------------------------------------

// WiFi is initialised once in the task after boot delay; the driver handles
// reconnection automatically via setAutoReconnect(true).
// ensure_wifi() checks both association AND a valid DHCP lease so we never
// attempt a TLS connection before the IP stack is ready.
static bool ensure_wifi() {
  return WiFi.status() == WL_CONNECTED &&
         WiFi.localIP() != IPAddress(0, 0, 0, 0);
}

// ---- JSON builder -----------------------------------------------------------

static void build_json(char* buf, size_t len, const Snapshot& s) {
  const bool anomaly    = (s.result  != 0U);
  const bool cnn_ran    = ((s.flags & 0x04U) != 0U);
  const bool fpga_active = ((s.flags & 0x01U) != 0U);

  snprintf(buf, len,
      "{"
      "\"device_ms\":%lu,"
      "\"rms\":%u,"
      "\"result\":%u,"
      "\"seq\":%u,"
      "\"metric\":%u,"
      "\"anomaly\":%s,"
      "\"cnn_ran\":%s,"
      "\"fpga_active\":%s"
      "}",
      static_cast<unsigned long>(s.device_ms),
      static_cast<unsigned>(s.rms),
      static_cast<unsigned>(s.result),
      static_cast<unsigned>(s.seq),
      static_cast<unsigned>(s.metric),
      anomaly     ? "true" : "false",
      cnn_ran     ? "true" : "false",
      fpga_active ? "true" : "false");
}

// ---- Upload task (Core 0) ---------------------------------------------------

static void uploader_task(void* /*arg*/) {
  // Allow the display + UART system to fully boot before touching WiFi.
  vTaskDelay(pdMS_TO_TICKS(kBootDelayMs));

  // Start WiFi exactly once.
  // setSleep(false)        — keeps radio awake between beacons; prevents
  //                          beacon-miss events that cause spurious disconnects.
  // setAutoReconnect(true) — the ESP32 WiFi driver re-associates silently
  //                          without any call on our side, so we never need
  //                          to call WiFi.begin() again after this point.
  // persistent(false) — do NOT write credentials to NVS flash on every
  // reconnect; NVS writes briefly stall the SPI bus and cause UART glitches.
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);           // Disable power-save beaconing — most common
                                  // cause of hotspot spurious disconnects.
  WiFi.setAutoReconnect(true);    // Driver re-associates silently on drop.
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  while (true) {
    // Block until a snapshot arrives (wake up at least every 30 s to check
    // WiFi health even when no data is flowing).
    Snapshot snap{};
    if (xQueueReceive(snap_queue, &snap, pdMS_TO_TICKS(30000)) != pdTRUE) {
      continue;  // Timeout — nothing to send.
    }

    // Drain any backlog that built up during a slow HTTP round-trip.
    // We keep only the most recent snapshot so the dashboard shows live data.
    {
      Snapshot newer{};
      while (xQueueReceive(snap_queue, &newer, 0) == pdTRUE) {
        snap = newer;
      }
    }

    // Skip POST if not currently associated; autoReconnect will restore
    // the link on its own — no manual retry needed here.
    if (!ensure_wifi()) {
      continue;
    }

    // Build JSON payload.
    char body[256];
    build_json(body, sizeof(body), snap);

    // getMaxAllocHeap() is the largest single contiguous free block.
    // mbedTLS needs ~36 KB contiguous (16 KB in + 4 KB out + ~16 KB overhead).
    const uint32_t max_block = ESP.getMaxAllocHeap();
    if (max_block < 40000U) {
      vTaskDelay(pdMS_TO_TICKS(2000));
      continue;
    }

    // Create fresh client objects per request — reusing a static
    // WiFiClientSecure causes stale TLS after server-side closure.
    WiFiClientSecure tls;
    HTTPClient       http;
    tls.setInsecure();  // Skip cert verify — acceptable for telemetry.

    // POST to Supabase REST API.
    if (http.begin(tls, kUrl)) {
      http.addHeader("Content-Type",  "application/json");
      http.addHeader("apikey",        SUPABASE_KEY);
      http.addHeader("Authorization", "Bearer " SUPABASE_KEY);
      // "return=minimal" suppresses the response body (saves bandwidth).
      http.addHeader("Prefer",        "return=minimal");
      http.setTimeout(kHttpTimeoutMs);

      const int code = http.POST(String(body));
      (void)code;
      http.end();
    }
  }
}

}  // namespace

// ---- Public API -------------------------------------------------------------

void init() {
  snap_queue = xQueueCreate(kQueueDepth, sizeof(Snapshot));
  if (snap_queue == nullptr) {
    return;
  }

  // Pin to Core 0 (the ESP32 WiFi/BT radio core).
  // Arduino loop() runs on Core 1 — the two never share CPU time on the
  // same core, so WiFi TLS stalls cannot affect display or UART parsing.
  const BaseType_t rc = xTaskCreatePinnedToCore(
      uploader_task,
      "wifi_up",
      kTaskStackBytes,
      nullptr,
      1,        // Priority 1 (above idle, same as Arduino loop)
      nullptr,
      0);       // Core 0

  (void)rc;
}

void push(const Snapshot& snap) {
  if (snap_queue == nullptr) return;
  // Non-blocking: silently drop if queue is full.
  xQueueSend(snap_queue, &snap, 0);
}

bool is_connected() {
  return WiFi.status() == WL_CONNECTED;
}

}  // namespace wifi_uploader
