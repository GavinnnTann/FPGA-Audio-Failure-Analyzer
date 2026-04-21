/*  Screen 3 – Waterfall Spectrogram
 *
 *  X-axis : time   (scrolls right-to-left, newest on the right)
 *  Y-axis : frequency  (DC / low at bottom, high at top)
 *  Colour : amplitude  (dark → teal → cyan → white)
 *
 *  Implementation: a 230 × 64 RGB565 canvas (~29 KB) scaled 2×
 *  horizontally and 3× vertically → 460 × 192 display pixels.
 *  Each new spectrogram burst shifts the buffer one pixel-column
 *  left and paints the 64 new bins as the rightmost column.
 *  Only that column is new work; the rest is a cheap memmove.
 */

#include "../ui.h"

#include <stdlib.h>
#include <string.h>

lv_obj_t * ui_Screen3 = NULL;

/* ---- geometry ----------------------------------------------------------- */

enum {
    kSpectrogramBins  = 64,
    kCanvasW          = 230,    /* native pixels – one per data burst        */
    kCanvasH          = 64,     /* one row per frequency bin                 */
    kBytesPerPx       = 2,      /* RGB565                                    */
    kDisplayScaleX    = 512,    /* 2 × 256  (LVGL: 256 = 1×)                */
    kDisplayScaleY    = 512,    /* 2 × 256  → visible 460 × 128 px          */
    kScaleMin         = 300
};

/* ---- widgets ------------------------------------------------------------ */

static lv_obj_t * ui_LabelTitle  = NULL;
static lv_obj_t * ui_LabelHint   = NULL;
static lv_obj_t * ui_LabelScale  = NULL;
static lv_obj_t * ui_Canvas      = NULL;

/* ---- state -------------------------------------------------------------- */

static uint16_t cached_scale         = 600;
static uint8_t  spec_data_dirty      = 0;
static uint32_t last_redraw_ms       = 0;
static uint16_t last_displayed_scale = 0;

static const uint32_t kMinRedrawIntervalMs = 80;   /* ~12 Hz cap */

/* ---- colour look-up table (amplitude 0-255 → RGB565) -------------------- */

static uint16_t amp_lut[256];

/* ---- canvas pixel buffer  (230 × 64 × 2 = 29 440 bytes, heap-allocated) - */
/* Kept on heap rather than BSS so TLS/WiFi static data can share DRAM.      */

static uint8_t *canvas_buf = NULL;

static const uint32_t kStride = (uint32_t)kCanvasW * kBytesPerPx;

/* ---- helpers ------------------------------------------------------------ */

static uint16_t pack_rgb565(uint8_t r, uint8_t g, uint8_t b)
{
    return (uint16_t)(((uint16_t)(r & 0xF8U) << 8) |
                      ((uint16_t)(g & 0xFCU) << 3) |
                      ((uint16_t) b >> 3));
}

/*
 * Build an inferno/magma colour ramp (high contrast):
 *   0 → near-black  …  64 → dark purple  …  128 → magenta
 *   192 → orange    … 255 → pale yellow/white
 */
static void build_amp_lut(void)
{
    /* 9 key-stops sampled from the inferno colourmap. */
    static const uint8_t stops[][3] = {
        {  0,   0,   4},   /* 0   : near-black          */
        { 22,  11,  57},   /* 32  : dark indigo          */
        { 66,  10, 104},   /* 64  : dark purple          */
        {106,  23, 110},   /* 96  : purple               */
        {147,  38, 103},   /* 128 : magenta              */
        {188,  55,  84},   /* 160 : pinkish-red          */
        {221,  89,  46},   /* 192 : orange               */
        {246, 150,  20},   /* 224 : yellow-orange        */
        {252, 255, 164},   /* 255 : pale yellow / white  */
    };
    static const uint8_t pos[] = {0, 32, 64, 96, 128, 160, 192, 224, 255};
    const int n_stops = (int)(sizeof(pos) / sizeof(pos[0]));

    for (int i = 0; i < 256; i++) {
        /* find the two stops that bracket i */
        int seg = n_stops - 2;
        for (int s = 0; s < n_stops - 1; s++) {
            if (i <= (int)pos[s + 1]) { seg = s; break; }
        }
        const int lo = (int)pos[seg];
        const int hi = (int)pos[seg + 1];
        const int span = hi - lo;
        const int t = i - lo;   /* 0 .. span */

        uint8_t r = (uint8_t)(stops[seg][0] + (int)(stops[seg+1][0] - stops[seg][0]) * t / span);
        uint8_t g = (uint8_t)(stops[seg][1] + (int)(stops[seg+1][1] - stops[seg][1]) * t / span);
        uint8_t b = (uint8_t)(stops[seg][2] + (int)(stops[seg+1][2] - stops[seg][2]) * t / span);

        amp_lut[i] = pack_rgb565(r, g, b);
    }
}

