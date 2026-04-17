# CNN Integration Plan: myproject (hls4ml Autoencoder) into recorder_top

## 1. CNN IP Analysis (Slimmer Model)

### 1.1 Top-Level Ports

```
module myproject (
    // AXI-Stream Input
    input  [7:0]  input_4_TDATA,      // 8-bit unsigned, ufixed<8,0>
    input         input_4_TVALID,
    output        input_4_TREADY,

    // AXI-Stream Output
    output [7:0]  layer16_out_TDATA,   // 8-bit unsigned, ufixed<8,0>
    output        layer16_out_TVALID,
    input         layer16_out_TREADY,

    // Block-Level Control (ap_ctrl_hs)
    input         ap_clk,              // Must be ≥100 MHz (10 ns target)
    input         ap_rst_n,            // Active-low reset
    input         ap_start,            // Pulse to begin inference
    output        ap_done,             // Pulses when inference complete
    output        ap_ready,            // Ready for next ap_start
    output        ap_idle              // All submodules idle
);
```

### 1.2 Internal Dataflow Pipeline (15 stages)

```
input_4 (8-bit AXI-S)
  │
  └─ [layer17] ZeroPad2D (64×64×1 → 66×66×1)
       └─ [layer2] Conv2D (66×66×1 → 64×64×4, kernel 3×3, ufixed<8,0>→fixed<16,6>)
            └─ [layer4] ReLU (→ufixed<8,2>)
                 └─ [layer5] MaxPool2D (64×64×4 → 32×32×4)
                      └─ [layer18] ZeroPad2D (→34×34×4)
                           └─ [layer6] Conv2D (34×34×4 → 32×32×4, fixed<16,6>)
                                └─ [layer8] ReLU (→ufixed<6,1>)
                                     └─ [layer9] MaxPool2D (32×32×4 → 16×16×4)
                                          └─ [layer19] ZeroPad2D (→18×18×4)
                                               └─ [layer10] Conv2D (18×18×4 → 16×16×4, fixed<8,4>)
                                                    └─ [layer12] ReLU (→ufixed<4,1>)
                                                         └─ [layer13] Resize/Upsample (16×16×4 → 64×64×4)
                                                              └─ [layer20] ZeroPad2D (→66×66×4)
                                                                   └─ [layer14] Conv2D (→64×64×1, fixed<16,6>)
                                                                        └─ [layer16] ReLU (→ufixed<8,0>)
                                                                             │
                                                                      layer16_out (8-bit AXI-S)
```

### 1.3 Performance & Resources (HLS Estimates)

| Metric                | Value                          |
|-----------------------|--------------------------------|
| Input shape           | 64 × 64 × 1 = **4,096 pixels** (streamed one at a time) |
| Output shape          | 64 × 64 × 1 = **4,096 pixels** |
| Input data type       | `ufixed<8,0>` → unsigned [0, 255] integer |
| Output data type      | `ufixed<8,0>` → unsigned [0, 255] integer |
| Target clock          | 10 ns (100 MHz)                |
| Achieved clock        | 8.679 ns (115 MHz possible)    |
| Worst-case latency    | 178,602 cycles → **1.786 ms @ 100 MHz** |
| Throughput interval   | 13,135–178,597 cycles          |
| BRAM_18K (HLS est.)   | 73 / 100 (73%)                 |
| DSP                   | 1 / 90 (1%)                    |
| FF                    | 10,295 / 41,600 (25%)          |
| LUT                   | 14,612 / 20,800 (70%)          |

### 1.4 Key Observation: 8-bit Direct Match

The **slimmer model input is 8-bit `ufixed<8,0>`**, which is an exact match to the `spec_bin_feature8` output (8-bit log₂-companded [0,255]). **No format conversion is needed** — bytes from the spectrogram buffer can be fed directly to `input_4_TDATA`.

---

## 2. Current System Architecture

```
          12 MHz
            │
 ┌──────────┴──────────┐
 │     recorder_top     │
 │                      │
 │  INMP441 → I2S Rx   │
 │           │          │
 │      (24-bit @ 46.875 kHz)
 │           │          │
 │    FFT Frontend      │   512-point FFT, hop=64
 │    ├─ spec_bin_magnitude [1023:0]  (64 × 16-bit)
 │    └─ spec_bin_feature8  [511:0]   (64 ×  8-bit)
 │           │          │
 │  spectrogram_buffer  │   64×64×8, single buffer, FF-based
 │    ├─ frame_complete │
 │    └─ latest_line    │
 │           │          │
 │  Threshold detector  │   placeholder anomaly_result
 │           │          │
 │    UART TX FSM       │   1 Mbaud, 8N1
 │    ├─ RMS frame      │   AA 55 result rms flags seq metric chk
 │    └─ Spec burst ×64 │   DD 77 idx lo hi chk
 │           │          │
 │  uart_tx → N3 (ESP32)│
 │  uart_tx_usb → J18   │
 └─────────────────────┘
```

