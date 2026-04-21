# UART Protocol Specification
## FPGA → ESP32 / PC Telemetry & Spectrogram Streaming

---

## Overview

The FPGA transmits two interleaved frame types over UART:

1. **RMS Telemetry Frame** (8 bytes) — CNN anomaly classification, RMS amplitude, system flags, and MAE score
2. **Spectrogram Burst** (64 × 6 = 384 bytes) — all 64 frequency bins, transmitted immediately after each telemetry frame

Both frame types share the same UART link on two mirrored outputs:
- **Pin N3** (edge header) → ESP32 UART2 RX
- **Pin J18** (onboard FTDI) → PC USB serial

**UART settings:** 1 Mbaud, 8N1, no flow control.

---

## Transmission Cycle

```
┌────────────────────────────────────────────────────────────────────┐
│  ~50 ms RMS window accumulation (391 decimated samples @ 7.8 kHz) │
│  FFT runs continuously in parallel (46.875 kHz, 512-pt, hop=64)  │
│  CNN inference runs asynchronously on completed spectrograms      │
└──────────────────────────┬─────────────────────────────────────────┘
                           │ Window complete
                           ▼
         ┌──────────────────────────────────┐
         │  Frame 1: RMS Telemetry (8 bytes)│  ← ~80 µs @ 1 Mbaud
         │  AA 55 result rms flags seq      │
         │  metric checksum                 │
         └──────────────────┬───────────────┘
                            │ Immediately after
                            ▼
         ┌──────────────────────────────────┐
         │  Frame 2: Spectrogram Burst      │  ← ~3.84 ms @ 1 Mbaud
         │  64 × [DD 77 idx lo hi chk]     │
         │  Bin 0 first → Bin 63 last       │
         └──────────────────┬───────────────┘
                            │
                            ▼
                     Back to idle
                  (next window starts)
```

**Cycle time:** ~50 ms + ~0.08 ms + ~3.84 ms ≈ **54 ms per cycle → ~18 Hz refresh rate**

**Bandwidth:** ~7,259 bytes/sec ≈ 58.1 kbps (well within 1 Mbaud capacity)

---

## Frame 1: RMS Telemetry

### Wire Format

| Byte | Field | Value / Range | Description |
|------|-------|---------------|-------------|
| 0 | Sync A | `0xAA` | Fixed sync byte |
| 1 | Sync B | `0x55` | Fixed sync byte |
| 2 | `result` | `0x00` or `0x01` | CNN anomaly classification: 0 = Normal, 1 = Abnormal |
| 3 | `rms` | 0–255 | Mean absolute amplitude over the ~50 ms window, scaled to 8-bit |
| 4 | `flags` | 8-bit bitmap | System status flags (see below) |
| 5 | `seq` | 0–255 | Rolling frame sequence counter (wraps at 255 → 0) |
| 6 | `metric` | 0–255 | CNN MAE anomaly score (when CNN active) or debug byte (before first CNN run) |
| 7 | `checksum` | 8-bit XOR | `0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric` |

### Flags Byte (Byte 4) — Bit Layout

```
  bit7  bit6  bit5  bit4  bit3   bit2       bit1            bit0
  ─────┬─────┬─────┬─────┬─────┬──────────┬───────────────┬────────────
   0   │  0  │  0  │  0  │  0  │ cnn_ran  │ cnn_anomaly   │ fpga_active
  ─────┴─────┴─────┴─────┴─────┴──────────┴───────────────┴────────────
```

| Bit | Name | Meaning |
|-----|------|---------|
| 0 | `fpga_active` | Always 1 when FPGA is transmitting (heartbeat) |
| 1 | `cnn_anomaly` | 1 = CNN detects anomaly (MAE > threshold), 0 = Normal |
| 2 | `cnn_ran` | 1 = CNN has completed at least one inference since reset |
| 7:3 | Reserved | Always 0 |

### `result` Field (Byte 2) — CNN Anomaly Detection

| Value | Meaning |
|-------|---------|
| `0x00` | **Normal** — CNN reconstruction error is below threshold |
| `0x01` | **Abnormal** — CNN reconstruction error exceeds threshold (MAE > 30/255) |

