#include "settings.h"

#include "hardware.h"
#include "wifi_uploader.h"

namespace {

bool s_vibration_enabled = true;
// WiFi is off at boot: the radio stays powered down and no telemetry is
// uploaded until the user turns on "WiFi Upload" in Settings. Screen2 reads
// this to set the switch's initial position, so the two always agree.
bool s_wifi_upload_enabled = false;
uint8_t s_brightness = hardware::BacklightDefault;

}  // namespace

extern "C" {

bool settings_vibration_enabled(void) {
  return s_vibration_enabled;
}

void settings_set_vibration_enabled(bool on) {
  s_vibration_enabled = on;
}

bool settings_wifi_upload_enabled(void) {
  return s_wifi_upload_enabled;
}

void settings_set_wifi_upload_enabled(bool on) {
  s_wifi_upload_enabled = on;
  // Drive the radio itself, not just the upload gate — otherwise the switch
  // would leave WiFi associated while merely suppressing the POSTs.
  wifi_uploader::set_enabled(on);
}

uint8_t settings_brightness(void) {
  return s_brightness;
}

void settings_set_brightness(uint8_t level) {
  s_brightness = level;
  hardware::set_backlight(level);
}

bool settings_wifi_current_ssid(char* out, size_t cap) {
  return wifi_uploader::current_ssid(out, cap);
}

void settings_wifi_apply(const char* ssid, const char* pass) {
  wifi_uploader::apply_credentials(ssid, pass);
}

void settings_wifi_forget(void) {
  wifi_uploader::forget_credentials();
}

void settings_wifi_reset_to_defaults(void) {
  wifi_uploader::reset_to_defaults();
}

void settings_set_dot_overlay(lv_obj_t* overlay) {
  (void)overlay;  // failure_dots removed
}

}  // extern "C"