static void ui_event_Screen3_back(lv_event_t * e)
{
    if (lv_event_get_code(e) == LV_EVENT_CLICKED) {
        lv_disp_load_scr(ui_Screen2);
    }
}

static uint16_t compute_peak(const uint16_t *bins, uint8_t count)
{
    uint16_t peak = 0;
    for (uint8_t i = 0; i < count; i++) {
        if (bins[i] > peak) peak = bins[i];
    }
    return peak;
}

/* ---- public API --------------------------------------------------------- */

void ui_screen3_update_spectrogram(const uint16_t *bins, uint8_t count)
{
    if (bins == NULL) return;

    /* Skip the expensive memmove + pixel work when Screen3 is not visible.
     * All screens are created at init so ui_Canvas is always non-NULL;
     * we must check the active screen instead.                             */
    if (lv_screen_active() != ui_Screen3) return;

    const uint8_t n = (count > kSpectrogramBins)
                          ? (uint8_t)kSpectrogramBins : count;

    /* ---- adaptive auto-scale ------------------------------------------- */
    const uint16_t peak = compute_peak(bins, n);
    if (peak > cached_scale) {
        cached_scale = peak;
    } else {
        cached_scale = (uint16_t)(((uint32_t)cached_scale * 995U) / 1000U);
    }
    if (cached_scale < (uint16_t)kScaleMin) {
        cached_scale = (uint16_t)kScaleMin;
    }

    /* ---- scroll canvas left by one pixel column ------------------------ */
    for (int y = 0; y < kCanvasH; y++) {
        uint8_t *row = canvas_buf + (uint32_t)y * kStride;
        memmove(row, row + kBytesPerPx, kStride - kBytesPerPx);
    }

    /* ---- paint the new rightmost column -------------------------------- */
    const uint16_t scale = cached_scale;
    uint16_t *buf16 = (uint16_t *)canvas_buf;

    for (uint8_t i = 0; i < n; i++) {
        uint32_t norm = ((uint32_t)bins[i] * 255U) / (uint32_t)scale;
        if (norm > 255U) norm = 255U;

        /* bin 0 (DC / lowest freq) at bottom row of the canvas */
        const int y = kCanvasH - 1 - (int)i;
        buf16[y * kCanvasW + (kCanvasW - 1)] = amp_lut[norm];
    }

    spec_data_dirty = 1;
}

void ui_screen3_tick(uint32_t now_ms)
{
    if (ui_Canvas == NULL) return;
    if (!spec_data_dirty) return;
    if (now_ms - last_redraw_ms < kMinRedrawIntervalMs) return;

    last_redraw_ms  = now_ms;
    spec_data_dirty = 0;

    /* Quantise to nearest 10 to reduce label redraws. */
    {
        uint16_t dscale = (uint16_t)(((uint32_t)cached_scale + 5U) / 10U * 10U);
        if (dscale != last_displayed_scale) {
            last_displayed_scale = dscale;
            char txt[48];
            lv_snprintf(txt, sizeof(txt), "scale %u", (unsigned)dscale);
            lv_label_set_text(ui_LabelScale, txt);
        }
    }

    lv_obj_invalidate(ui_Canvas);
}

