#ifndef UI_SCREEN3_H
#define UI_SCREEN3_H

#ifdef __cplusplus
extern "C" {
#endif

// SCREEN: ui_Screen3
extern void ui_Screen3_screen_init(void);
extern void ui_Screen3_screen_destroy(void);
extern lv_obj_t * ui_Screen3;

void ui_screen3_update_spectrogram(const uint16_t *bins, uint8_t count);
void ui_screen3_tick(uint32_t now_ms);

#ifdef __cplusplus
} /*extern "C"*/
#endif

#endif