This field directly reflects the CNN autoencoder's anomaly classification. The CNN compares a 64×64 spectrogram against its reconstruction: if the mean absolute error (MAE) exceeds the configured threshold (`CNN_ANOMALY_THRESHOLD = 30`), the system flags an anomaly.

### `metric` Field (Byte 6) — CNN MAE Score / Debug Byte

The interpretation depends on the `cnn_ran` flag (bit 2 of `flags`):

| `cnn_ran` | `metric` meaning |
|-----------|-----------------|
| 0 (CNN not yet run) | Debug diagnostic byte from `cnn_wrapper.dbg_byte` (see debug byte layout below) |
| 1 (CNN has run) | **CNN MAE score** (0–255): mean absolute reconstruction error across 4,096 pixels |

**CNN MAE Score interpretation:**

| MAE Range | Classification | Meaning |
|-----------|---------------|---------|
| 0–10 | Normal (low error) | Reconstruction closely matches input — familiar acoustic pattern |
| 11–29 | Normal (moderate error) | Minor deviations but within tolerance |
| 30–60 | **Abnormal (mild)** | Noticeable departure from learned patterns |
| 61–120 | **Abnormal (moderate)** | Significant anomaly — mechanical issue likely |
| 121–255 | **Abnormal (severe)** | Extreme reconstruction failure — critical anomaly |

> **Threshold:** `MAE ≥ 30` triggers `result = 1` and `cnn_anomaly = 1`. This is configurable via `CNN_ANOMALY_THRESHOLD` in `recorder_top.v`.

**Pre-CNN debug byte layout** (when `cnn_ran = 0`):
```
  bit7             bit6              bit5              bit4
  ───────────────┬─────────────────┬─────────────────┬────────────────
  CNN input      │ CNN output      │ feeder_done     │ frame_ready
  TREADY (live)  │ TVALID ever     │ ever seen       │ ever seen
  ───────────────┴─────────────────┴─────────────────┴────────────────
  bit3             bit2:0
  ───────────────┬──────────────
  scorer         │ wrapper FSM
  out_tready     │ state [2:0]
  ───────────────┴──────────────
```

### Example Telemetry Frames

**Normal operation (CNN active, no anomaly):**
```
AA 55 00 45 05 1A 0E 8D
       │  │  │  │  │  └─ checksum
       │  │  │  │  └──── metric = 14 (MAE = 14, well below threshold)
       │  │  │  └─────── seq = 26
       │  │  └────────── flags = 0b00000101 → fpga_active=1, cnn_anomaly=0, cnn_ran=1
       │  └───────────── rms = 69 (moderate audio level)
       └──────────────── result = 0 (Normal)
```

**Anomaly detected:**
```
AA 55 01 B2 07 2F 38 C0
       │  │  │  │  │  └─ checksum
       │  │  │  │  └──── metric = 56 (MAE = 56, above threshold 30)
       │  │  │  └─────── seq = 47
       │  │  └────────── flags = 0b00000111 → fpga_active=1, cnn_anomaly=1, cnn_ran=1
       │  └───────────── rms = 178 (elevated audio level)
       └──────────────── result = 1 (Abnormal)
```

**Before CNN first run (startup):**
```
AA 55 00 23 01 03 B8 62
       │  │  │  │  │  └─ checksum
       │  │  │  │  └──── metric = 0xB8 (debug byte: CNN pipeline initializing)
       │  │  │  └─────── seq = 3
       │  │  └────────── flags = 0b00000001 → fpga_active=1, cnn_anomaly=0, cnn_ran=0
       │  └───────────── rms = 35 (low audio level)
       └──────────────── result = 0 (Normal — CNN hasn't run yet, defaults to normal)
```

---

## Frame 2: Spectrogram Burst

### Wire Format (per bin, 6 bytes)

| Byte | Field | Value / Range | Description |
|------|-------|---------------|-------------|
| 0 | Sync A | `0xDD` | Spectrogram marker |
| 1 | Sync B | `0x77` | Spectrogram marker |
| 2 | `bin_index` | 0–63 | Frequency bin index (0 = DC, 63 = ~23.1 kHz) |
| 3 | `bin_low` | 0–255 | Magnitude LSB (little-endian) |
| 4 | `bin_high` | 0–255 | Magnitude MSB (little-endian) |
| 5 | `checksum` | 8-bit XOR | `0xDD ^ 0x77 ^ bin_index ^ bin_low ^ bin_high` |

