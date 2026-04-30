#include "wifi_uploader.h"
#include "wifi_config.h"

#include <Arduino.h>
#include <HTTPClient.h>
#include <Preferences.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
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

// ---- WiFi state machine (runs only on the uploader task) -------------------

void set_active_ssid(const char* ssid) {
  portENTER_CRITICAL(&g_active_mux);
  std::strncpy(g_active_ssid, ssid ? ssid : "", kSsidCap - 1);
  g_active_ssid[kSsidCap - 1] = '\0';
  portEXIT_CRITICAL(&g_active_mux);
}

void connect_wifi(const char* ssid, const char* pass) {
  WiFi.persistent(false);
  WiFi.mode(WIFI_STA);
  WiFi.setSleep(false);
  WiFi.setAutoReconnect(true);
  WiFi.disconnect(true, false);
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
  connect_wifi(ssid, pass);
}

void process_pending_command() {
  PendingCommand cmd;
  portENTER_CRITICAL(&g_pending_mux);
  cmd = g_pending;
  g_pending.cmd = WifiCmd::None;
  portEXIT_CRITICAL(&g_pending_mux);

  switch (cmd.cmd) {
    case WifiCmd::Apply:
      connect_wifi(cmd.ssid, cmd.pass);
      break;
    case WifiCmd::Forget:
      disconnect_wifi();
      break;
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
  apply_initial_credentials();

  while (true) {
    // Always check for credential changes before touching the queue so a
    // pending Apply / Forget is honoured promptly.
    process_pending_command();

    Snapshot snap{};
    if (xQueueReceive(snap_queue, &snap, pdMS_TO_TICKS(kCommandPollMs)) != pdTRUE) {
      continue;  // timeout — go round and re-check pending command.
    }

    // Drain any backlog that built up during a slow HTTP round-trip;
    // keep only the most recent snapshot so the dashboard shows live data.
    {
      Snapshot newer{};
      while (xQueueReceive(snap_queue, &newer, 0) == pdTRUE) {
        snap = newer;
      }
    }

    if (!ensure_wifi()) {
      continue;
    }

    char body[256];
    build_json(body, sizeof(body), snap);

    const uint32_t max_block = ESP.getMaxAllocHeap();
    if (max_block < 40000U) {
      vTaskDelay(pdMS_TO_TICKS(2000));
      continue;
    }

    WiFiClientSecure tls;
    HTTPClient       http;
    tls.setInsecure();

    if (http.begin(tls, kUrl)) {
      http.addHeader("Content-Type",  "application/json");
      http.addHeader("apikey",        SUPABASE_KEY);
      http.addHeader("Authorization", "Bearer " SUPABASE_KEY);
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
  xQueueSend(snap_queue, &snap, 0);
}

bool is_connected() {
  return WiFi.status() == WL_CONNECTED;
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

}  // namespace wifi_uploader
