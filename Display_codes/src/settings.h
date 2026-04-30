#pragma once

#include <stdbool.h>
#include <stdint.h>

/* Runtime-tunable user preferences. All values live in process memory only —
 * the tab UI in ui_Screen2 mutates them through these setters; main.cpp and
 * other modules read them through the matching getters.
 *
 * The interface is plain C so the SquareLine-generated UI files (.c) can
 * drive it directly without C++ name-mangling concerns.
 */

#ifdef __cplusplus
extern "C" {
#endif

bool settings_vibration_enabled(void);
void settings_set_vibration_enabled(bool on);

bool settings_wifi_upload_enabled(void);
void settings_set_wifi_upload_enabled(bool on);

uint8_t settings_brightness(void);
void settings_set_brightness(uint8_t level);

#include <stddef.h>

/* Thin C wrappers around wifi_uploader's persisted credential API so the
 * SquareLine-generated .c files (e.g. ui_Screen2.c) can drive WiFi
 * configuration without pulling in C++ headers. */
bool settings_wifi_current_ssid(char* out, size_t cap);
void settings_wifi_apply(const char* ssid, const char* pass);
void settings_wifi_forget(void);

/* Forward-declare lv_obj_t to avoid pulling lvgl.h into translation units
 * that don't already use it. The pointer is opaque from settings'
 * perspective; the implementation forwards it to failure_dots. */
struct _lv_obj_t;
typedef struct _lv_obj_t lv_obj_t;
void settings_set_dot_overlay(lv_obj_t* overlay);

#ifdef __cplusplus
}
#endif