**Reassembly:** `magnitude = bin_low | (bin_high << 8)` (16-bit unsigned, 0–65535)

### Burst Sequence

All 64 bins are transmitted in order immediately after the RMS telemetry frame:
```
DD 77 00 <lo> <hi> <chk>    ← bin 0 (DC)
DD 77 01 <lo> <hi> <chk>    ← bin 1 (~366 Hz)
DD 77 02 <lo> <hi> <chk>    ← bin 2 (~732 Hz)
...
DD 77 3F <lo> <hi> <chk>    ← bin 63 (~23.1 kHz)
```

**Burst timing:** 64 bins × 6 bytes × 10 bits/byte ÷ 1 Mbaud ≈ **3.84 ms**

Each bin's magnitude is **latched** into a register at the start of its packet transmission, preventing race conditions with concurrent FFT updates.

### Frequency Mapping

Bins are derived from a 512-point FFT at 46.875 kHz sampling, taking every 4th bin from the first 256 real-frequency bins:

| Parameter | Value |
|-----------|-------|
| FFT size | 512 points |
| Sample rate | 46,875 Hz |
| FFT bin resolution | 46875 / 512 = 91.55 Hz |
| Downsampling | every 4th bin → ×4 spacing |
| **Output bin spacing** | **~366.2 Hz** |
| Output bins | 64 (indices 0–63) |
| Frequency range | 0 Hz to ~23.1 kHz |

**Formula:** `frequency_Hz = bin_index × (46875 / 512) × 4 ≈ bin_index × 366.2`

| Bin Index | Center Frequency | Example Source |
|-----------|-----------------|----------------|
| 0 | DC (0 Hz) | — |
| 1 | ~366 Hz | Low motor hum |
| 5 | ~1.83 kHz | Stepper motor fundamental |
| 10 | ~3.66 kHz | Bearing noise |
| 20 | ~7.32 kHz | Belt harmonics |
| 27 | ~9.9 kHz | High-frequency mechanical |
| 41 | ~15.0 kHz | Test tone reference |
| 63 | ~23.1 kHz | Near Nyquist |

### Magnitude Range

| Condition | Typical Magnitude (16-bit) |
|-----------|---------------------------|
| Ambient noise (quiet) | 50–200 |
| Normal print operation | 200–800 |
| 15 kHz test tone (moderate) | 300–600 |
| Loud machinery/tone | 2,000–8,000 |
| Clipping | 65,535 (0xFFFF) |

---

## CNN Autoencoder Model Details

### Architecture

The CNN is a 15-layer convolutional autoencoder generated by hls4ml, running on the FPGA at 100 MHz in a dedicated clock domain.

| Property | Value |
|----------|-------|
| Input | 64×64×1 spectrogram (4,096 unsigned 8-bit pixels) |
| Output | 64×64×1 reconstructed spectrogram |
| Clock | 100 MHz (MMCM from 12 MHz) |
| Latency | ~178,600 cycles = **1.786 ms** per inference |
| Interface | AXI-Stream input + AXI-Stream output |
| Anomaly metric | MAE (mean absolute error) across all 4,096 pixels |
| Threshold | MAE ≥ 30/255 → Abnormal |

### Operating Principle

The autoencoder learns to reconstruct "normal" acoustic spectrograms. When an anomalous sound occurs, the reconstruction error spikes because the model has never seen that pattern during training.

```
64×64 spectrogram
      ↓
  [ Encoder ] → compressed representation → [ Decoder ]
      ↓                                         ↓
  Original input                        Reconstructed output
      ↓                                         ↓
      └─────── pixel-wise |difference| ─────────┘
                          ↓
                   Σ / 4096 = MAE
                          ↓
                 MAE ≥ 30 ? ABNORMAL : NORMAL
```

### Pipeline Timing

