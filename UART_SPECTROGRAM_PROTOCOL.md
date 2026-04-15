# UART Spectrogram Streaming Protocol
## ESP32 Real-time Spectrogram Display from CMOD A7 FPGA

---

## Overview

This document specifies the UART protocol for streaming spectrograms from the FPGA to the ESP32 for real-time visualization. The protocol sends **RMS telemetry** followed by a **burst of all 64 spectrogram bins** each cycle.

**Design Goal**: RMS updates every ~50 ms, followed immediately by the full 64-bin spectrum in a single burst (~3.8 ms). Total cycle time ≈ 54 ms → ~18 Hz spectrogram refresh rate.

---

## Current Implementation

Both frame types are implemented and active in `recorder_top.v`:

```
(1) RMS Telemetry Frame (8 bytes - HIGH PRIORITY)
    [0xAA] [0x55] [result] [rms] [flags] [seq] [metric] [checksum]
    → Sent every ~50 ms (every new RMS window)

(2) Spectrogram Burst (64 × 6 bytes = 384 bytes - IMMEDIATELY AFTER RMS)
    [0xDD] [0x77] [bin_index: 0-63] [bin_low] [bin_high] [checksum]
    → All 64 bins transmitted in rapid succession after each RMS frame
    → Full spectrogram delivered in ~3.8 ms per burst
```

---

## Signal Path Summary

```
INMP441 I2S Microphone (SCK = 3 MHz)
  ↓
46.875 kHz 24-bit samples (full bandwidth, no decimation for FFT path)
  ↓
Hann Window Buffer (512 samples, hop=64 overlap)
  ↓
512-point FFT (Xilinx FFT v9.1 IP)
  ↓
Magnitude Extraction (Alphamax+Betamax, first 256 bins only)
  ↓
Bin Downsampling (every 4th bin from first 256 → 64 output bins)
  ↓
UART Burst: 1 RMS frame + 64 spectrogram slice packets
```

**Frequency coverage**: 0 Hz to ~23.4 kHz (Nyquist = 46875/2)
**Bin spacing**: 46875/512 × 4 ≈ 366 Hz per output bin
**Output bin k** maps to center frequency: k × 366.2 Hz

---

## UART Frame Formats

### Frame 1: RMS Telemetry

**Sync & Format**:
```
Byte 0:   0xAA (sync)
Byte 1:   0x55 (sync)
Byte 2:   result (8-bit)
Byte 3:   rms (8-bit amplitude, 0–255)
Byte 4:   flags (8-bit: [reserved×6, fpga_active, overflow])
Byte 5:   seq (8-bit sequence counter, 0–255)
Byte 6:   metric (8-bit CNN confidence / anomaly score, 0–255)
Byte 7:   checksum (= 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric)
```

**Cadence**: Sent every ~50 ms (fixed WINDOW_SAMPLES in recorder_top.v).

**Example**:
```
AA 55 00 7F 01 05 42 36
└─┬─┘ └─┬─┘ └──checksum──┘
  │     └─ rms = 127 (medium amplitude)
  └─ sync bytes
```

---

### Frame 2: Spectrogram Slice Packet

**Sync & Format**:
```
Byte 0:   0xDD (sync, spectrogram marker)
Byte 1:   0x77 (sync, spectrogram marker)
Byte 2:   bin_index (8-bit, 0–63, which frequency bin)
Byte 3:   bin_magnitude_low (8-bit, LSB of 16-bit magnitude)
Byte 4:   bin_magnitude_high (8-bit, MSB of 16-bit magnitude)
Byte 5:   checksum (= 0xDD ^ 0x77 ^ bin_index ^ bin_low ^ bin_high)
```

**Bin Index → Frequency Mapping**:
- `bin_index = 0`: DC (0 Hz)
- `bin_index = 1`: ~366 Hz
- `bin_index = 10`: ~3.66 kHz
- `bin_index = 27`: ~9.9 kHz
- `bin_index = 41`: ~15.0 kHz
- `bin_index = 63`: ~23.1 kHz

