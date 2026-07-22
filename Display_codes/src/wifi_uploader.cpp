#include "wifi_uploader.h"
#include "wifi_config.h"

#include <Arduino.h>
#include <HTTPClient.h>
#include <Preferences.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <atomic>
#include <cstring>

namespace wifi_uploader {

namespace {

// ---- Configuration ----------------------------------------------------------

constexpr int      kQueueDepth     = 8;     // Drop oldest if producer outruns uploader
constexpr uint32_t kBootDelayMs    = 5000;  // Wait for system to stabilise before first POST
constexpr uint32_t kHttpTimeoutMs  = WIFI_HTTP_TIMEOUT_MS;
constexpr size_t   kTaskStackBytes = 9216;
constexpr uint32_t kCommandPollMs  = 1500;  // Max time before pending cred change is honoured.

constexpr size_t kSsidCap = 33;
constexpr size_t kPassCap = 65;

// Full Supabase REST endpoint, assembled at compile time.
static const char kUrl[] = SUPABASE_HOST "/rest/v1/" SUPABASE_TABLE;

// ---- Queue + command state --------------------------------------------------

QueueHandle_t snap_queue = nullptr;

// Pending credential change. Updated from any thread; consumed by the
// uploader task. Protected by a portMUX critical section (cheap on ESP32
// dual-core).
enum class WifiCmd : uint8_t {
  None,
  Apply,
  Forget,
  ResetDefaults,  // wipe NVS and reconnect with compiled WIFI_SSID/PASS
};

struct PendingCommand {
  WifiCmd cmd = WifiCmd::None;
  char ssid[kSsidCap] = {0};
  char pass[kPassCap] = {0};
};

PendingCommand g_pending;
portMUX_TYPE g_pending_mux = portMUX_INITIALIZER_UNLOCKED;

// Cached copy of the active SSID for display purposes. Single-writer
// (uploader task); readers tolerate a torn snapshot.
char g_active_ssid[kSsidCap] = {0};
portMUX_TYPE g_active_mux = portMUX_INITIALIZER_UNLOCKED;

// Cached WiFi connected state. Written exclusively from Core 0 (uploader_task)
// so WiFi driver calls only happen on the radio core. Core 1 reads this atomic
// instead of calling WiFi.status() directly — calling WiFi.status() from Core 1
// triggers an IPC spin-wait that can deadlock against the WiFi internal lock
// held during TLS handshakes, preventing the WDT from being reset for 8+ s.
static std::atomic<bool> g_wifi_connected_cache{false};

// Master radio switch, written from any task by set_enabled() and consumed
// only by uploader_task. Defaults to false so the device boots with the radio
// down — nothing brings WiFi up until the user flips the Settings toggle.
static std::atomic<bool> g_radio_enabled{false};

// uploader_task's view of what the radio is actually doing. Compared against
// g_radio_enabled each iteration to detect an off→on / on→off edge.
bool g_radio_active = false;

// ---- NVS helpers ------------------------------------------------------------

constexpr const char* kPrefsNamespace = "wifi";
constexpr const char* kPrefsKeySsid   = "ssid";
constexpr const char* kPrefsKeyPass   = "pass";
constexpr const char* kPrefsKeyTouched = "set";

bool stored_credentials(char* ssid, size_t ssid_cap,
                        char* pass, size_t pass_cap,
                        bool* user_touched) {
  Preferences prefs;
  if (!prefs.begin(kPrefsNamespace, true)) {
    *user_touched = false;
    ssid[0] = '\0';
    pass[0] = '\0';
    return false;
  }
  *user_touched = prefs.getBool(kPrefsKeyTouched, false);
  String s = prefs.getString(kPrefsKeySsid, "");
  String p = prefs.getString(kPrefsKeyPass, "");
  prefs.end();

  std::strncpy(ssid, s.c_str(), ssid_cap - 1);
  ssid[ssid_cap - 1] = '\0';
  std::strncpy(pass, p.c_str(), pass_cap - 1);
  pass[pass_cap - 1] = '\0';
  return true;
}

void persist_credentials(const char* ssid, const char* pass) {
  Preferences prefs;
  if (!prefs.begin(kPrefsNamespace, false)) {
    return;
  }
  prefs.putBool(kPrefsKeyTouched, true);
  prefs.putString(kPrefsKeySsid, ssid);
  prefs.putString(kPrefsKeyPass, pass);
  prefs.end();
}

void persist_forget() {
  Preferences prefs;
  if (!prefs.begin(kPrefsNamespace, false)) {
    return;
  }
  prefs.putBool(kPrefsKeyTouched, true);
  prefs.putString(kPrefsKeySsid, "");
  prefs.putString(kPrefsKeyPass, "");
  prefs.end();
}

void persist_clear() {
  // Erase the entire wifi-credentials namespace so the next boot falls
  // back to the compiled WIFI_SSID/PASS as if NVS had never been touched.
  Preferences prefs;
  if (!prefs.begin(kPrefsNamespace, false)) {
    return;
  }
  prefs.clear();
  prefs.end();
}

// ---- WiFi state machine (runs only on the uploader task) -------------------

void set_active_ssid(const char* ssid) {
  portENTER_CRITICAL(&g_active_mux);
  std::strncpy(g_active_ssid, ssid ? ssid : "", kSsidCap - 1);
  g_active_ssid[kSsidCap - 1] = '\0';
  portEXIT_CRITICAL(&g_active_mux);
}

bool g_wifi_started = false;

// First-ever WiFi.begin in this boot. Mirrors the pre-refactor sequence
// — no disconnect, no radio toggle. Calling disconnect(true, ...) before
// begin races the supplicant on some arduino-esp32 builds and leaves the
// device unable to associate.
void start_wifi(const char* ssid, const char* pass) {
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.setAutoReconnect(true);
  WiFi.begin(ssid, pass);
  set_active_ssid(ssid);
  g_wifi_started = true;
}

// Re-associate with a different AP at runtime. Drops the existing
// connection (radio stays on) so the supplicant starts a fresh auth.
void switch_wifi(const char* ssid, const char* pass) {
  if (!g_wifi_started) {
    // Defensive: if we never started, fall through to the simple path.
    start_wifi(ssid, pass);
    return;
  }
  WiFi.disconnect(false, false);  // wifioff=false: keep radio up
  delay(50);
  WiFi.begin(ssid, pass);
  set_active_ssid(ssid);
}

void disconnect_wifi() {
  WiFi.disconnect(true, false);
  set_active_ssid("");
}

void apply_initial_credentials() {
  char ssid[kSsidCap] = {0};
  char pass[kPassCap] = {0};
  bool touched = false;
  stored_credentials(ssid, sizeof(ssid), pass, sizeof(pass), &touched);

  if (!touched) {
    // Factory state — fall back to whatever was compiled into wifi_config.h.
    std::strncpy(ssid, WIFI_SSID, sizeof(ssid) - 1);
    ssid[sizeof(ssid) - 1] = '\0';
    std::strncpy(pass, WIFI_PASS, sizeof(pass) - 1);
    pass[sizeof(pass) - 1] = '\0';
  }

  if (ssid[0] == '\0') {
    // User explicitly forgot WiFi — stay disconnected until apply.
    return;
  }
  start_wifi(ssid, pass);
}

// Bring the radio up or down to match g_radio_enabled. Runs on the uploader
// task only, so every WiFi.* call below stays on Core 0.
void service_radio_state() {
  const bool want = g_radio_enabled.load(std::memory_order_relaxed);
  if (want == g_radio_active) return;

  if (want) {
    // Re-reads NVS, so credentials set while the radio was off take effect here.
    apply_initial_credentials();
  } else {
    disconnect_wifi();
    WiFi.mode(WIFI_OFF);
    g_wifi_started = false;
    g_wifi_connected_cache.store(false, std::memory_order_relaxed);
  }
  g_radio_active = want;
}

void process_pending_command() {
  PendingCommand cmd;
  portENTER_CRITICAL(&g_pending_mux);
  cmd = g_pending;
  g_pending.cmd = WifiCmd::None;
  portEXIT_CRITICAL(&g_pending_mux);

  // With the radio off we still consume the command so it cannot fire stale
  // later, but skip the radio work. The caller has already persisted the new
  // credentials to NVS, and service_radio_state() re-reads them on enable.
  if (!g_radio_active) return;

  switch (cmd.cmd) {
    case WifiCmd::Apply:
      switch_wifi(cmd.ssid, cmd.pass);
      break;
    case WifiCmd::Forget:
      disconnect_wifi();
      break;
    case WifiCmd::ResetDefaults: {
      // NVS already cleared by the caller; reconnect using the values
      // baked into wifi_config.h. If those are blank too, just stay
      // disconnected.
      static const char default_ssid[] = WIFI_SSID;
      static const char default_pass[] = WIFI_PASS;
      if (default_ssid[0] != '\0') {
        switch_wifi(default_ssid, default_pass);
      } else {
        disconnect_wifi();
      }
      break;
    }
    case WifiCmd::None:
    default:
      break;
  }
}

// ---- WiFi readiness check ---------------------------------------------------

bool ensure_wifi() {
  return WiFi.status() == WL_CONNECTED &&
         WiFi.localIP() != IPAddress(0, 0, 0, 0);
}

// ---- JSON builder -----------------------------------------------------------

void build_json(char* buf, size_t len, const Snapshot& s) {
  const bool anomaly     = (s.result  != 0U);
  const bool cnn_ran     = ((s.flags & 0x04U) != 0U);
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

void uploader_task(void* /*arg*/) {
  vTaskDelay(pdMS_TO_TICKS(kBootDelayMs));

  // No unconditional connect at boot — the radio comes up only once
  // service_radio_state() sees the enable flag set.

  // Persistent so the TLS session survives between uploads — avoids repeated BIGNUM handshakes.
  WiFiClientSecure tls;
  tls.setInsecure();
  tls.setTimeout(kHttpTimeoutMs / 1000U);

  while (true) {
    service_radio_state();
    process_pending_command();

    // Radio down: drop any TLS session and idle. Nothing should be queued
    // (main.cpp gates push on the same setting) but drain defensively so a
    // stale snapshot cannot be POSTed the moment WiFi comes back.
    if (!g_radio_active) {
      tls.stop();
      xQueueReset(snap_queue);
      vTaskDelay(pdMS_TO_TICKS(kCommandPollMs));
      continue;
    }

    // Refresh the cache from Core 0 so Core 1 never needs to call WiFi.status().
    g_wifi_connected_cache.store(
        WiFi.status() == WL_CONNECTED, std::memory_order_relaxed);

    Snapshot snap{};
    if (xQueueReceive(snap_queue, &snap, pdMS_TO_TICKS(kCommandPollMs)) != pdTRUE) {
      continue;  // timeout — go round and re-check pending command.
    }

    // Drain any backlog that built up during a slow HTTP round-trip.
    {
      Snapshot newer{};
      while (xQueueReceive(snap_queue, &newer, 0) == pdTRUE) {
        snap = newer;
      }
    }

    if (!ensure_wifi()) {
      tls.stop();  // Drop stale connection on WiFi loss.
      continue;
    }

    // Heap guard only applies when a new TLS handshake is needed.
    // Reused sessions skip this entirely — no BIGNUM, no large allocation.
    if (!tls.connected()) {
      const uint32_t max_block = ESP.getMaxAllocHeap();
      Serial.printf("[wifi_up] new TLS session, heap max_block=%lu\n",
                    static_cast<unsigned long>(max_block));
      if (max_block < 45000U) {
        vTaskDelay(pdMS_TO_TICKS(2000));
        continue;
      }
    }

    char body[256];
    build_json(body, sizeof(body), snap);

    HTTPClient http;
    if (http.begin(tls, kUrl)) {
      http.addHeader("Content-Type",  "application/json");
      http.addHeader("apikey",        SUPABASE_KEY);
      http.addHeader("Authorization", "Bearer " SUPABASE_KEY);
      http.addHeader("Prefer",        "return=minimal");
      http.setTimeout(kHttpTimeoutMs);
      http.setReuse(true);  // Keep tls alive after http.end() so next POST reuses the session.
      const int code = http.POST(reinterpret_cast<uint8_t*>(body), strlen(body));
      if (code <= 0 || code >= 300) {
        Serial.printf("[wifi_up] POST %s  code=%d\n", kUrl, code);
        tls.stop();  // Force fresh handshake next iteration.
      }
      http.end();
    } else {
      Serial.printf("[wifi_up] http.begin() failed for %s\n", kUrl);
      tls.stop();
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

  const BaseType_t rc = xTaskCreatePinnedToCore(
      uploader_task,
      "wifi_up",
      kTaskStackBytes,
      nullptr,
      1,
      nullptr,
      0);
  (void)rc;
}

void push(const Snapshot& snap) {
  if (snap_queue == nullptr) return;
  if (!g_radio_enabled.load(std::memory_order_relaxed)) return;
  xQueueSend(snap_queue, &snap, 0);
}

void set_enabled(bool on) {
  g_radio_enabled.store(on, std::memory_order_relaxed);
}

bool is_connected() {
  // Read the Core-0-maintained cache — never call WiFi.status() from Core 1.
  return g_wifi_connected_cache.load(std::memory_order_relaxed);
}

bool current_ssid(char* out, size_t cap) {
  if (out == nullptr || cap == 0) return false;
  portENTER_CRITICAL(&g_active_mux);
  std::strncpy(out, g_active_ssid, cap - 1);
  out[cap - 1] = '\0';
  portEXIT_CRITICAL(&g_active_mux);
  return out[0] != '\0';
}

void apply_credentials(const char* ssid, const char* pass) {
  if (ssid == nullptr || pass == nullptr) return;

  // Persist first so a power loss between persist and reconnect leaves
  // the device with the correct config on next boot.
  persist_credentials(ssid, pass);

  portENTER_CRITICAL(&g_pending_mux);
  g_pending.cmd = WifiCmd::Apply;
  std::strncpy(g_pending.ssid, ssid, kSsidCap - 1);
  g_pending.ssid[kSsidCap - 1] = '\0';
  std::strncpy(g_pending.pass, pass, kPassCap - 1);
  g_pending.pass[kPassCap - 1] = '\0';
  portEXIT_CRITICAL(&g_pending_mux);
}

void forget_credentials() {
  persist_forget();

  portENTER_CRITICAL(&g_pending_mux);
  g_pending.cmd = WifiCmd::Forget;
  g_pending.ssid[0] = '\0';
  g_pending.pass[0] = '\0';
  portEXIT_CRITICAL(&g_pending_mux);
}

void reset_to_defaults() {
  // Clear NVS first so even if the queued command is dropped, the next
  // boot still picks up the compiled defaults.
  persist_clear();

  portENTER_CRITICAL(&g_pending_mux);
  g_pending.cmd = WifiCmd::ResetDefaults;
  g_pending.ssid[0] = '\0';
  g_pending.pass[0] = '\0';
  portEXIT_CRITICAL(&g_pending_mux);
}

}  // namespace wifi_uploader