### 2.1 Current Spectrogram Buffer Problem

```verilog
reg [7:0] mem [0:63][0:63];  // 4096 bytes
// Writes 64 bytes simultaneously:
for (i = 0; i < 64; i = i + 1)
    mem[line_index[5:0]][i] <= line_data[(i+1)*8-1 -: 8];
```

**Issues:**
1. **512-bit write width** → Vivado synthesizes as flip-flops/LUTRAM, not BRAM
2. **No read port** → CNN cannot access stored data
3. **Single buffer** → No ping-pong, data corrupted during read if writing simultaneously

---

## 3. Clock Domain Strategy

### 3.1 The Clock Problem

| Domain        | Clock | Used By |
|---------------|-------|---------|
| System        | 12 MHz | I2S, FFT, UART, spectrogram write |
| CNN           | 100 MHz | myproject IP |

The CNN IP requires ≥100 MHz (10 ns period, achieved 8.679 ns). The system runs at 12 MHz.

### 3.2 Solution: MMCM/PLL to Generate 100 MHz from 12 MHz

The xc7a35t MMCM can synthesize 100 MHz from 12 MHz:

```
12 MHz × (50/6) = 100 MHz     (M=50.000, D=1, CLKOUT_DIVIDE=6)
```

**Both clocks stay active.** The 12 MHz domain continues running all existing logic (I2S, FFT, UART). The 100 MHz domain runs only the CNN IP and the BRAM read port. The ping-pong BRAM acts as the clock domain crossing (true dual-port BRAM with independent clocks per port).

### 3.3 Impact on UART

**UART is unaffected.** The UART TX module stays in the 12 MHz domain. It continues sending at 1 Mbaud. The only change is that `anomaly_result` and `tx_metric` will come from the CNN output instead of the placeholder threshold — these signals need a simple 2-FF synchronizer from the 100 MHz domain back to 12 MHz.

**UART timing analysis:**
- Current full burst cycle: ~54 ms (~18 Hz refresh)
- CNN inference: ~1.786 ms
- Spectrogram frame fill: ~87.4 ms
- CNN result is available **well before** the next UART burst needs it
- **No UART speed change needed**

---

## 4. Revised Ping-Pong Buffer Design

### 4.1 Updated Requirements (Slimmer Model)

The previous plan assumed 16-bit `fixed<16,6>` input requiring format conversion. With the slimmer model:

| Item | Old Plan | **New Plan** |
|------|----------|-------------|
| CNN input width | 16-bit | **8-bit** |
| Format conversion | 8-bit → fixed<16,6> | **None (direct 8-bit)** |
| AXI-Stream data | `input_6_TDATA[15:0]` | **`input_4_TDATA[7:0]`** |
| BRAM word width | Could use 16-bit | **8-bit is sufficient** |

### 4.2 Architecture: `spectrogram_pingpong`

```
                  12 MHz domain                     100 MHz domain
             ┌─────────────────────────┐      ┌────────────────────────┐
             │                         │      │                        │
line_data ──►│  Line Deserializer      │      │   AXI-Stream Feeder    │
(512-bit)    │  (64 sequential byte    │      │   (reads BRAM → TDATA) │
line_valid ─►│   writes per line)      │      │                        │
line_index ─►│         │               │      │      │       ▲         │
             │         ▼               │      │      ▼       │         │
             │  ┌─────────────┐        │      │  ┌───────────────┐     │
             │  │ BRAM A      │ WR◄────│──────│──►RD             │     │
             │  │ 4096 × 8    │        │      │  │               │     │
             │  │ (Port A:WR) │        │      │  │ (Port B:RD)   │     │
             │  └─────────────┘        │      │  └───────────────┘     │
             │                         │      │      │                 │
             │  ┌─────────────┐        │      │  ┌───────────────┐     │
             │  │ BRAM B      │ WR◄────│──────│──►RD             │     │
             │  │ 4096 × 8    │        │      │  │               │     │
             │  │ (Port A:WR) │        │      │  │ (Port B:RD)   │     │
             │  └─────────────┘        │      │  └───────────────┘     │
             │         ▲               │      │      │                 │
             │         │               │      │      ▼                 │
             │  Swap FSM               │      │   To myproject         │
             │  (sel toggles on        │      │   input_4_TDATA        │
             │   frame_complete AND    │      │                        │
             │   cnn_done)             │      │                        │
             └─────────────────────────┘      └────────────────────────┘
```