**General formula**: `frequency_Hz = bin_index × (46875 / 512) × 4 ≈ bin_index × 366.2`

**Magnitude Value**:
- 16-bit unsigned, range: 0x0000–0xFFFF (0–65535)
- Stored as little-endian: `bin_magnitude = bin_low | (bin_high << 8)`
- Typical values for ambient noise: 50–200
- Peak values during 15 kHz tone (moderate volume): ~300–600

**Cadence**: All 64 bins transmitted in a burst immediately after each RMS frame:
- Bin 0 sent first, bin 63 sent last
- Each bin packet: 6 bytes × 10 bits/byte (8N1) = 60 µs @ 1 Mbaud
- Full burst: 64 × 60 µs ≈ 3.84 ms

**Data Integrity**: Each bin's magnitude value is latched into `latched_spec_bin` at the start of its packet (state 16) to prevent race conditions with concurrent FFT updates.

**Example Packet**:
```
DD 77 29 2A 02 8B
└─┬─┘ └─┬─┘ └───┬───┘ └──checksum──┘
  │     │   bin_index = 41 (~15.0 kHz)
  │     │   bin_magnitude = 0x022A = 554
  └─ spectrogram marker
```

---

## Transmission Sequence (Timing Diagram)

```
Time (ms)  | FPGA Output                     | UART TX
───────────┼─────────────────────────────────┼──────────────────────────────────
0–49       | Accumulating RMS window #0      | (idle)
50.00      | RMS window #0 complete          | AA 55 ... [8 bytes, ~80 µs]
50.08      | Spectrogram burst start         | DD 77 00 ... [6 bytes] (bin 0)
50.14      |                                 | DD 77 01 ... [6 bytes] (bin 1)
50.20      |                                 | DD 77 02 ... [6 bytes] (bin 2)
...        |                                 | ...
53.92      |                                 | DD 77 3F ... [6 bytes] (bin 63)
53.92      | Burst complete, seq++           | (idle)
54–99      | Accumulating RMS window #1      | (idle)
100.00     | RMS window #1 complete          | AA 55 ... [8 bytes]
100.08     | Next burst starts               | DD 77 00 ... (all 64 bins again)
```

**Result**: One complete 64-bin spectrogram every ~54 ms (~18 Hz refresh rate).

---

## Implementation Details

### On FPGA (recorder_top.v)

**State Machine** (28 states in `tx_state[4:0]`):
- States 0–15: RMS frame (AA 55 result rms flags seq metric checksum)
- States 16–27: Spectrogram slice (DD 77 bin_idx bin_lo bin_hi checksum)
- State 27 logic: if `spec_bin_idx == 63`, reset and go to state 0; otherwise increment `spec_bin_idx` and loop back to state 16

**Key signals**:
```verilog
reg [5:0]  spec_bin_idx;               // Bin counter (0–63), loops within burst
wire [15:0] current_spec_bin;           // Live read from spec_bin_magnitude
reg [15:0] latched_spec_bin;            // Latched at start of each packet for data integrity
assign current_spec_bin = spec_bin_magnitude[{spec_bin_idx, 4'b0000} +: 16];
```

**FFT path (no decimation)**:
```verilog
wire [15:0] raw_s16 = sample_data[23:8];  // Full 46.875 kHz rate to FFT
// Sign-extended to 24-bit in fft_frontend for window multiplication
```

**Magnitude downsampling** (fft_magnitude.v):
```verilog
// Only first 256 bins (real FFT), every 4th → 64 output bins
wire is_downsampled_bin = (fft_bin_index < 10'd256) && (fft_bin_index[1:0] == 2'b0);
wire [5:0] downsampled_index = fft_bin_index[7:2];
```

---

### On ESP32 (Display_codes/src/main.cpp)

#### UART RX Parser