```
Spectrogram frame complete (64 lines accumulated)
    ↓
Ping-pong buffer swap (12 MHz → 100 MHz CDC)
    ↓
cnn_axi_feeder streams 4,096 pixels → CNN input AXI-Stream
    ↓  (~86 µs feeder time)
CNN processes through 15 layers
    ↓  (total ~1.786 ms)
cnn_anomaly_scorer computes MAE against cached input pixels
    ↓  (concurrent with CNN output)
anomaly_score latched (CDC 100 MHz → 12 MHz)
    ↓
Next RMS telemetry frame carries updated result + metric
```

The CNN runs **asynchronously** from the UART telemetry cycle. The latest available CNN result is included in each telemetry frame. If no new CNN result has arrived since the last frame, the previous result persists.

---

## Complete Timing Diagram

```
Time (ms) │ Activity                          │ UART Output
──────────┼───────────────────────────────────┼──────────────────────────────
0.00      │ RMS accumulation starts           │ (idle)
          │ FFT runs continuously             │
~1.79     │ CNN inference completes (async)   │
          │ anomaly_score latched             │
          │ ...                               │
50.00     │ Window complete → latch telemetry │ AA 55 [result rms flags      
50.08     │                                   │        seq metric chk]
50.08     │ Spectrogram burst starts          │ DD 77 00 [lo hi chk]
50.14     │                                   │ DD 77 01 [lo hi chk]
          │ ... (64 bins)                     │ ...
53.92     │ Burst complete, seq++             │ DD 77 3F [lo hi chk]
53.92     │ Back to idle                      │ (idle)
          │ ...                               │
100.00    │ Next window complete              │ AA 55 ... (next cycle)
100.08    │ Next burst                        │ DD 77 00 ...
```

---

## ESP32 Receiver Implementation

### Parser State Machine

```
                        ┌──────────┐
                        │ WaitSync1│ ←────────────────────┐
                        └────┬─────┘                      │
                 0xAA ┌──────┴──────┐ 0xDD                │
                      ▼             ▼                      │
              ┌────────────┐ ┌─────────────┐              │
              │WaitSync2Rms│ │WaitSync2Spec│              │
              └──────┬─────┘ └──────┬──────┘              │
               0x55  │         0x77 │                      │
                     ▼              ▼                      │
            ┌─────────────┐ ┌──────────────┐              │
            │WaitRmsPayld │ │WaitSpecPayld │              │
            │ (6 bytes)   │ │ (4 bytes)    │              │
            └──────┬──────┘ └──────┬───────┘              │
                   │ 8 total       │ 6 total              │
                   ▼               ▼                      │
             Validate chk    Validate chk                 │
                   │               │                      │
                   └───────────────┴──────────────────────┘
```

### RMS Frame Processing (on valid checksum)

```cpp
void process_valid_rms_frame() {
    uint8_t result = payload[2];    // 0=Normal, 1=Abnormal
    uint8_t rms    = payload[3];    // 0-255 amplitude
    uint8_t flags  = payload[4];    // System flags
    uint8_t seq    = payload[5];    // Sequence counter
    uint8_t metric = payload[6];    // CNN MAE score or debug byte

    bool fpga_active  = (flags & 0x01);  // bit0
    bool cnn_anomaly  = (flags & 0x02);  // bit1
    bool cnn_has_run  = (flags & 0x04);  // bit2

    // Update UI with CNN classification and score
    update_status_label(result != 0);
    update_rms_bar(rms);
    update_fpga_state(fpga_active);
    
    if (cnn_has_run) {
        update_mae_display(metric);  // metric = MAE 0-255
    }
}
```

### Spectrogram Frame Processing (on valid checksum)

```cpp
void process_valid_spectrogram_frame() {
    uint8_t  bin_index = payload[2];
    uint16_t magnitude = payload[3] | (payload[4] << 8);

    if (bin_index < 64) {
        spectrogram_bins[bin_index] = magnitude;
        if (bin_index == 63) {
            // Full burst received → trigger display update
            update_spectrogram_display();
        }
    }
}
```

### Sequence Tracking

The `seq` field increments by 1 after each complete telemetry+burst cycle. The ESP32 tracks sequence continuity:
- **Expected:** `seq_next = (last_seq + 1) % 256`
- **Forward jump** (seq ahead of expected): count as dropped frames (`seq_drop += delta`)
- **Backward jump** (seq behind expected): count as reordering (`seq_reorder++`)
- **Wrap example:** `... 254, 255, 0, 1 ...` is normal; `255 → 2` means frames 0 and 1 were dropped