### 4.3 BRAM Configuration

Each buffer: 4,096 × 8-bit = 32 Kbit = **2 × BRAM_18K** (or 1 × BRAM_36K)

| Parameter | Value |
|-----------|-------|
| Depth     | 4,096 (12-bit address) |
| Width     | 8 bits |
| Mode      | True Dual-Port |
| Port A    | 12 MHz, write-only (from deserializer) |
| Port B    | 100 MHz, read-only (to CNN feeder + comparison) |
| Total     | 2 buffers × 2 BRAM_18K = **4 BRAM_18K** (2 BRAM_36K tiles) |

### 4.4 Write Side: Line Deserializer (12 MHz)

Current interface: `line_data[511:0]` delivers a full 64-byte line in one clock cycle.

The deserializer captures `line_data` in a shift register on `line_valid`, then writes 64 sequential byte writes over the next 64 clocks:

```
Address = {line_index[5:0], byte_idx[5:0]}    // 12-bit: row[5:0] concat col[5:0]
Data    = captured_line[(byte_idx+1)*8-1 -: 8]
```

At 12 MHz, 64 writes take **5.33 µs**. The next line arrives in **1.365 ms** (16,380 clocks). Plenty of margin.

### 4.5 Read Side: AXI-Stream Feeder (100 MHz)

Triggered when `cnn_start` is asserted (after frame_complete + buffer swap). Sequentially reads all 4,096 addresses from the "process" BRAM:

```
State machine:
  IDLE: wait for cnn_start
  FEED: addr++ each cycle when input_4_TREADY=1
        drive input_4_TDATA = bram_rd_data
        drive input_4_TVALID = 1
        when addr reaches 4095 → WAIT_DONE
  WAIT_DONE: drive layer16_out_TREADY=1, wait for ap_done
```

At 100 MHz, feeding 4,096 bytes takes **40.96 µs** (negligible vs 1.786 ms total inference).

### 4.6 Swap Logic

```
sel register: 0 = "write to A, process B"
              1 = "write to B, process A"

Swap condition: frame_complete AND cnn_idle
  (both in 12 MHz domain — cnn_idle is synchronized from 100 MHz first)

If frame_complete fires but CNN is still busy:
  → Do NOT swap. Continue writing to current buffer (overwrite previous data).
  → This drops the frame. Acceptable since CNN is 49× faster — this should never happen
    in normal operation, only as a safety net.
```

---

## 5. Anomaly Score Computation

### 5.1 Reconstruction Error

The autoencoder reconstructs the input. The anomaly score is the reconstruction error:

```
error = Σ |input[i] - output[i]|    for i = 0..4095
```

This is a **Mean Absolute Error (MAE)** computed on 4,096 pixel pairs.

### 5.2 Implementation: On-the-Fly Comparison

During the CNN output phase, when `layer16_out_TVALID` is high:

1. **Re-read** the same BRAM (process buffer) at the same address sequence
2. **Compute** `|bram_rd_data - layer16_out_TDATA|` per pixel
3. **Accumulate** into a running sum (20-bit is sufficient: max = 255 × 4096 = 1,044,480)
4. When all 4,096 outputs received, divide by 4,096 (right-shift by 12) → 8-bit MAE

```
anomaly_score = error_sum[19:12]     // 8-bit mean absolute error
anomaly_result = (anomaly_score > THRESHOLD)
```

### 5.3 Comparison Reader Coordination

The comparison reader must track which output pixel corresponds to which input pixel. Since the CNN is a **streaming dataflow** architecture (no reordering), outputs arrive in the same row-major order as inputs. The comparison reader simply increments a read address counter synchronized with `layer16_out_TVALID`.

---

## 6. Updated Resource Budget

| Component              | BRAM_18K | LUT    | FF     | DSP |
|------------------------|----------|--------|--------|-----|
| Your design (current)  | ~7 (7%) | ~7,000 (34%) | ~15,000 (36%) | 25 (28%) |
| CNN IP (Vivado actual*) | 70 tiles** | 5,047 (24%) | 6,513 (16%) | 2 (2%) |
| Ping-pong buffer       | 4 (4%)  | ~200 (1%) | ~100 (0.2%) | 0 |
| MMCM/PLL               | 0       | ~50    | ~50    | 0 |
| AXI-Stream feeder      | 0       | ~100   | ~80    | 0 |
| Comparison logic        | 0       | ~80    | ~50    | 0 |
| CDC synchronizers       | 0       | ~20    | ~20    | 0 |
| **Estimated Total**    | **~81 (81%)** | **~12,500 (60%)** | **~21,800 (52%)** | **27 (30%)** |

