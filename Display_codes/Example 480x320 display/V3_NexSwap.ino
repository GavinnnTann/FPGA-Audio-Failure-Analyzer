#include <Arduino.h>
#include <SPI.h>
#include <TFT_eSPI.h>
#include <FT6236.h>
#include <lvgl.h>
#include "ui.h"
#include <PN532.h>
#include <PN532_SPI.h>
#include <NfcAdapter.h>
#include "emulatetag.h"
#include "NdefMessage.h"


//#define VSPI_IRQ 36   // T_IRQ
#define VSPI_MISO 39  // T_DIN
#define VSPI_MOSI 32  // T_OUT
#define VSPI_CLK 25   // T_CLK
#define NFC_CS 33     // Chip Select for NFC module (HSPI)

// Touchscreen pins
#define TOUCH_THRESHOLD 80
#define I2C_SDA 18
#define I2C_SCL 5

#define vibratorPin 22
#define batteryPin 35
#define chargingPin 17

SPIClass spiVSPI = SPIClass(VSPI);  // VSPI for NFC and Tochscreen
PN532_SPI pn532spi(spiVSPI, NFC_CS);
EmulateTag nfcEmulator(pn532spi);  // Emulation mode

uint8_t ndefBuf[256];
NdefMessage message;

uint8_t uid[3] = { 0x12, 0x34, 0x56 };

FT6236 ts = FT6236();
unsigned long previousTouchTimestamp = 0;
unsigned long touchCheckInterval = 5;

#define NFC_EMULATION_INTERVAL 20  // Interval in milliseconds

unsigned long lastNfcEmulationTime = 0;
unsigned long lasttimeoutmillis = 0;
bool nfcEmulationInProgress = false;


TFT_eSPI tft;

void* draw_buf_1;

#define TFT_HOR_RES 480  // Width for portrait
#define TFT_VER_RES 320  // Height for portrait

static lv_display_t* disp;
static lv_timer_t* autoCloseTimer = NULL;


#define DRAW_BUF_SIZE (TFT_HOR_RES * TFT_VER_RES / 10 * (LV_COLOR_DEPTH / 8))

int x, y, z;

static bool isPanelVisible = true;

void nfcRead(void);

void unhideNfcLabel() {
  _ui_flag_modify(ui_Panel8, LV_OBJ_FLAG_HIDDEN, _UI_MODIFY_FLAG_REMOVE);
  Serial.println("Open");
  isPanelVisible = true;
}
void unhideNfcLabelAsync(void* param) {
  unhideNfcLabel();
}
void hideLabel() {
  _ui_flag_modify(ui_Panel8, LV_OBJ_FLAG_HIDDEN, _UI_MODIFY_FLAG_ADD);  // Hide the NFC panel
  _ui_flag_modify(ui_Panel7, LV_OBJ_FLAG_HIDDEN, _UI_MODIFY_FLAG_ADD);  // Hide the Matched panel
  Serial.println("Closed Panels");
  isPanelVisible = false;
}

void autoClosePanel(lv_timer_t* timer) {
  hideLabel();            // Call the hide function when timer expires
  lv_timer_del(timer);    // Delete timer after execution
  autoCloseTimer = NULL;  // Reset for reuse
}

void touchscreen_read(lv_indev_t* indev, lv_indev_data_t* data) {

  unsigned long currentTouchTimestamp = millis();
  bool needRefresh = true;

  if (currentTouchTimestamp - previousTouchTimestamp > touchCheckInterval) {
    previousTouchTimestamp = currentTouchTimestamp;
    for (int i = 0; i < ts.touched(); i++) {
      TS_Point p = ts.getPoint(i);
      //y = map(p.x, 317, 11, 320, 1);
      //x = map(p.y, 20, 480, 480, 1);
      y = map(p.x, 317, 11, 1, 320);
      x = map(p.y, 20, 480, 1, 480);
      Serial.print(x);
      Serial.print(" , ");
      Serial.println(y);

      data->state = LV_INDEV_STATE_PRESSED;
      data->point.x = x;
      data->point.y = y;
    }
  } else {
    data->state = LV_INDEV_STATE_RELEASED;
  }
}

void setup() {
  Serial.begin(115200);


  pinMode(batteryPin, INPUT);
  pinMode(chargingPin, INPUT);
  pinMode(vibratorPin, OUTPUT);

  lv_init();

  draw_buf_1 = heap_caps_malloc(DRAW_BUF_SIZE, MALLOC_CAP_DMA | MALLOC_CAP_INTERNAL);
  disp = lv_tft_espi_create(TFT_HOR_RES, TFT_VER_RES, draw_buf_1, DRAW_BUF_SIZE);
  if (!ts.begin(TOUCH_THRESHOLD, I2C_SDA, I2C_SCL)) {
    Serial.println("Unable to start the capacitive touchscreen.");
  }

  tft.begin();
  tft.setRotation(1);  // Set TFT to portrait mode

  lv_indev_t* indev = lv_indev_create();
  lv_indev_set_type(indev, LV_INDEV_TYPE_POINTER);
  lv_indev_set_read_cb(indev, touchscreen_read);

  //Initialize NFC emulator
  spiVSPI.begin(VSPI_CLK, VSPI_MISO, VSPI_MOSI, NFC_CS);
  nfcEmulator.init();

  NdefMessage message;
  message.addUriRecord("https://linkedin.com/in/gavinnn-tan");  // Add message as text record

  // Check and encode the message into the buffer
  int messageSize = message.getEncodedSize();
  if (messageSize > sizeof(ndefBuf)) {
    Serial.println("ndefBuf is too small for the message");
    while (1)
      ;  // Halt if buffer is insufficient
  }

  Serial.print("NDEF encoded message size: ");
  Serial.println(messageSize);

  message.encode(ndefBuf);  // Encode the NDEF message

  // Set the NDEF file and UID for emulation
  nfcEmulator.setNdefFile(ndefBuf, messageSize);
  nfcEmulator.setUid(uid);  // Set the UID for the tag

  ui_init();

  analogWrite(vibratorPin, 255);
  delay(500);
  analogWrite(vibratorPin, 0);

  lv_disp_load_scr(ui_Screen1);
  lv_task_handler();
  lv_tick_inc(2000);
  delay(2000);
  lv_disp_load_scr(ui_Screen2);
}

void loop() {

  //Serial.print("Free heap size: ");
  //Serial.println(esp_get_free_heap_size());
  //Serial.print("Flash size: ");
  //Serial.println(ESP.getFlashChipSize());

  nfcRead();


  lv_task_handler();
  lv_tick_inc(5);
  delay(5);
  //Serial.println("running");
}

void nfcRead() {
  nfcEmulator.init();
  unsigned long currentMillis = millis();
  if (currentMillis - lastNfcEmulationTime >= NFC_EMULATION_INTERVAL) {
    lastNfcEmulationTime = currentMillis;

    if (!nfcEmulationInProgress) {
      nfcEmulationInProgress = true;
      // Start NFC emulation
      bool success = nfcEmulator.emulate(NFC_EMULATION_INTERVAL);  // Short timeout for non-blocking behavior
      if (!success) {
        //Serial.println("Emulation timed out");
      } else {
        Serial.println("Emulated");
        lv_async_call(unhideNfcLabelAsync, NULL);
        lv_timer_create(autoClosePanel, 2000, NULL);
      }
      nfcEmulationInProgress = false;
    }
  }
}

