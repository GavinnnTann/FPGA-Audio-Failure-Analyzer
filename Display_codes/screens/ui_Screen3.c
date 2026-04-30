/*  Screen 3 – Waterfall Spectrogram
 *
 *  X-axis : time   (scrolls right-to-left, newest on the right)
 *  Y-axis : frequency  (DC / low at bottom, high at top)
 *  Colour : amplitude  (inferno colour ramp)
 *
 *  Implementation: a 240 × 64 RGB565 canvas (~30 KB) drawn at 1×
 *  scale on the display. Each new spectrogram burst shifts the
 *  buffer one pixel-column left (memmove) and paints the 64 new
 *  bins as the rightmost column.
 *
 *  Render cost is dominated by LVGL re-rendering the canvas's
 *  display area on each invalidate. We deliberately render at 1×
 *  scale (no software scaling on every redraw) and throttle the
 *  redraw to ~6 Hz so Core 1 has plenty of headroom for the
 *  touch and UART consumers, at the cost of a smaller spectrogram
 *  footprint on screen — UX over visual size.
 */

#include "../ui.h"

#include <stdlib.h>
#include <string.h>

lv_obj_t * ui_Screen3 = NULL;

/* ---- geometry ----------------------------------------------------------- */

enum {
    kSpectrogramBins  = 64,
    kCanvasW          = 240,    /* native pixels – one per data burst        */
    kCanvasH          = 64,     /* one row per frequency bin                 */
    kBytesPerPx       = 2,      /* RGB565                                    */
    kDisplayScaleX    = 256,    /* 1× — render natively, no software scale  */
    kDisplayScaleY    = 256,    /* 1× — visible 240 × 64 px                 */
    kScaleMin         = 300
};

/* ---- widgets ------------------------------------------------------------ */

static lv_obj_t * ui_LabelTitle  = NULL;
static lv_obj_t * ui_LabelHint   = NULL;
static lv_obj_t * ui_LabelScale  = NULL;
static lv_obj_t * ui_Canvas      = NULL;
static lv_obj_t * ui_Legend      = NULL;
static lv_obj_t * ui_LabelHi     = NULL;
static lv_obj_t * ui_LabelLo     = NULL;
static lv_obj_t * ui_LabelMap    = NULL;
static lv_obj_t * ui_PanelInfo   = NULL;
static lv_obj_t * ui_LabelInfo   = NULL;
static lv_obj_t * ui_LabelTime   = NULL;
static lv_obj_t * ui_LabelDesc   = NULL;

/* ---- state -------------------------------------------------------------- */

static uint16_t cached_scale         = 600;
static uint8_t  spec_data_dirty      = 0;
static uint32_t last_redraw_ms       = 0;
static uint16_t last_displayed_scale = 0;

static const uint32_t kMinRedrawIntervalMs = 150;  /* ~6 Hz cap — UX over fps */

/* ---- colour look-up table (amplitude 0-255 → RGB565) -------------------- */

static uint16_t amp_lut[256];

/* ---- canvas pixel buffer  (240 × 64 × 2 = 30 720 bytes, heap-allocated) - */
/* Kept on heap rather than BSS so TLS/WiFi static data can share DRAM.      */

static uint8_t *canvas_buf = NULL;

