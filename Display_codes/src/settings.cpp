#include "settings.h"

#include "failure_dots.h"
#include "hardware.h"
#include "wifi_uploader.h"

namespace {

bool s_vibration_enabled = true;
bool s_wifi_upload_enabled = true;
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

void settings_set_dot_overlay(lv_obj_t* overlay) {
  failure_dots::set_overlay(overlay);
}

}  // extern "C"
