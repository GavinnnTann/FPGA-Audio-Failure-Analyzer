#pragma once

#include <Arduino.h>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

namespace failure_dots {

void initialize(lv_obj_t* screen, lv_obj_t* arc);
void add_dot(uint32_t total_sec, uint8_t severity);
void refresh(uint32_t total_sec);

}  // namespace failure_dots