**State Machine**:
```cpp
enum UART_STATE {
    SYNC1,           // Looking for 0xAA or 0xDD
    SYNC2_RMS,       // Looking for 0x55 (after 0xAA)
    SYNC2_SPEC,      // Looking for 0x77 (after 0xDD)
    RMS_PAYLOAD,     // Reading 6 bytes (result, rms, flags, seq, metric, checksum)
    SPEC_PAYLOAD,    // Reading 4 bytes (bin_index, bin_low, bin_high, checksum)
};
```

**RX Handler Pseudocode**:
```cpp
void uart_rx_handler(uint8_t byte) {
    static uint8_t uart_state = SYNC1;
    static uint8_t payload[8];
    static uint8_t payload_index = 0;
    
    switch (uart_state) {
        case SYNC1:
            if (byte == 0xAA) {
                uart_state = SYNC2_RMS;
                payload[0] = 0xAA;
            } else if (byte == 0xDD) {
                uart_state = SYNC2_SPEC;
                payload[0] = 0xDD;
            }
            break;
            
        case SYNC2_RMS:
            if (byte == 0x55) {
                payload[1] = 0x55;
                payload_index = 2;
                uart_state = RMS_PAYLOAD;
            } else {
                uart_state = SYNC1;
            }
            break;
            
        case SYNC2_SPEC:
            if (byte == 0x77) {
                payload[1] = 0x77;
                payload_index = 2;
                uart_state = SPEC_PAYLOAD;
            } else {
                uart_state = SYNC1;
            }
            break;
            
        case RMS_PAYLOAD:
            payload[payload_index++] = byte;
            if (payload_index == 8) {
                uint8_t checksum = payload[0] ^ payload[1] ^ payload[2] ^ 
                                  payload[3] ^ payload[4] ^ payload[5] ^ payload[6];
                if (checksum == payload[7]) {
                    process_rms_update(payload);
                }
                uart_state = SYNC1;
            }
            break;
            
        case SPEC_PAYLOAD:
            payload[payload_index++] = byte;
            if (payload_index == 6) {
                uint8_t checksum = payload[0] ^ payload[1] ^ payload[2] ^ 
                                  payload[3] ^ payload[4];
                if (checksum == payload[5]) {
                    uint8_t bin_index = payload[2];
                    uint16_t bin_magnitude = payload[3] | (payload[4] << 8);
                    if (bin_index < 64) {
                        spectrogram_buffer[bin_index] = bin_magnitude;
                        if (bin_index == 63) {
                            spectrogram_ready = true;  // Full burst received
                        }
                    }
                }
                uart_state = SYNC1;
            }
            break;
    }
}
```

#### Spectrogram Display Buffer

```cpp
// Spectrogram buffer (64 frequency bins, 16-bit magnitude per bin)
uint16_t spectrogram_buffer[64];

// Set true when bin 63 is received (full burst complete, ~18 Hz)
volatile bool spectrogram_ready = false;
```

#### Display Update Function

```cpp
void redraw_spectrogram_display() {
    // 64 bins spanning 0 to ~23.4 kHz
    // Bin spacing: ~366 Hz per bin
    for (int bin = 0; bin < 64; bin++) {
        uint16_t magnitude = spectrogram_buffer[bin];
        
        // Adaptive auto-scale
        int height = (magnitude * screen_height) / max_magnitude;
        
        lv_obj_set_height(bar_objects[bin], height);
        lv_obj_align(bar_objects[bin], 
                     LV_ALIGN_BOTTOM_LEFT, 
                     bin * bar_width,
                     0);
    }
    
    // Frequency labels:
    // "0 Hz" at bin 0
    // "~11.7 kHz" at bin 32
    // "~23.1 kHz" at bin 63
    // "~366 Hz/bin" annotation
}
```

---

## UART Settings

- **Baud Rate**: 1,000,000 (1 Mbaud)
- **Data Bits**: 8
- **Parity**: None
- **Stop Bits**: 1
- **Flow Control**: None (no RTS/CTS)

---

## Timing Performance

### RMS Responsiveness
- **Latency**: ~50 ms (one RMS window) + ~80 µs (UART TX 8 bytes @ 1 Mbaud)
- **Jitter**: Minimal (FPGA deterministic)
- **Visual Effect**: RMS bar updates smoothly every ~50 ms