*Using Eric's actual Vivado post-synthesis numbers where available; HLS estimates otherwise.

**BRAM is the tightest resource at ~81%. All others have comfortable margin.**

---

## 7. Step-by-Step Implementation Plan

### Phase 1: Clock Infrastructure

**Step 1.1 — Create PLL/MMCM wrapper module** (`src_main/clk_gen.v`)
- Instantiate `MMCME2_BASE` primitive
- Input: 12 MHz (`clk`)
- Output: 100 MHz (`clk_100m`), locked signal (`mmcm_locked`)
- Constraints: Add `create_clock` and `create_generated_clock` to XDC

**Step 1.2 — Modify recorder_top reset logic**
- Extend the existing power-on reset to also wait for `mmcm_locked`
- `rst_n = rst_cnt[3] & mmcm_locked`

### Phase 2: Ping-Pong Double Buffer

**Step 2.1 — Create ping-pong buffer module** (`src_main/spectrogram_pingpong.v`)
- **Write interface** (12 MHz domain):
  - `line_valid`, `line_index[5:0]`, `line_data[511:0]`
  - Internal line deserializer: captures line_data, writes 64 bytes sequentially
  - `frame_complete` output (when line_index reaches 63)
- **Read interface** (directly exposed BRAM port B for the 100 MHz feeder):
  - `rd_clk` (100 MHz), `rd_addr[11:0]`, `rd_data[7:0]`
- **Swap logic**:
  - `sel` register toggles on `frame_complete && cnn_idle_sync`
  - `cnn_idle_sync` is 2-FF synchronized from the 100 MHz domain
- **BRAM instantiation**: Use Verilog inference style for true dual-port BRAM:
  ```verilog
  (* ram_style = "block" *) reg [7:0] bram_a [0:4095];
  (* ram_style = "block" *) reg [7:0] bram_b [0:4095];
  ```
- Also expose `frame_id` output for UART sequencing

**Step 2.2 — Replace spectrogram_buffer_64x64 in recorder_top**
- Swap out the `spectrogram_buffer_64x64` instantiation for `spectrogram_pingpong`
- Keep the same write-side signals (`spec_frame_valid`, `spec_frame_index`, `spec_bin_feature8`)
- Wire new `rd_*` ports to the CNN feeder module
- Remove/deprecate `spectrogram_buffer_64x64.v` (keep for reference)

### Phase 3: AXI-Stream CNN Interface

**Step 3.1 — Create AXI-Stream feeder module** (`src_main/cnn_axi_feeder.v`)
- Operates in 100 MHz domain
- **Inputs**: `start`, BRAM read data
- **Outputs**: `input_4_TDATA[7:0]`, `input_4_TVALID`, BRAM read address
- **Inputs from CNN**: `input_4_TREADY`
- **FSM**:
  ```
  IDLE → (start) → FEEDING → (addr==4095 && TREADY) → DONE
  ```
- Respects AXI-Stream backpressure: only advances address when `TREADY` is high

**Step 3.2 — Create comparison & anomaly scorer module** (`src_main/cnn_anomaly_scorer.v`)
- Operates in 100 MHz domain
- **Inputs**: `layer16_out_TDATA[7:0]`, `layer16_out_TVALID`, BRAM read data
- **Outputs**: `anomaly_score[7:0]`, `anomaly_valid`, `layer16_out_TREADY`
- Re-reads the process BRAM (same port B, address muxed with feeder — feeder goes first, then comparison reader takes over)
- Computes absolute difference per pixel, accumulates sum
- When 4,096 outputs collected: `anomaly_score = error_sum[19:12]`
- Asserts `anomaly_valid` for one cycle

**Step 3.3 — Create CNN integration wrapper** (`src_main/cnn_wrapper.v`)
- Ties together:
  - BRAM read port mux (feeder vs comparison reader)
  - `cnn_axi_feeder`
  - `myproject` instance
  - `cnn_anomaly_scorer`
- **Control FSM (100 MHz)**:
  ```
  IDLE: wait for frame_ready (synchronized from 12 MHz)
      → assert ap_start, go to FEED
  FEED: feeder reads BRAM, streams to CNN
      → when feeder done, go to PROCESS
  PROCESS: wait for CNN output to stream
      → comparison reader active, accumulating error
      → when ap_done, go to RESULT
  RESULT: latch anomaly_score, assert cnn_done
      → go to IDLE
  ```
