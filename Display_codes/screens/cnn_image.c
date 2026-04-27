#include "../ui.h"

extern const uint8_t audio_logo_map[];

const lv_image_dsc_t cnn_image = {
    .header.w = 583,
    .header.h = 356,
    .data_size = 583 * 356 * 2,
    .header.cf = LV_COLOR_FORMAT_RGB565,
    .header.magic = LV_IMAGE_HEADER_MAGIC,
    .data = audio_logo_map
};