### Spectrogram Refresh Rate
- **Burst duration**: 64 bins × 6 bytes × 10 bits / 1 Mbaud ≈ 3.84 ms
- **Full cycle**: ~50 ms (RMS window) + ~0.08 ms (RMS TX) + ~3.84 ms (spec burst) ≈ 54 ms
- **Refresh rate**: ~18 Hz (one complete spectrogram every ~54 ms)
- **Visual Effect**: Entire spectrogram updates as a unit, smooth real-time display

### Bandwidth Usage
- **RMS frame**: 8 bytes every ~54 ms ≈ 148 bytes/sec
- **Spectrogram burst**: 384 bytes every ~54 ms ≈ 7,111 bytes/sec
- **Total**: ~7,259 bytes/sec ≈ 58.1 kbps (well below 1 Mbaud = 100 kbps usable)

---

## Signal Conditioning & Magnitude Scaling

### Raw Magnitude Range (From FFT)
- **Output of fft_magnitude.v**: 16-bit unsigned
- **Typical idle noise**: 50–200
- **15 kHz tone (moderate volume)**: 300–600
- **Loud tone**: 2000–8000
- **Clipping threshold**: 65535 (0xFFFF)

### Input Signal Path
- INMP441 I2S output: 24-bit signed samples
- Top 16 bits used for FFT: `sample_data[23:8]` (natural truncation, no gain/AGC)
- Sign-extended to 24-bit in fft_frontend for Hann window multiplication
- Decimation path (÷6, ~7.8 kHz) retained only for RMS amplitude calculation

### Recommended ESP32 Display Scaling
```cpp
// Option 1: Linear scaling (0–1000 to screen height)
int height = (magnitude * screen_height) / 1000;

// Option 2: Logarithmic scaling (more dynamic range)
int height = (20 * log10(magnitude + 1)) * screen_height / 50;

// Option 3: Adaptive auto-scale (track max over last N frames)
static uint16_t max_magnitude = 500;
if (magnitude > max_magnitude) max_magnitude = magnitude;
int height = (magnitude * screen_height) / max_magnitude;
```

---

## Dual UART Outputs

The FPGA provides two identical UART TX outputs:
- **uart_tx** (pin N3): Edge header Pin 18 → ESP32 RX
- **uart_tx_usb** (pin J18): Onboard FTDI USB-UART bridge → PC monitoring

Both carry the same data stream (RMS frames + spectrogram bursts).

---

## Testing Checklist

### On FPGA
- [x] Build bitstream with burst-mode recorder_top.v FSM
- [x] Program CMOD A7
- [x] Verify no timing violations in implementation report
- [x] Verify 0 checksum errors in PC spectrogram viewer
- [x] Confirm 15 kHz test tone resolves to correct bin (~41)

### On ESP32
- [ ] Compile with new UART RX handler (detect DD 77 burst)
- [ ] Set UART baud to 1,000,000
- [ ] Connect FPGA uart_tx (N3) to ESP32 RX
- [ ] Verify sync bytes (0xAA 0x55 and 0xDD 0x77) in serial monitor
- [ ] Confirm RMS bar updates every ~50 ms
- [ ] Confirm spectrogram display updates ~18 Hz
- [ ] Play test tones and verify frequency peaks

### System Integration
- [ ] RMS bar is responsive and smooth
- [ ] Spectrogram updates as a complete frame (not one bin at a time)
- [ ] No checksum errors or dropped packets
- [ ] Display remains stable during 10-minute runtime

---

## Backward Compatibility

The new protocol is **backward compatible** with existing RMS-only displays:

- Old parsers that only recognize `0xAA 0x55` will continue to work.
- They will simply ignore the `0xDD 0x77` spectrogram packets.
- No changes required to existing ESP32 firmware unless spectrogram display is desired.

**Breaking change from previous version**: Spectrogram bins are now sent as a burst (all 64 after each RMS frame) instead of one bin per RMS cycle. ESP32 parsers expecting round-robin delivery must be updated to handle the burst pattern.