/* ---- color-scale legend (12 × 64 RGB565 = 1.5 KB, painted ONCE) --------- */
/* No per-frame cost: drawn at screen init and never invalidated again.      */
static uint8_t *legend_buf = NULL;
enum { kLegendW = 12, kLegendH = 64 };

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

    /* ---- Build colour LUT first; the legend canvas reads from it. ------- */
    build_amp_lut();

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

    /* Move the waterfall to the left side of the screen so we have room
     * for the colour legend and CNN pipeline panel on the right.          */
    lv_obj_set_align(ui_Canvas, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_Canvas, -115);
    lv_obj_set_y(ui_Canvas, -10);

    /* 1× horizontal and vertical → native 240 × 64 display pixels.
     * Skipping software scale shaves the largest cost from each redraw.  */
    lv_image_set_scale_x(ui_Canvas, (uint32_t)kDisplayScaleX);
    lv_image_set_scale_y(ui_Canvas, (uint32_t)kDisplayScaleY);
    lv_image_set_pivot(ui_Canvas, kCanvasW / 2, kCanvasH / 2);

    /* ---- Colour-scale legend ------------------------------------------- *
     * A 12 × 64 vertical inferno gradient. Painted exactly once during
     * screen init using the same amp_lut as the waterfall. Because it
     * never changes, LVGL never invalidates it — zero per-frame cost.    */
    const size_t legend_bytes = (size_t)(kLegendW * kLegendH * kBytesPerPx);
    if (legend_buf == NULL) {
        legend_buf = (uint8_t *)malloc(legend_bytes);
    }
    if (legend_buf != NULL) {
        uint16_t *legend16 = (uint16_t *)legend_buf;
        for (int y = 0; y < kLegendH; y++) {
            /* row 0 = max amplitude (top), last row = 0 (bottom) */
            const int amp = ((kLegendH - 1 - y) * 255) / (kLegendH - 1);
            const uint16_t c = amp_lut[amp];
            for (int x = 0; x < kLegendW; x++) {
                legend16[y * kLegendW + x] = c;
            }
        }
        ui_Legend = lv_canvas_create(ui_Screen3);
        lv_canvas_set_buffer(ui_Legend, legend_buf,
                             kLegendW, kLegendH, LV_COLOR_FORMAT_RGB565);
        lv_obj_remove_flag(ui_Legend, LV_OBJ_FLAG_CLICKABLE);
        lv_obj_set_align(ui_Legend, LV_ALIGN_CENTER);
        lv_obj_set_x(ui_Legend, 17);   /* just to the right of the canvas */
        lv_obj_set_y(ui_Legend, -10);
    }

    /* "Hi" / "Lo" amplitude tags pinned to the legend ends. */
    ui_LabelHi = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelHi, "Hi");
    lv_obj_set_align(ui_LabelHi, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_LabelHi, 36);
    lv_obj_set_y(ui_LabelHi, -42);
    lv_obj_set_style_text_color(ui_LabelHi, lv_color_hex(0xFFD799),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelHi, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    ui_LabelLo = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelLo, "Lo");
    lv_obj_set_align(ui_LabelLo, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_LabelLo, 36);
    lv_obj_set_y(ui_LabelLo, 22);
    lv_obj_set_style_text_color(ui_LabelLo, lv_color_hex(0x6E7A86),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelLo, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* "amp" caption sitting above the legend. */
    ui_LabelMap = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelMap, "amp");
    lv_obj_set_align(ui_LabelMap, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_LabelMap, 17);
    lv_obj_set_y(ui_LabelMap, -56);
    lv_obj_set_style_text_color(ui_LabelMap, lv_color_hex(0x86A1B8),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelMap, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- Right-side CNN architecture panel ---------------------------- *
     * A vertical stack of bars whose widths are proportional to each
     * layer's feature count, giving the classic encoder→bottleneck→
     * decoder "diamond" silhouette of an auto-encoder. All children are
     * created once and never touched again, so the panel adds nothing to
     * the steady-state render cost.                                       */
    ui_PanelInfo = lv_obj_create(ui_Screen3);
    lv_obj_set_size(ui_PanelInfo, 170, 220);
    lv_obj_set_align(ui_PanelInfo, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_PanelInfo, 145);
    lv_obj_set_y(ui_PanelInfo, 8);
    lv_obj_remove_flag(ui_PanelInfo,
                       LV_OBJ_FLAG_CLICKABLE | LV_OBJ_FLAG_SCROLLABLE);
    lv_obj_set_style_radius(ui_PanelInfo, 8,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_color(ui_PanelInfo, lv_color_hex(0x141C25),
                              LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_bg_opa(ui_PanelInfo, LV_OPA_COVER,
                            LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_width(ui_PanelInfo, 1,
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_border_color(ui_PanelInfo, lv_color_hex(0x2B3744),
                                  LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_pad_all(ui_PanelInfo, 6,
                             LV_PART_MAIN | LV_STATE_DEFAULT);

    /* Panel title. */
    ui_LabelInfo = lv_label_create(ui_PanelInfo);
    lv_label_set_text(ui_LabelInfo, "CNN Auto-encoder");
    lv_obj_set_align(ui_LabelInfo, LV_ALIGN_TOP_MID);
    lv_obj_set_y(ui_LabelInfo, 0);
    lv_obj_set_style_text_color(ui_LabelInfo, lv_color_hex(0xEAF6FF),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelInfo, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* Source caption — "FFT 64 bins" feeding into the network. */
    {
        lv_obj_t *src = lv_label_create(ui_PanelInfo);
        lv_label_set_text(src, "FFT 64 bins");
        lv_obj_set_align(src, LV_ALIGN_TOP_MID);
        lv_obj_set_y(src, 14);
        lv_obj_set_style_text_color(src, lv_color_hex(0x86A1B8),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_font(src, &lv_font_montserrat_10,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    }

    /* Layer stack: width is proportional to feature count, colour
     * encodes role (input/output blue, encoder/decoder green, latent
     * yellow). The diamond shape makes the bottleneck unmistakable.      */
    {
        struct LayerSpec {
            uint16_t bar_w;
            uint16_t feat;
            uint32_t bg;
            const char *tag;
        };
        static const struct LayerSpec layers[] = {
            { 96, 64, 0x4FA8FF, "in"   },
            { 64, 32, 0x6FD060, "enc1" },
            { 36, 16, 0x6FD060, "enc2" },
            { 18,  8, 0xFFC83A, "z"    },  /* bottleneck */
            { 36, 16, 0x6FD060, "dec1" },
            { 64, 32, 0x6FD060, "dec2" },
            { 96, 64, 0x4FA8FF, "rec"  },
        };
        const int n_layers = (int)(sizeof(layers) / sizeof(layers[0]));
        const int bar_h = 12;
        const int row_step = 16;
        const int row_y0 = 30;          /* below title + source caption */
        const int label_x_inset = -2;   /* small overlap into right padding */

        for (int i = 0; i < n_layers; i++) {
            lv_obj_t *bar = lv_obj_create(ui_PanelInfo);
            lv_obj_set_size(bar, layers[i].bar_w, bar_h);
            lv_obj_set_align(bar, LV_ALIGN_TOP_MID);
            lv_obj_set_x(bar, 0);
            lv_obj_set_y(bar, row_y0 + i * row_step);
            lv_obj_remove_flag(bar,
                               LV_OBJ_FLAG_CLICKABLE | LV_OBJ_FLAG_SCROLLABLE);
            lv_obj_set_style_radius(bar, 2,
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_color(bar, lv_color_hex(layers[i].bg),
                                      LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_bg_opa(bar, LV_OPA_COVER,
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_border_width(bar, 0,
                                          LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_pad_all(bar, 0,
                                     LV_PART_MAIN | LV_STATE_DEFAULT);

            /* Layer-name + feature-count tag, pinned to the right edge. */
            lv_obj_t *tag = lv_label_create(ui_PanelInfo);
            char tag_text[16];
            lv_snprintf(tag_text, sizeof(tag_text), "%s %u",
                        layers[i].tag, (unsigned)layers[i].feat);
            lv_label_set_text(tag, tag_text);
            lv_obj_set_align(tag, LV_ALIGN_TOP_RIGHT);
            lv_obj_set_x(tag, label_x_inset);
            lv_obj_set_y(tag, row_y0 + i * row_step + 1);
            lv_obj_set_style_text_color(tag, lv_color_hex(0x9DB1C5),
                                        LV_PART_MAIN | LV_STATE_DEFAULT);
            lv_obj_set_style_text_font(tag, &lv_font_montserrat_10,
                                       LV_PART_MAIN | LV_STATE_DEFAULT);
        }
    }

    /* MAE / threshold caption pinned to the bottom of the panel. */
    {
        lv_obj_t *mae = lv_label_create(ui_PanelInfo);
        lv_label_set_text(mae, "MAE > 26 = anomaly");
        lv_obj_set_align(mae, LV_ALIGN_BOTTOM_MID);
        lv_obj_set_y(mae, 0);
        lv_obj_set_style_text_color(mae, lv_color_hex(0xFFA94F),
                                    LV_PART_MAIN | LV_STATE_DEFAULT);
        lv_obj_set_style_text_font(mae, &lv_font_montserrat_10,
                                   LV_PART_MAIN | LV_STATE_DEFAULT);
    }

    /* ---- Time-axis hint under the waterfall --------------------------- */
    ui_LabelTime = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelTime, "<- past                now ->");
    lv_obj_set_align(ui_LabelTime, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_LabelTime, -115);
    lv_obj_set_y(ui_LabelTime, 30);
    lv_obj_set_style_text_color(ui_LabelTime, lv_color_hex(0x86A1B8),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelTime, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);

    /* ---- Spectrogram description ---------------------------------------- */
    ui_LabelDesc = lv_label_create(ui_Screen3);
    lv_label_set_text(ui_LabelDesc,
        "• FFT magnitude over time\n"
        "• Scroll left = newer data\n"
        "• Brighter = higher amplitude\n"
        "• Y: frequency (low→high)\n"
        "• X: time (past→now)");
    lv_obj_set_align(ui_LabelDesc, LV_ALIGN_CENTER);
    lv_obj_set_x(ui_LabelDesc, -115);
    lv_obj_set_y(ui_LabelDesc, 70);
    lv_obj_set_width(ui_LabelDesc, 220);
    lv_label_set_long_mode(ui_LabelDesc, LV_LABEL_LONG_WRAP);
    lv_obj_set_style_text_align(ui_LabelDesc, LV_TEXT_ALIGN_LEFT,
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_color(ui_LabelDesc, lv_color_hex(0x6B7C8A),
                                LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_font(ui_LabelDesc, &lv_font_montserrat_10,
                               LV_PART_MAIN | LV_STATE_DEFAULT);
    lv_obj_set_style_text_line_space(ui_LabelDesc, 4,
                                     LV_PART_MAIN | LV_STATE_DEFAULT);


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
    if (legend_buf != NULL) {
        free(legend_buf);
        legend_buf = NULL;
    }

    ui_Screen3    = NULL;
    ui_Canvas     = NULL;
    ui_Legend     = NULL;
    ui_LabelTitle = NULL;
    ui_LabelHint  = NULL;
    ui_LabelScale = NULL;
    ui_LabelHi    = NULL;
    ui_LabelLo    = NULL;
    ui_LabelMap   = NULL;
    ui_PanelInfo  = NULL;
    ui_LabelInfo  = NULL;
    ui_LabelTime  = NULL;
    ui_LabelDesc  = NULL;
    cached_scale         = 600;
    spec_data_dirty      = 0;
    last_redraw_ms       = 0;
    last_displayed_scale = 0;
}
