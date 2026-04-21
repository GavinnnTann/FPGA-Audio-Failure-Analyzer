#pragma once

#include <Arduino.h>
#include <Adafruit_FT6206.h>
#include <TFT_eSPI.h>

#if __has_include("lvgl.h")
#include "lvgl.h"
#else
#include "lvgl/lvgl.h"
#endif

namespace hardware {

constexpr int I2cSda = 18;
constexpr int I2cScl = 5;
constexpr int VibratorPin = 22;
constexpr int BatteryPin = 35;
constexpr int ChargingPin = 17;
constexpr int TouchThreshold = 80;
constexpr int TftHorRes = 480;
constexpr int TftVerRes = 320;
// 1/12 screen per buffer (2 buffers = ~51 KB total DMA).
// Reduced from 1/4 to keep enough contiguous heap free for TLS (~40 KB).
constexpr size_t DrawBufSize =
    (TftHorRes * TftVerRes / 12U * (LV_COLOR_DEPTH / 8U));

extern TFT_eSPI tft;
extern Adafruit_FT6206 ts;

void init_board_pins();
void init_touchscreen();
void init_display_panel();

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data);
void update_touch_state(); // Refresh cached touch state (I2C-throttled, safe to call every loop)
bool is_touch_pressed();   // Query cached touch state without triggering I2C
void flush_cb(lv_display_t* display, const lv_area_t* area, uint8_t* px_map);

}  // namespace hardware