---

## Future Enhancements

1. **Compressed Magnitude**: Use 8-bit log-compressed features instead of 16-bit linear if display precision allows (saves 50% bandwidth).
2. **Waterfall Plot**: Stack multiple spectrograms vertically for time-series visualization on ESP32 display.
3. **CNN Integration**: Send CNN confidence in `metric` byte to highlight anomaly bins in spectrogram.
4. **Selective Bin Transmission**: Only send bins that changed significantly (delta compression).

---

## References

- FFT Output Format: [fft_magnitude.v](./src_main/fft_magnitude.v) (16-bit magnitude, first 256 bins, every 4th)
- Spectrogram Packing: [fft_frontend.v](./src_main/fft_frontend.v) (1024-bit packed bus)
- Top-level FSM: [recorder_top.v](./src_main/recorder_top.v) (burst-mode UART state machine)
- Current UART Protocol: [CMOD_A7_PROJECT_REFERENCE.md](./CMOD_A7_PROJECT_REFERENCE.md) (RMS frame format)
- PC Viewer Tool: [tools/spectrogram_viewer.py](./tools/spectrogram_viewer.py) (real-time tkinter+matplotlib GUI)
# UART Spectrogram Streaming Protocol
## ESP32 Real-time Spectrogram Display from CMOD A7 FPGA

---

## Overview

This document specifies the UART protocol for streaming spectrograms from the FPGA to the ESP32 for real-time visualization. The protocol prioritizes **RMS telemetry responsiveness** while streaming spectrogram data asynchronously in slices.

**Design Goal**: RMS updates every ~50 ms (high priority), spectrogram builds progressively over ~3 seconds (low priority, one bin per telemetry cycle).

---

## Current Implementation

Both frame types are implemented and active in `recorder_top.v`:

```
(1) RMS Telemetry Frame (8 bytes - HIGH PRIORITY)
    [0xAA] [0x55] [result] [rms] [flags] [seq] [metric] [checksum]
    → Sent every ~50 ms (every new RMS window)

(2) Spectrogram Slice Packet (6 bytes - INTERLEAVED)
    [0xDD] [0x77] [frame_index: 0-63] [bin_low] [bin_high] [checksum]
    → Sent after each RMS frame (one bin per RMS cycle)
    → Completes one full spectrogram in ~64 × 50 ms ≈ 3.2 seconds
```

---

## UART Frame Formats

### Frame 1: RMS Telemetry (Existing, No Changes)

**Sync & Format**:
```
Byte 0:   0xAA (sync)
Byte 1:   0x55 (sync)
Byte 2:   result (8-bit)
Byte 3:   rms (8-bit amplitude, 0–255)
Byte 4:   flags (8-bit: [reserved×6, fpga_active, overflow])
Byte 5:   seq (8-bit sequence counter, 0–255)
Byte 6:   metric (8-bit CNN confidence / anomaly score, 0–255)
Byte 7:   checksum (= 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric)
```

**Cadence**: Sent every ~50 ms (fixed WINDOW_SAMPLES in recorder_top.v).

**Example**:
```
AA 55 00 7F 01 05 42 36
└─┬─┘ └─┬─┘ └──checksum──┘
  │     └─ rms = 127 (medium amplitude)
  └─ sync bytes
```

---

### Frame 2: Spectrogram Slice Packet (NEW)

**Sync & Format**:
```
Byte 0:   0xDD (sync, spectrogram marker)
Byte 1:   0x77 (sync, spectrogram marker)
Byte 2:   frame_index (8-bit, 0–63, which row of the 64-bin spectrogram)
Byte 3:   bin_magnitude_low (8-bit, LSB of 16-bit magnitude)
Byte 4:   bin_magnitude_high (8-bit, MSB of 16-bit magnitude)
Byte 5:   checksum (= 0xDD ^ 0x77 ^ frame_index ^ bin_low ^ bin_high)
```

