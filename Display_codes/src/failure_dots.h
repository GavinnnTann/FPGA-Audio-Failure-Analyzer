#pragma once

#include <Arduino.h>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

namespace failure_dots {

void initialize(lv_obj_t* screen, lv_obj_t* arc);

// Register a widget that must always render above the dots — typically a
// floating panel like a TabView. Whenever a *new* dot widget is created
// it lands at the top of its parent's z-order; this module then
// re-foregrounds the registered overlay if it is currently visible, so a
// fresh anomaly never punches through the open overlay.
void set_overlay(lv_obj_t* overlay);

void add_dot(uint32_t total_sec, uint8_t severity);
void refresh(uint32_t total_sec);

}  // namespace failure_dots