- **Outputs to 12 MHz domain**: `cnn_done`, `anomaly_score[7:0]`, `cnn_idle`

### Phase 4: Clock Domain Crossing & Top-Level Wiring

**Step 4.1 — CDC synchronizers**

Signals crossing 12 MHz → 100 MHz:
- `frame_ready` (pulse): Use pulse synchronizer (toggle + 2-FF)

Signals crossing 100 MHz → 12 MHz:
- `cnn_idle` (level): 2-FF synchronizer
- `cnn_done` (pulse): Pulse synchronizer
- `anomaly_score[7:0]` (bus): Latch in 100 MHz, read after `cnn_done` sync — safe because value is stable when `cnn_done` arrives

**Step 4.2 — Update recorder_top**
- Add `clk_100m` from PLL
- Instantiate `spectrogram_pingpong`
- Instantiate `cnn_wrapper` (with `clk_100m`)
- Replace placeholder `anomaly_result` with CNN-derived threshold:
  ```verilog
  anomaly_result <= (anomaly_score_sync > ANOMALY_THRESHOLD);
  ```
- Feed `anomaly_score_sync` into `tx_metric` (UART byte 6) — this replaces the hardcoded `8'd0`
- `tx_result` gets the thresholded CNN result instead of window energy comparison

### Phase 5: Constraints & Build

**Step 5.1 — Update XDC constraints**
- Add clock constraints for 100 MHz generated clock
- Add `set_clock_groups -asynchronous` between 12 MHz and 100 MHz
- No new pin assignments needed (CNN is internal)

**Step 5.2 — Add CNN Verilog sources to build**
- Update `scripts/config.tcl` or `scripts/build.tcl` to include all `.v` files from `model_hls_output/myproject_prj/solution1/impl/verilog/`
- Verify all ~40 submodule .v files are included

**Step 5.3 — Synthesis & verification**
- Run synthesis, check resource utilization vs budget
- Verify timing closure on both 12 MHz and 100 MHz domains
- Check BRAM utilization ≤ 50 tiles

### Phase 6: Testing

**Step 6.1 — Simulation testbench**
- Feed known spectrogram pattern into `spectrogram_pingpong`
- Verify CNN receives correct 4,096-byte stream
- Verify anomaly_score computation
- Verify ping-pong swap timing

**Step 6.2 — Hardware validation**
- Program FPGA
- Use spectrogram_viewer.py to observe:
  - `tx_result` now reflects CNN anomaly detection (not energy threshold)
  - `tx_metric` (byte 6) shows CNN anomaly score (0-255)
- Verify no glitches in UART stream during CNN processing

---

## 8. New Module Summary

| Module | File | Clock Domain | Purpose |
|--------|------|-------------|---------|
| `clk_gen` | `src_main/clk_gen.v` | — | MMCM: 12 MHz → 100 MHz |
| `spectrogram_pingpong` | `src_main/spectrogram_pingpong.v` | 12 MHz (write) | Ping-pong BRAM buffer |
| `cnn_axi_feeder` | `src_main/cnn_axi_feeder.v` | 100 MHz | BRAM → AXI-Stream |
| `cnn_anomaly_scorer` | `src_main/cnn_anomaly_scorer.v` | 100 MHz | Reconstruction error |
| `cnn_wrapper` | `src_main/cnn_wrapper.v` | 100 MHz | CNN + feeder + scorer |

---

## 9. Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| BRAM overflow (~81%) | Medium | Eric's actual Vivado numbers showed 70% not 77%. Real total likely ~75%. If needed, can share BRAM port between feeder and comparison (saves 0 BRAM but simplifies logic). |
| LUT overflow | Low | Slimmer model actual Vivado was 24% LUT, not 70% HLS estimate. Comfortable margin. |
| Timing closure at 100 MHz | Medium | HLS achieved 8.679 ns. xc7a35t supports 100 MHz easily. Run `report_timing_summary` after synthesis. |
| CDC-related bugs | Medium | Use proven patterns: 2-FF sync for levels, toggle-based for pulses. Keep bus crossings static during handshake. |
| Frame drops | Very Low | CNN is 49× faster than frame fill. Swap logic only needs to wait in edge cases. |
| CNN accuracy on FPGA vs Python | Low | Fixed-point was specified at training time via hls4ml. Bit-exact unless rounding differs. |