---

## Recommended Display Presentation

### Screen 2: Telemetry Dashboard

The telemetry screen is the primary monitoring view. The following UI elements should be updated from the RMS frame:

#### 1. CNN Status Indicator
- **Source:** `result` (byte 2) + `cnn_anomaly` (flags bit 1)
- **Display:** Large status label — **"Normal"** (green) / **"Abnormal"** (red)
- **Update rate:** Every RMS frame (~18 Hz)
- **Stale behavior:** Show "No Data" (gray) after 400 ms without valid frame

#### 2. CNN MAE Score / Anomaly Severity Gauge
- **Source:** `metric` (byte 6), only valid when `cnn_ran` (flags bit 2) is set
- **Recommended visualization:**

  **Option A — Segmented severity arc:**
  ```
  ┌────────────────────────────────────────┐
  │    MAE: 14 / 255                       │
  │    [████████░░░░░░░░░░░░░░░░░] Normal  │
  │     ▲ threshold = 30                   │
  └────────────────────────────────────────┘
  ```
  - Scale 0–255, threshold marker at 30
  - Green (0–29), Yellow (30–60), Orange (61–120), Red (121–255)
  - Show numeric MAE value alongside
  
  **Option B — Circular gauge overlaid on uptime arc:**
  - Inner ring: MAE severity (color-coded)
  - Outer ring: uptime progression
  - Anomaly events marked as dots on the ring (current implementation)

  **Option C — Numeric + trend sparkline:**
  ```
  MAE: 14 ▼    (arrow: trending lower)
  ┌──────────────────────────┐
  │  ╱╲    ╱╲               │  ← last 60s of MAE values
  │ ╱  ╲──╱  ╲──────────    │
  │╱                    ╲── │
  └──────────────────────────┘
       ▲ threshold line at 30
  ```
  - Maintain a circular buffer of recent MAE values (e.g., 72 samples = 72 × 54 ms ≈ 4 seconds)
  - Plot as a mini sparkline
  - Threshold line clearly visible

#### 3. RMS Amplitude Bar
- **Source:** `rms` (byte 3)
- **Display:** Vertical bar (0–255 range), gradient green→red
- **Filtering:** Apply median-3 filter + exponential smoothing for visual stability
  - Attack alpha: 0.55 (fast rise)
  - Release alpha: 0.20 (slow decay)
  - Slew rate limit: 260 units/sec
- **RMS Window Stats:** Show min/max over last 10 seconds alongside the bar
- **Severity mapping:** `severity_percent = (rms × 100 + 127) / 255` → display as "Low", "Med", "High"

#### 4. FPGA Active/Sleep Indicator
- **Source:** `fpga_active` (flags bit 0)
- **Display:** "Active" (white) / "Sleep" (gray)
- **No-data fallback:** Force "Sleep" after 400 ms timeout

#### 5. CNN Ready Indicator
- **Source:** `cnn_ran` (flags bit 2)
- **Display:** Before first CNN result, show "CNN Initializing" or "Warming Up"
- **After first run:** Switch to showing live MAE score
- **Note:** `metric` byte contains a debug diagnostic before `cnn_ran` goes high — do not display it as an MAE value

#### 6. Health & Diagnostics Overlay
- **Anomaly history:** Count anomaly events in a 60-second rolling window
- **Sequence health:** Display drop/fail/reorder counters for UART link quality
- **Last anomaly age:** Time since last `result = 1` in seconds
- **Update rate:** Every 500 ms

#### 7. Anomaly Event Ring (Arc Dots)
- **Source:** Each transition of `result` from 0→1 generates an anomaly event
- **Display:** Plot a red dot on the uptime arc at the current rotation position
- **Persistence:** Dots persist for 3 full rotations (18 minutes) with fading opacity
- **Severity:** Dot size scales with `metric` (MAE score) — higher MAE = larger/brighter dot

### Screen 3: Waterfall Spectrogram

The waterfall display provides time-frequency visualization of the audio stream.

