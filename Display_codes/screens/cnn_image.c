#include "../ui.h"

#ifndef LV_ATTRIBUTE_MEM_ALIGN
#define LV_ATTRIBUTE_MEM_ALIGN
#endif

/* CNN image: 200x200, NATIVE_WITH_ALPHA (RGB565 + A8, 3 bytes/pixel).
   Transparent-background format, matching the ui_img_asset_5_png reference.
   Replace this placeholder array with a proper LVGL NATIVE_WITH_ALPHA export
   (use LVGL Image Converter with "Output format: C array" and alpha enabled)
   to display real CNN content. Currently all-transparent (invisible placeholder). */
const LV_ATTRIBUTE_MEM_ALIGN uint8_t cnn_image_map[200 * 200 * 3] = {0};

const lv_image_dsc_t cnn_image = {
    .header.w = 200,
    .header.h = 200,
    .data_size = sizeof(cnn_image_map),
    .header.cf = LV_COLOR_FORMAT_NATIVE_WITH_ALPHA,
    .header.magic = LV_IMAGE_HEADER_MAGIC,
    .data = cnn_image_map
};
