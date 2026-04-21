/* Screen 4 – QR Code "Scan to access webapp"
 *
 * Layout (480 × 320):
 *   Left half  : QR code image centred (198 × 198 px)
 *   Right half : vertical stack — URL label + "SCAN TO ACCESS" heading
 *                + tap-anywhere-to-go-back hint
 *
 * Tapping anywhere on the screen returns to Screen 2.
 */

#include "../ui.h"

/* Forward-declared by the linker from ui_img_qr_code.c */
extern const lv_img_dsc_t ui_img_qr_code;

lv_obj_t * ui_Screen4 = NULL;

static void back_to_screen2(lv_event_t * e)
{
    lv_screen_load_anim(ui_Screen2,
                        LV_SCR_LOAD_ANIM_MOVE_RIGHT,
                        220, 0, false);
}

void ui_Screen4_screen_init(void)
{
    /* ── root screen ────────────────────────────────────────────────────── */
    ui_Screen4 = lv_obj_create(NULL);
    lv_obj_set_size(ui_Screen4, 480, 320);
    lv_obj_set_style_bg_color(ui_Screen4, lv_color_hex(0x060808), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(ui_Screen4, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_remove_flag(ui_Screen4, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_flag(ui_Screen4, LV_OBJ_FLAG_CLICKABLE);
    lv_obj_add_event_cb(ui_Screen4, back_to_screen2, LV_EVENT_CLICKED, NULL);

    /* ── subtle grid-dot background (matches webapp aesthetic) ─────────── */
    /* No canvas needed — just a dark bg; the QR itself provides contrast. */

    /* ── thin teal top rule ─────────────────────────────────────────────── */
    lv_obj_t * top_rule = lv_obj_create(ui_Screen4);
    lv_obj_remove_flag(top_rule, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_size(top_rule, 480, 2);
    lv_obj_align(top_rule, LV_ALIGN_TOP_MID, 0, 0);
    lv_obj_set_style_bg_color(top_rule, lv_color_hex(0x00CCB8), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(top_rule, LV_OPA_COVER, LV_PART_MAIN);
    lv_obj_set_style_border_width(top_rule, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(top_rule, 0, LV_PART_MAIN);

    /* ── QR code image (left, centred vertically) ───────────────────────── */
    lv_obj_t * qr_img = lv_image_create(ui_Screen4);
    lv_image_set_src(qr_img, &ui_img_qr_code);
    lv_obj_align(qr_img, LV_ALIGN_LEFT_MID, 20, 0);
    /* White border frame around QR */
    lv_obj_set_style_border_color(qr_img, lv_color_hex(0xFFFFFF), LV_PART_MAIN);
    lv_obj_set_style_border_width(qr_img, 3, LV_PART_MAIN);
    lv_obj_set_style_border_opa(qr_img, LV_OPA_30, LV_PART_MAIN);
    lv_obj_set_style_radius(qr_img, 4, LV_PART_MAIN);

    /* ── right-side text column ─────────────────────────────────────────── */
    lv_obj_t * col = lv_obj_create(ui_Screen4);
    lv_obj_remove_flag(col, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_size(col, 210, LV_SIZE_CONTENT);
    lv_obj_align(col, LV_ALIGN_RIGHT_MID, -16, 0);
    lv_obj_set_style_bg_opa(col, LV_OPA_TRANSP, LV_PART_MAIN);
    lv_obj_set_style_border_width(col, 0, LV_PART_MAIN);
    lv_obj_set_flex_flow(col, LV_FLEX_FLOW_COLUMN);
    lv_obj_set_flex_align(col, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER, LV_FLEX_ALIGN_CENTER);
    lv_obj_set_style_pad_row(col, 14, LV_PART_MAIN);
    lv_obj_set_style_pad_all(col, 0, LV_PART_MAIN);

    /* "SCAN TO" */
    lv_obj_t * lbl_scan = lv_label_create(col);
    lv_label_set_text(lbl_scan, "SCAN TO");
    lv_obj_set_style_text_font(lbl_scan, &lv_font_montserrat_28, LV_PART_MAIN);
    lv_obj_set_style_text_color(lbl_scan, lv_color_hex(0x00CCB8), LV_PART_MAIN);
    lv_obj_set_style_text_letter_space(lbl_scan, 4, LV_PART_MAIN);

    /* "ACCESS WEBAPP" */
    lv_obj_t * lbl_access = lv_label_create(col);
    lv_label_set_text(lbl_access, "ACCESS WEBAPP");
    lv_obj_set_style_text_font(lbl_access, &lv_font_montserrat_16, LV_PART_MAIN);
    lv_obj_set_style_text_color(lbl_access, lv_color_hex(0x6AB8B0), LV_PART_MAIN);
    lv_obj_set_style_text_letter_space(lbl_access, 2, LV_PART_MAIN);

    /* thin teal divider */
    lv_obj_t * divider = lv_obj_create(col);
    lv_obj_remove_flag(divider, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_size(divider, 160, 1);
    lv_obj_set_style_bg_color(divider, lv_color_hex(0x00CCB8), LV_PART_MAIN);
    lv_obj_set_style_bg_opa(divider, LV_OPA_40, LV_PART_MAIN);
    lv_obj_set_style_border_width(divider, 0, LV_PART_MAIN);
    lv_obj_set_style_radius(divider, 0, LV_PART_MAIN);

    /* URL label */
    lv_obj_t * lbl_url = lv_label_create(col);
    lv_label_set_text(lbl_url, "audio-failure-analyzer\n.vercel.app");
    lv_label_set_long_mode(lbl_url, LV_LABEL_LONG_WRAP);
    lv_obj_set_width(lbl_url, 200);
    lv_obj_set_style_text_align(lbl_url, LV_TEXT_ALIGN_CENTER, LV_PART_MAIN);
    lv_obj_set_style_text_font(lbl_url, &lv_font_montserrat_10, LV_PART_MAIN);
    lv_obj_set_style_text_color(lbl_url, lv_color_hex(0x1E4E4A), LV_PART_MAIN);
    lv_obj_set_style_text_letter_space(lbl_url, 1, LV_PART_MAIN);

    /* back hint */
    lv_obj_t * lbl_hint = lv_label_create(col);
    lv_label_set_text(lbl_hint, "TAP ANYWHERE TO GO BACK");
    lv_obj_set_style_text_font(lbl_hint, &lv_font_montserrat_10, LV_PART_MAIN);
    lv_obj_set_style_text_color(lbl_hint, lv_color_hex(0x1E4E4A), LV_PART_MAIN);
    lv_obj_set_style_text_letter_space(lbl_hint, 1, LV_PART_MAIN);
}

void ui_Screen4_screen_destroy(void)
{
    if (ui_Screen4 != NULL) {
        lv_obj_delete(ui_Screen4);
        ui_Screen4 = NULL;
    }
}