**Frame Index Interpretation**:
- `frame_index = 0`: First bin (lowest frequency, ~0 Hz)
- `frame_index = 1`: Second bin (~122 Hz)
- ...
- `frame_index = 63`: Last bin (highest frequency, ~3.9 kHz)

**Magnitude Value**:
- 16-bit unsigned, range: 0x0000–0xFFFF (0–65535)
- Stored as little-endian: `bin_magnitude = bin_low | (bin_high << 8)`
- Typical values for audio noise: 100–5000
- Peak values during 440 Hz tone: ~2000–8000

**Cadence**: Transmitted in a round-robin fashion:
- Time slot 0: Transmit frame_index 0 (bin 0)
- Time slot 1: Transmit frame_index 1 (bin 1)
- ...
- Time slot 63: Transmit frame_index 63 (bin 63)
- Time slot 64: Return to frame_index 0 (loop)

**Example Packet**:
```
DD 77 1C 2A 08 8A
└─┬─┘ └─┬─┘ └────┬────┘ └──checksum──┘
  │     │     frame_index = 28 (440 Hz bin)
  │     │     bin_magnitude = 0x082A = 2090
  └─ spectrogram marker
```

---

## Transmission Sequence (Timing Diagram)

**Scenario**: RMS Window Period = 50 ms, Spectrogram Updates = Every RMS window.

```
Time (ms)  | FPGA Output                    | UART TX
───────────┼────────────────────────────────┼──────────────────────────
0–49       | Accumulating RMS window #0     | (idle or other data)
50         | RMS window #0 complete         | AA 55 ... [8 bytes]
51         | spec_frame_valid pulse         | DD 77 00 ... [6 bytes] (bin 0)
52         | Accumulating RMS window #1     | (idle)
100        | RMS window #1 complete         | AA 55 ... [8 bytes]
101        | spec_frame_valid pulse         | DD 77 01 ... [6 bytes] (bin 1)
102        | Accumulating RMS window #2     | (idle)
...
3150       | RMS window #63 complete        | AA 55 ... [8 bytes]
3151       | spec_frame_valid pulse         | DD 77 3F ... [6 bytes] (bin 63)
3200       | RMS window #64 complete        | AA 55 ... [8 bytes]
3201       | spec_frame_valid pulse         | DD 77 00 ... [6 bytes] (bin 0, loop restart)
```

**Result**: One complete 64-bin spectrogram transmitted every ~3.2 seconds.

---

## Implementation Changes

### On FPGA (recorder_top.v)

**Implemented State Machine** (28 states in `tx_state[4:0]`):
- States 0–15: RMS frame (AA 55 result rms flags seq metric checksum) with byte-by-byte UART handshake
- States 16–27: Spectrogram slice (DD 77 bin_idx bin_lo bin_hi checksum)
- After state 27 completes: `tx_seq` increments, `spec_bin_idx` advances (0→63→0), returns to state 0

**Key signals**:
```verilog
reg [5:0]  spec_bin_idx;           // Round-robin bin counter (0–63)
wire [15:0] current_spec_bin;      // Extracted from spec_bin_magnitude
assign current_spec_bin = spec_bin_magnitude[{spec_bin_idx, 4'b0000} +: 16];
```

---

### On ESP32 (Display_codes/src/main.cpp)

#### UART RX Parser (Modified)

**New State Machine**:
```cpp
enum UART_STATE {
    SYNC1,           // Looking for 0xAA or 0xDD
    SYNC2_RMS,       // Looking for 0x55 (after 0xAA)
    SYNC2_SPEC,      // Looking for 0x77 (after 0xDD)
    RMS_PAYLOAD,     // Reading 6 bytes (result, rms, flags, seq, metric, checksum)
    SPEC_PAYLOAD,    // Reading 4 bytes (frame_index, bin_low, bin_high, checksum)
};
```

