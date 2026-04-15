#include "hardware.h"

#include <Wire.h>

namespace hardware {

TFT_eSPI tft = TFT_eSPI();
Adafruit_FT6206 ts = Adafruit_FT6206();

namespace {

unsigned long previous_touch_timestamp = 0;
constexpr unsigned long kTouchCheckIntervalMs = 15;
lv_indev_state_t last_touch_state = LV_INDEV_STATE_RELEASED;
lv_point_t last_touch_point = {0, 0};

}  // namespace

void init_board_pins() {
  pinMode(VibratorPin, OUTPUT);
  pinMode(BatteryPin, INPUT);
  pinMode(ChargingPin, INPUT);
  digitalWrite(VibratorPin, LOW);
}

void init_touchscreen() {
  Wire.begin(I2cSda, I2cScl);
  // FT6206 is responsive at 400 kHz and this reduces touch read latency.
  Wire.setClock(400000);
  (void)ts.begin(TouchThreshold);
}

void init_display_panel() {
  tft.init();
  tft.setRotation(1);
  tft.fillScreen(TFT_BLACK);
}

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data) {
  (void)indev;
  const unsigned long now = millis();

  if (now - previous_touch_timestamp > kTouchCheckIntervalMs) {
    previous_touch_timestamp = now;
    const uint8_t touch_count = ts.touched();
    if (touch_count > 0) {
      TS_Point p = ts.getPoint(0);
      const int16_t y = map(p.x, 317, 11, 1, TftVerRes);
      const int16_t x = map(p.y, 20, 480, 1, TftHorRes);

      last_touch_state = LV_INDEV_STATE_PRESSED;
      last_touch_point.x = x;
      last_touch_point.y = y;
    } else {
      last_touch_state = LV_INDEV_STATE_RELEASED;
    }
  }

  data->state = last_touch_state;
  data->point = last_touch_point;
}

void flush_cb(lv_display_t* display, const lv_area_t* area, uint8_t* px_map) {
  const uint16_t width = static_cast<uint16_t>(area->x2 - area->x1 + 1);
  const uint16_t height = static_cast<uint16_t>(area->y2 - area->y1 + 1);

  tft.startWrite();
  tft.setAddrWindow(area->x1, area->y1, width, height);
  tft.pushColors(
      reinterpret_cast<uint16_t*>(px_map),
      static_cast<uint32_t>(width) * height,
      true);
  tft.endWrite();
  lv_display_flush_ready(display);
}

}  // namespace hardware