#### Canvas Layout
- **Buffer:** 230 × 64 RGB565 canvas (~29 KB), scaled 2× horizontal, 3× vertical → 460 × 192 display pixels
- **X-axis:** Time (scrolls right-to-left, newest on right)
- **Y-axis:** Frequency (DC/low at bottom, 23.1 kHz at top)
- **Color:** Amplitude mapped through inferno/magma colormap (dark → purple → orange → white)

#### Data Flow
```
Spectrogram burst received (bin 63 = trigger)
    ↓
memmove canvas left by 1 pixel-column
    ↓
Paint 64 new bins as rightmost column:
    - Normalize: magnitude × 255 / adaptive_scale → 0-255
    - LUT lookup: amp_lut[normalized] → RGB565
    - Place at row (63 - bin_index) for low=bottom orientation
    ↓
Mark dirty → redraw on next tick (capped at ~18 Hz)
```

#### Adaptive Scaling
```cpp
// Auto-track peak magnitude for normalization
if (peak > cached_scale)
    cached_scale = peak;                // instant attack
else
    cached_scale = cached_scale * 0.995; // slow decay
if (cached_scale < 300)
    cached_scale = 300;                 // minimum floor
```

#### Axis Annotations
- **Title:** "Spectrogram" or "Waterfall"
- **Scale label:** Show current auto-scale value (dynamic)
- **Frequency labels (Y-axis):**
  - Bottom: "0 Hz"
  - Mid: "~11.7 kHz"
  - Top: "~23.1 kHz"
- **Time label (X-axis):** "← 12.4s" (kCanvasW × 54 ms ≈ 12.4 seconds visible)

#### CNN Overlay Recommendation
When an anomaly is active (`result = 1`), consider overlaying a subtle red border or pulsing indicator on the spectrogram canvas to visually correlate the anomaly with the spectral content at that moment. This helps the user identify which frequency patterns triggered the anomaly.

---

## Backward Compatibility

The protocol maintains backward compatibility:
- **RMS-only parsers:** Existing firmware that only recognizes `0xAA 0x55` will continue to work — the `0xDD 0x77` spectrogram packets are simply ignored
- **Pre-CNN firmware:** If `cnn_ran` (flags bit 2) is 0, the `result` field defaults to 0 (Normal) and `metric` contains debug info — old parsers treating it as a confidence byte will see harmless values

**Breaking change from earlier round-robin version:** Spectrogram bins are now burst-transmitted (all 64 after each RMS frame) instead of one bin per cycle. Parsers expecting single-bin round-robin delivery must be updated to handle the burst pattern.

---

## Checksum Verification

Both frame types use XOR checksums:

**RMS frame:**
```
checksum = 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric
```

**Spectrogram frame:**
```
checksum = 0xDD ^ 0x77 ^ bin_index ^ bin_low ^ bin_high
```

Invalid checksums → discard frame, increment `checksum_fail` counter, resynchronize from next potential sync byte.

---

## Source File References

| File | Role |
|------|------|
| [recorder_top.v](../src_main/recorder_top.v) | UART packet FSM (28-state), telemetry assembly, CNN result CDC |
| [uart_tx.v](../src_main/uart_tx.v) | UART 8N1 transmitter (1 Mbaud @ 12 MHz) |
| [cnn_wrapper.v](../src_main/cnn_wrapper.v) | CNN pipeline FSM (IDLE → FEED → PROCESS → RESULT) |
| [cnn_axi_feeder.v](../src_main/cnn_axi_feeder.v) | AXI-Stream pixel streamer (BRAM → CNN input) |
| [cnn_anomaly_scorer.v](../src_main/cnn_anomaly_scorer.v) | MAE computation (reconstruction error → 8-bit score) |
| [main.cpp](src/main.cpp) | ESP32 UART parser + main loop |
| [screen2_telemetry.cpp](src/screen2_telemetry.cpp) | ESP32 telemetry processing + Screen 2 UI updates |
| [ui_Screen3.c](screens/ui_Screen3.c) | ESP32 waterfall spectrogram canvas (Screen 3) |
| [spectrogram_viewer.py](../tools/spectrogram_viewer.py) | PC-side Python viewer (tkinter + matplotlib) |