**RX Handler Pseudocode**:
```cpp
void uart_rx_handler(uint8_t byte) {
    static uint8_t uart_state = SYNC1;
    static uint8_t payload[8];
    static uint8_t payload_index = 0;
    
    switch (uart_state) {
        case SYNC1:
            if (byte == 0xAA) {
                uart_state = SYNC2_RMS;
                payload[0] = 0xAA;
            } else if (byte == 0xDD) {
                uart_state = SYNC2_SPEC;
                payload[0] = 0xDD;
            }
            break;
            
        case SYNC2_RMS:
            if (byte == 0x55) {
                payload[1] = 0x55;
                payload_index = 2;
                uart_state = RMS_PAYLOAD;
            } else {
                uart_state = SYNC1;
            }
            break;
            
        case SYNC2_SPEC:
            if (byte == 0x77) {
                payload[1] = 0x77;
                payload_index = 2;
                uart_state = SPEC_PAYLOAD;
            } else {
                uart_state = SYNC1;
            }
            break;
            
        case RMS_PAYLOAD:
            payload[payload_index++] = byte;
            if (payload_index == 8) {
                // Validate checksum
                uint8_t checksum = payload[0] ^ payload[1] ^ payload[2] ^ 
                                  payload[3] ^ payload[4] ^ payload[5] ^ payload[6];
                if (checksum == payload[7]) {
                    // Valid RMS frame
                    uint8_t rms_value = payload[3];
                    process_rms_update(rms_value);  // Update UI immediately
                }
                uart_state = SYNC1;
            }
            break;
            
        case SPEC_PAYLOAD:
            payload[payload_index++] = byte;
            if (payload_index == 6) {
                // Validate checksum
                uint8_t checksum = payload[0] ^ payload[1] ^ payload[2] ^ 
                                  payload[3] ^ payload[4];
                if (checksum == payload[5]) {
                    // Valid spectrogram packet
                    uint8_t frame_index = payload[2];
                    uint16_t bin_magnitude = payload[3] | (payload[4] << 8);
                    spectrogram_buffer[frame_index] = bin_magnitude;
                    
                    if (frame_index == 63) {
                        // Complete spectrogram received
                        redraw_spectrogram_display();
                    }
                }
                uart_state = SYNC1;
            }
            break;
    }
}
```

#### Spectrogram Display Buffer

**In global scope**:
```cpp
// Spectrogram buffer (64 frequency bins, 16-bit magnitude per bin)
uint16_t spectrogram_buffer[64];

// Display refresh flag
volatile bool spectrogram_ready = false;
```

#### Display Update Function

```cpp
void redraw_spectrogram_display() {
    // Example: Draw a bar chart with 64 bins
    // Each bin mapped to X position: 0–319 (on 320px wide screen)
    // Each bin magnitude mapped to Y height: 0–max_pixel_height
    
    // Pseudocode for LVGL
    for (int bin = 0; bin < 64; bin++) {
        uint16_t magnitude = spectrogram_buffer[bin];
        
        // Normalize magnitude to display range (e.g., 0–8000 → 0–100 pixels)
        int height = (magnitude * 100) / 8000;  // Adjust scaling as needed
        
        // Draw bar at X position (bin × 5 pixels) with height
        lv_obj_set_height(bar_objects[bin], height);
        lv_obj_align(bar_objects[bin], 
                     LV_ALIGN_BOTTOM_LEFT, 
                     bin * 5,           // X offset
                     0);                // Y offset
    }
    
    // Optional: Add frequency labels
    // "0 Hz" at bin 0
    // "3.9 kHz" at bin 63
    // "~122 Hz/bin" annotation
}
```

---

## UART Settings (Unchanged)

- **Baud Rate**: 1,000,000 (1 Mbaud)
- **Data Bits**: 8
- **Parity**: None
- **Stop Bits**: 1
- **Flow Control**: None (no RTS/CTS)

---

## Timing Performance

### RMS Responsiveness
- **Latency**: ~50 ms (one RMS window) + ~50 µs (UART TX 8 bytes @ 1 Mbaud)
- **Jitter**: Minimal (FPGA deterministic)
- **Visual Effect**: RMS bar updates smoothly every 50 ms

