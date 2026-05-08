// Preload/Splash Screen for 480x320 display
// Displays the 480x320 RGB565 logo (Logo Light.c, ~300 KB) centred on a white background.

#include "../ui.h"

lv_obj_t * ui_Screen1 = NULL;
lv_obj_t * ui_Panel1  = NULL;

void ui_Screen1_screen_init(void)
{
    ui_Screen1 = lv_obj_create(NULL);
    lv_obj_remove_flag(ui_Screen1, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_color(ui_Screen1, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Screen1, LV_OPA_COVER, LV_PART_MAIN);

    ui_Panel1 = lv_obj_create(ui_Screen1);
    lv_obj_set_size(ui_Panel1, 480, 320);
    lv_obj_set_align(ui_Panel1, LV_ALIGN_CENTER);
    lv_obj_remove_flag(ui_Panel1, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_bg_opa(ui_Panel1, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(ui_Panel1, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(ui_Panel1, 0, LV_PART_MAIN);
    lv_obj_set_style_pad_all(ui_Panel1, 0, LV_PART_MAIN);

    lv_obj_t * img = lv_image_create(ui_Panel1);
    lv_image_set_src(img, &logo_light);
    lv_obj_align(img, LV_ALIGN_CENTER, 0, 0);
}

void ui_Screen1_screen_destroy(void)
{
    if (ui_Screen1) lv_obj_del(ui_Screen1);
    ui_Screen1 = NULL;
    ui_Panel1  = NULL;
}
