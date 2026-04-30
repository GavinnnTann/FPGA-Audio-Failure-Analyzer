#include "hardware.h"

#include <Wire.h>
#include <freertos/FreeRTOS.h>
#include <freertos/queue.h>
#include <freertos/semphr.h>
#include <freertos/task.h>

namespace hardware {

TFT_eSPI tft = TFT_eSPI();
Adafruit_FT6206 ts = Adafruit_FT6206();

namespace {

// Cached touch state, written by the Core-0 touch task and read by the
// LVGL input device callback on Core 1. Plain volatile is sufficient
// because the writer is single-producer and the reader tolerates
// occasional torn coordinates (LVGL re-reads on the next tick).
volatile lv_indev_state_t g_touch_state = LV_INDEV_STATE_RELEASED;
volatile int16_t g_touch_x = 0;
volatile int16_t g_touch_y = 0;

// Transition queue. Without this, a press+release that completes between
// two lv_timer_handler() polls is invisible to LVGL — both polls see the
// same cached state and the click is lost. The touch task enqueues every
// PRESSED↔RELEASED change; touchscreen_read drains them one per call so
// LVGL's gesture engine sees the full sequence even when render work
// stalls Core 1.
struct TouchEvent {
  lv_indev_state_t state;
  int16_t x;
  int16_t y;
};
constexpr UBaseType_t kTouchEventQueueDepth = 16;
QueueHandle_t g_touch_event_queue = nullptr;
bool g_last_published_pressed = false;

SemaphoreHandle_t g_touch_int_sem = nullptr;
constexpr TickType_t kTouchPollTicks = pdMS_TO_TICKS(5);
constexpr size_t kTouchTaskStack = 3072;
constexpr UBaseType_t kTouchTaskPriority = 3;  // Above wifi_up (1) so touch never starves.

void IRAM_ATTR touch_isr() {
  if (g_touch_int_sem != nullptr) {
    BaseType_t hp_woken = pdFALSE;
    xSemaphoreGiveFromISR(g_touch_int_sem, &hp_woken);
    if (hp_woken == pdTRUE) {
      portYIELD_FROM_ISR();
    }
  }
}

void publish_transition(lv_indev_state_t state) {
  if (g_touch_event_queue == nullptr) {
    return;
  }
  TouchEvent ev;
  ev.state = state;
  ev.x = g_touch_x;
  ev.y = g_touch_y;
  // Non-blocking; if LVGL is far behind we drop the oldest event so the
  // newest transition still gets through.
  if (xQueueSend(g_touch_event_queue, &ev, 0) != pdTRUE) {
    TouchEvent discard;
    xQueueReceive(g_touch_event_queue, &discard, 0);
    xQueueSend(g_touch_event_queue, &ev, 0);
  }
}

void read_ft6206_once() {
  const uint8_t touch_count = ts.touched();
  bool pressed_now;
  if (touch_count > 0) {
    TS_Point p = ts.getPoint(0);
    const int16_t y = map(p.x, 317, 11, 1, TftVerRes);
    const int16_t x = map(p.y, 20, 480, 1, TftHorRes);
    g_touch_x = x;
    g_touch_y = y;
    g_touch_state = LV_INDEV_STATE_PRESSED;
    pressed_now = true;
  } else {
    g_touch_state = LV_INDEV_STATE_RELEASED;
    pressed_now = false;
  }

  if (pressed_now != g_last_published_pressed) {
    g_last_published_pressed = pressed_now;
    publish_transition(pressed_now ? LV_INDEV_STATE_PRESSED
                                   : LV_INDEV_STATE_RELEASED);
  }
}

void touch_task(void* /*arg*/) {
  for (;;) {
    if (TouchIntPin >= 0 && g_touch_int_sem != nullptr) {
      // Wait for INT pulse from FT6206. Wake at least every 30 ms so we
      // still publish a release transition if the controller ever drops
      // the rising edge while the line was still held low.
      xSemaphoreTake(g_touch_int_sem, pdMS_TO_TICKS(30));
    } else {
      vTaskDelay(kTouchPollTicks);
    }
    read_ft6206_once();
  }
}

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

void init_backlight() {
  if (BacklightPin < 0) {
    return;
  }
  pinMode(BacklightPin, OUTPUT);
  // analogWrite on ESP32 Arduino wraps the LEDC PWM peripheral, so the CPU
  // never has to babysit the duty cycle.
  analogWrite(BacklightPin, BacklightDefault);
}

void set_backlight(uint8_t level) {
  if (BacklightPin < 0) {
    return;
  }
  analogWrite(BacklightPin, level);
}

void start_touch_task() {
  g_touch_event_queue = xQueueCreate(kTouchEventQueueDepth, sizeof(TouchEvent));

  if (TouchIntPin >= 0) {
    g_touch_int_sem = xSemaphoreCreateBinary();
    // GPIO34 is input-only on the ESP32 and has no internal pull resistor;
    // the FT6206 breakout supplies an external pull-up on TS_IRQ.
    pinMode(TouchIntPin, INPUT);
    attachInterrupt(digitalPinToInterrupt(TouchIntPin), touch_isr, FALLING);
  }

  xTaskCreatePinnedToCore(
      touch_task,
      "touch",
      kTouchTaskStack,
      nullptr,
      kTouchTaskPriority,
      nullptr,
      0);  // Core 0
}

bool is_touch_pressed() {
  return g_touch_state == LV_INDEV_STATE_PRESSED;
}

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data) {
  (void)indev;
  // Drain queued transitions before falling back to the live cached state.
  // Setting continue_reading tells LVGL to call us again immediately so
  // every press/release pair is processed in a single timer cycle.
  if (g_touch_event_queue != nullptr) {
    TouchEvent ev;
    if (xQueueReceive(g_touch_event_queue, &ev, 0) == pdTRUE) {
      data->state = ev.state;
      data->point.x = ev.x;
      data->point.y = ev.y;
      data->continue_reading = uxQueueMessagesWaiting(g_touch_event_queue) > 0;
      return;
    }
  }
  data->state = g_touch_state;
  data->point.x = g_touch_x;
  data->point.y = g_touch_y;
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