### Spectrogram Build Rate
- **Per-bin latency**: ~50 ms + ~50 µs (one RMS cycle + UART TX 6 bytes)
- **Full image**: 64 bins × ~50 ms = ~3.2 seconds per complete spectrogram
- **Refresh rate**: ~0.3 Hz (one spectrogram every ~3.2 seconds)
- **Visual Effect**: Spectrogram bar chart updates one bin at a time, gradually filling from left to right

### Bandwidth Usage
- **RMS frame**: 8 bytes every 50 ms = 160 bytes/sec
- **Spectrogram packet**: 6 bytes every 50 ms = 120 bytes/sec (1 bin per RMS window)
- **Total**: 280 bytes/sec ≈ 2.24 kbps (well below 1 Mbaud = 125 kbps capacity)

---

## Signal Conditioning & Magnitude Scaling

### Raw Magnitude Range (From FFT)
- **Output of fft_magnitude.v**: 16-bit unsigned
- **Typical idle noise**: 100–500
- **440 Hz tone (moderate volume)**: 2000–5000
- **440 Hz tone (loud)**: 8000–15000
- **Clipping threshold**: 65535 (0xFFFF)

### Recommended ESP32 Display Scaling
```cpp
// Option 1: Linear scaling (0–8000 to screen height)
int height = (magnitude * screen_height) / 8000;

// Option 2: Logarithmic scaling (more dynamic range)
int height = (20 * log10(magnitude + 1)) * screen_height / 50;

// Option 3: Adaptive auto-scale (track max over last N frames)
static uint16_t max_magnitude = 1000;
if (magnitude > max_magnitude) max_magnitude = magnitude;
int height = (magnitude * screen_height) / max_magnitude;
```

---

## Testing Checklist

### On FPGA
- [ ] Build bitstream with new recorder_top.v FSM
- [ ] Program CMOD A7
- [ ] Verify no timing violations in implementation report
- [ ] Monitor LED (heartbeat pulse every ~1 second)

### On ESP32
- [ ] Compile with new UART RX handler
- [ ] Set UART baud to 1,000,000
- [ ] Connect FPGA uart_tx (N3) to ESP32 RX
- [ ] Verify sync bytes (0xAA 0x55 and 0xDD 0x77) in serial monitor
- [ ] Confirm RMS bar updates every ~50 ms
- [ ] Confirm spectrogram pixels update one at a time
- [ ] Send 440 Hz tone to microphone, verify peak at bin ~28

### System Integration
- [ ] RMS bar is responsive and smooth
- [ ] Spectrogram gradually fills from left to right
- [ ] No checksum errors or dropped packets
- [ ] Display remains stable during 10-minute runtime

---

## Backward Compatibility

The new protocol is **backward compatible** with existing RMS-only displays:

- Old parsers that only recognize `0xAA 0x55` will continue to work.
- They will simply ignore the `0xDD 0x77` spectrogram packets.
- No changes required to existing ESP32 firmware unless spectrogram display is desired.

---

## Future Enhancements

1. **Variable Bin Grouping**: Send 2–8 bins per packet to increase spectrogram refresh rate.
2. **Compressed Magnitude**: Use 8-bit magnitude instead of 16-bit if display precision allows.
3. **Waterfall Plot**: Stack multiple spectrograms vertically for time-series visualization.
4. **Adaptive Decimation**: Reduce spectrogram update rate during silence to save bandwidth.
5. **CNN Integration**: Send CNN confidence in `metric` byte to highlight anomaly bins in spectrogram.

---

## References

- FFT Output Format: [fft_magnitude.v](./src_main/fft_magnitude.v) (16-bit magnitude per bin)
- Spectrogram Packing: [fft_frontend.v](./src_main/fft_frontend.v) (1024-bit packed bus)
- Current UART Protocol: [CMOD_A7_PROJECT_REFERENCE.md](./CMOD_A7_PROJECT_REFERENCE.md) (RMS frame format)
- Simulation Testbench: [fft_test_simple.v](./testbench/fft_test_simple.v)
