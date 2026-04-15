# Display_codes Changelog

## 2026-04-14 — Spectrogram Performance Overhaul

### Problem
The ESP32 spectrogram display (Screen 3) was visibly laggy compared to the Python
spectrogram viewer running on the same UART stream. The FPGA sends all 64 bins in
a ~3.84 ms burst at ~18 Hz, but the display could not keep up.

### Root Cause
Screen 3 created **64 individual `lv_obj` widgets** as bar-chart bars. Every
spectrogram update called `lv_obj_set_height()` + `lv_obj_set_y()` on each bar —
**128 property-change / invalidation calls per frame**. Each call triggers LVGL's
internal layout recalculation and dirty-rectangle bookkeeping, overwhelming the
ESP32 at 18 Hz (~2,300 calls/second).

Secondary contributors:
- UART RX buffer (1024 bytes) was tight for burst mode (392 bytes per burst).
- End-of-loop `delay(3 ms)` wasted time while UART data accumulated.

### Changes

#### `screens/ui_Screen3.c`
| Before | After |
|--------|-------|
| 64 `lv_obj_create` child bars in `ui_Screen3_screen_init` | Zero child bar objects |
| `ui_Bars[64]` array + per-bar style setup (radius, gradient, border) | `cached_bins[64]` static uint16 array + `cached_scale` |
| `ui_screen3_update_spectrogram` loops 64× calling `lv_obj_set_height` / `lv_obj_set_y` | `memcpy` bins into cache, then single `lv_obj_invalidate(ui_PanelGraph)` |
| N/A | `graph_draw_event_cb` on `LV_EVENT_DRAW_MAIN_END` renders 64 rectangles via `lv_draw_rect()` directly into the render layer |

The custom draw callback computes a height-based color tint per bar (darker for
quiet bins, brighter for loud bins) instead of using LVGL's gradient style engine.

#### `src/main.cpp`
| Parameter | Before | After | Reason |
|-----------|--------|-------|--------|
| `kMaxUartBytesPerLoop` | 768 | **1024** | Covers a full 392-byte burst in one parse call |
| `fpga_uart.setRxBufferSize` | 1024 | **2048** | Prevents overflow if display flush temporarily delays parsing |
| End-of-loop delay cap | 3 ms | **1 ms** | Tighter loop cadence reduces UART-to-display latency |

### Impact
- **128 → 1** LVGL invalidation calls per spectrogram frame.
- **64 → 0** LVGL widget objects for bars (replaced by lightweight draw commands).
- RAM usage: 28.0 % (91,728 bytes), Flash: 54.1 % (708,473 bytes).
- Expected refresh rate on display now matches the ~18 Hz FPGA burst cadence.
