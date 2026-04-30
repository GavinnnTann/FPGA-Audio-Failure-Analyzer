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
// GPIO connected to the FT6206 TS_IRQ line. The pin is asserted low while
// a finger is on the panel; the touch task wakes on the falling edge,
// drains the controller, and waits again. Set to -1 to fall back to a
// 5 ms poll on Core 0 (still off the render path).
constexpr int TouchIntPin = 34;

// GPIO connected to the TFT backlight. Set to your board's BL pin to
// enable the brightness slider in the Settings tab; leave at -1 if the
// backlight is hard-wired to VCC and the slider should be a no-op.
constexpr int BacklightPin = -1;
constexpr uint8_t BacklightDefault = 255;
// 1/12 screen per buffer (2 buffers = ~51 KB total DMA).
// Reduced from 1/4 to keep enough contiguous heap free for TLS (~40 KB).
constexpr size_t DrawBufSize =
    (TftHorRes * TftVerRes / 12U * (LV_COLOR_DEPTH / 8U));

extern TFT_eSPI tft;
extern Adafruit_FT6206 ts;

void init_board_pins();
void init_touchscreen();
void init_display_panel();

// Backlight helpers. init_backlight() configures BacklightPin for PWM and
// drives it to BacklightDefault. set_backlight(level) updates the duty.
// Both are no-ops if BacklightPin < 0 so unconfigured boards still work.
void init_backlight();
void set_backlight(uint8_t level);

// Spawn the touch task on Core 0. If TouchIntPin >= 0 the task blocks on
// a semaphore released by the FT6206 INT line; otherwise it polls every
// 5 ms. Either way the I2C transaction never runs on Core 1.
void start_touch_task();

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data);
bool is_touch_pressed();   // Cached, lock-free read for use on any core.
void flush_cb(lv_display_t* display, const lv_area_t* area, uint8_t* px_map);

}  // namespace hardware
