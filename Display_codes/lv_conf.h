#ifndef LV_CONF_H
#define LV_CONF_H

/* Match SquareLine project requirements */
#define LV_COLOR_DEPTH 16

/* Target ~30 FPS redraw cadence — ESP32+SPI can't sustain 60 FPS anyway */
#define LV_DEF_REFR_PERIOD 33

/* Fonts used by generated UI */
#define LV_FONT_MONTSERRAT_10 1
#define LV_FONT_MONTSERRAT_16 1
#define LV_FONT_MONTSERRAT_20 1
#define LV_FONT_MONTSERRAT_24 1
#define LV_FONT_MONTSERRAT_28 1
#define LV_FONT_MONTSERRAT_30 1
#define LV_FONT_MONTSERRAT_48 1

#endif