/* ---- screen lifecycle --------------------------------------------------- */

void ui_Screen3_screen_init(void)
{
    ui_Screen3 = lv_obj_create(NULL);
    lv_obj_remove_flag(ui_Screen3, LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_add_event_cb(ui_Screen3, ui_event_Screen3_back,
                        LV_EVENT_CLICKED, NULL);

    lv_obj_set_style_bg_color(ui_Screen3, lv_color_hex(0x0D141B),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_Screen3, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- Title --------------------------------------------------------- */
    ui_LabelTitle = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelTitle, "Spectrogram");
    lv_obj_set_align(ui_LabelTitle, LV_ALIGN_TOP_MID);
    lv_obj_set_y(ui_LabelTitle, 8);
    lv_obj_set_style_text_color(ui_LabelTitle, lv_color_hex(0xEAF6FF),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelTitle, &lv_font_montserrat_24,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- Hint ---------------------------------------------------------- */
    ui_LabelHint = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelHint, "Tap anywhere to return");
    lv_obj_set_align(ui_LabelHint, LV_ALIGN_TOP_RIGHT);
    lv_obj_set_x(ui_LabelHint, -10);
    lv_obj_set_y(ui_LabelHint, 12);
    lv_obj_set_style_text_color(ui_LabelHint, lv_color_hex(0x86A1B8),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelHint, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- Canvas (waterfall pixel buffer) -------------------------------- */
    const size_t buf_bytes = (size_t)(kCanvasW * kCanvasH * kBytesPerPx);
    if (canvas_buf == NULL) {
        canvas_buf = (uint8_t *)malloc(buf_bytes);
    }
    if (canvas_buf == NULL) return; /* allocation failed — bail out */
    memset(canvas_buf, 0, buf_bytes);

    ui_Canvas = lv_canvas_create(ui_Screen3);
    lv_canvas_set_buffer(ui_Canvas, canvas_buf,
                         kCanvasW, kCanvasH, LV_COLOR_FORMAT_RGB565);

    /* Let clicks pass through to ui_Screen3 so "tap to return" works
     * even when tapping on the canvas area.                               */
    lv_obj_remove_flag(ui_Canvas, LV_OBJ_FLAG_CLICKABLE);

    /* Position at centre, push down a little for the title bar.           */
    lv_obj_set_align(ui_Canvas, LV_ALIGN_CENTER);
    lv_obj_set_y(ui_Canvas, 14);

    /* 2× horizontal, 3× vertical → 460 × 192 display pixels.             */
    lv_image_set_scale_x(ui_Canvas, (uint32_t)kDisplayScaleX);
    lv_image_set_scale_y(ui_Canvas, (uint32_t)kDisplayScaleY);
    lv_image_set_pivot(ui_Canvas, kCanvasW / 2, kCanvasH / 2);

    /* ---- Scale label --------------------------------------------------- */
    ui_LabelScale = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelScale, "scale 600");
    lv_obj_set_align(ui_LabelScale, LV_ALIGN_BOTTOM_LEFT);
    lv_obj_set_x(ui_LabelScale, 12);
    lv_obj_set_y(ui_LabelScale, -8);
    lv_obj_set_style_text_color(ui_LabelScale, lv_color_hex(0x8FB3D2),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelScale, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- init state ---------------------------------------------------- */
    build_amp_lut();
    cached_scale         = 600;
    spec_data_dirty      = 0;
    last_redraw_ms       = 0;
    last_displayed_scale = 0;
}

void ui_Screen3_screen_destroy(void)
{
    if (ui_Screen3) lv_obj_del(ui_Screen3);

    if (canvas_buf != NULL) {
        free(canvas_buf);
        canvas_buf = NULL;
    }

    ui_Screen3    = NULL;
    ui_Canvas     = NULL;
    ui_LabelTitle = NULL;
    ui_LabelHint  = NULL;
    ui_LabelScale = NULL;
    cached_scale         = 600;
    spec_data_dirty      = 0;
    last_redraw_ms       = 0;
    last_displayed_scale = 0;
}
