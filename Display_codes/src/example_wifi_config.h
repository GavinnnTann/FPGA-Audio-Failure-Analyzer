/*  example_wifi_config.h  –  Template for wifi_config.h
 *
 *  Copy this file to src/wifi_config.h and fill in your credentials.
 *  wifi_config.h is gitignored — never commit the live credentials file.
 *
 *  Supabase setup (one-time):
 *  1. Create a project at https://supabase.com
 *  2. Open the SQL editor and run:
 *
 *     CREATE TABLE telemetry (
 *       id          BIGSERIAL PRIMARY KEY,
 *       device_ms   BIGINT       NOT NULL,   -- ESP32 millis()
 *       inserted_at TIMESTAMPTZ  DEFAULT NOW(),
 *       rms         SMALLINT,
 *       result      SMALLINT,
 *       flags       SMALLINT,
 *       seq         SMALLINT,
 *       metric      SMALLINT,
 *       anomaly     BOOLEAN,
 *       cnn_ran     BOOLEAN,
 *       fpga_active BOOLEAN
 *     );
 *
 *     ALTER TABLE telemetry ENABLE ROW LEVEL SECURITY;
 *
 *     CREATE POLICY "anon insert"
 *       ON telemetry FOR INSERT TO anon
 *       WITH CHECK (true);
 *
 *  3. Copy your Project URL and anon/publishable key from:
 *     Supabase Dashboard → Settings → API
 */

#pragma once

// ---- WiFi network -----------------------------------------------------------
#define WIFI_SSID       "YOUR_WIFI_SSID"
#define WIFI_PASS       "YOUR_WIFI_PASSWORD"

// ---- Supabase project -------------------------------------------------------
// e.g. "https://abcdefghijkl.supabase.co"  (no trailing slash)
#define SUPABASE_HOST   "https://XXXXXXXXXXXXXXXXXXXX.supabase.co"

// anon/publishable key from Settings → API → Project API keys
#define SUPABASE_KEY    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.PLACEHOLDER"

// Table name created above
#define SUPABASE_TABLE  "telemetry"

// ---- Upload rate ------------------------------------------------------------
// Minimum milliseconds between consecutive HTTP POSTs (2 s = 0.5 req/s).
// Supabase free tier is rate-limited; keep this >= 1000.
#define UPLOAD_INTERVAL_MS  2000U

// ---- WiFi timing ------------------------------------------------------------
// How long (ms) to wait for WiFi association before giving up.
#define WIFI_CONNECT_TIMEOUT_MS  15000U

// How long (ms) to wait before retrying after a failed WiFi connection.
#define WIFI_RETRY_DELAY_MS      15000U

// How long (ms) to wait for a single HTTP POST round-trip.
#define WIFI_HTTP_TIMEOUT_MS     6000U
