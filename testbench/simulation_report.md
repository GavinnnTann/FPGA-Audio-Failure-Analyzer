# FPGA Acoustic Anomaly Detector — Simulation Report

**Generated:** 2026-04-27 15:10 UTC  
**Simulator:** Icarus Verilog (iverilog + vvp)  
**Verilog standard:** 2001  

## Summary

| Module | Testbench | Status | Checks |
|--------|-----------|--------|--------|
| UART 8N1 Transmitter | `uart_tx_tb.v` | ✅ PASS | 12 passed |
| I2S Receiver (INMP441) | `i2s_receiver_tb.v` | ❌ FAIL | 1 passed, 5 failed |
| FFT Feature Quantizer (log2 companding) | `fft_feature_quantizer_tb.v` | ✅ PASS | 15 passed |
| FFT Magnitude (Alphamax+Betamax + bin downsampling) | `fft_magnitude_tb.v` | ❌ FAIL | 13 passed, 7 failed |
| 64×64 Spectrogram Buffer (BRAM staging) | `spectrogram_buffer_64x64_tb.v` | ✅ PASS | 9 passed |
| FFT Window Buffer (backpressure regression) | `fft_backpressure_tb.v` | ❌ FAIL | 0 passed, 1 failed |

**Total:** 3 passed, 3 failed

---

## Testbench Details

### `uart_tx_tb.v` — UART 8N1 Transmitter

**Status:** ✅ PASS

**Tests covered:**

- Idle TX line is high
- 0x55 serial frame (alternating bits)
- 0xAA serial frame (complement pattern)
- 0x00 serial frame (all-zero data)
- 0xFF serial frame (all-one data)
- Back-to-back 3 bytes — 3 done pulses
- start ignored while busy

<details>
<summary>Simulation output (click to expand)</summary>

```
VCD info: dumpfile uart_tx_tb.vcd opened for output.
PASS  idle TX=1

--- TEST 1: 0x55 ---
PASS  byte=0x55 frame=0b1010101010
PASS  byte=0x55 busy deasserted after done

--- TEST 2: 0xAA ---
PASS  byte=0xaa frame=0b1101010100
PASS  byte=0xaa busy deasserted after done

--- TEST 3: 0x00 ---
PASS  byte=0x00 frame=0b1000000000
PASS  byte=0x00 busy deasserted after done

--- TEST 4: 0xFF ---
PASS  byte=0xff frame=0b1111111110
PASS  byte=0xff busy deasserted after done

--- TEST 5: Back-to-back bytes ---
PASS  3 done pulses received for 3 back-to-back bytes

--- TEST 6: start ignored while busy ---
PASS  only one done after overlapping start (busy gating confirmed)

========== uart_tx_tb COMPLETE ==========
Tests run: 11
Errors:    0
RESULT: PASS
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\uart_tx_tb.v:221: $finish called at 83599000 (1ps)
```

</details>

### `i2s_receiver_tb.v` — I2S Receiver (INMP441)

**Status:** ❌ FAIL

**Tests covered:**

- Capture known sample 0xABCDEF
- Capture zero sample 0x000000
- Capture max positive 0x7FFFFF
- 10 consecutive frames — valid pulse count
- Right-channel bits are discarded

**Issues:**

```
FAIL  TEST 1: sample_data=0x000000 expected=0xABCDEF
FAIL  TEST 3: sample_data=0x000000 expected=0x7FFFFF
FAIL  TEST 4: got 12 valid pulses, expected 10
FAIL  TEST 5: sample_data=0x000000 expected=0x000001 (right channel leaked?)
```

<details>
<summary>Simulation output (click to expand)</summary>

```
VCD info: dumpfile i2s_receiver_tb.vcd opened for output.

--- TEST 1: Capture 0xABCDEF ---
FAIL  TEST 1: sample_data=0x000000 expected=0xABCDEF

--- TEST 2: Capture 0x000000 ---
PASS  TEST 2: sample_data=0x000000

--- TEST 3: Capture 0x7FFFFF ---
FAIL  TEST 3: sample_data=0x000000 expected=0x7FFFFF

--- TEST 4: 10 consecutive frames, count valid pulses ---
FAIL  TEST 4: got 12 valid pulses, expected 10

--- TEST 5: Right-channel ignored ---
FAIL  TEST 5: sample_data=0x000000 expected=0x000001 (right channel leaked?)

========== i2s_receiver_tb COMPLETE ==========
Tests run: 5  Errors: 4
RESULT: FAIL
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\i2s_receiver_tb.v:224: $finish called at 609957000 (1ps)
```

</details>

### `fft_feature_quantizer_tb.v` — FFT Feature Quantizer (log2 companding)

**Status:** ✅ PASS

**Tests covered:**

- Zero input → 0x00 special case
- Powers of two: 0x0001, 0x0002, 0x0004, 0x0080, 0x8000
- Non-power-of-two values (non-zero mantissa)
- Maximum 0xFFFF → 0xFF
- Monotonicity sweep (sampled every 256 steps)
- No spurious feature_valid when input idle

<details>
<summary>Simulation output (click to expand)</summary>

```
VCD info: dumpfile fft_feature_quantizer_tb.vcd opened for output.

--- TEST 1: Zero special case ---
PASS              zero mag=0x0000 u2192 feature=0x00

--- TEST 2: Powers of two ---
PASS       pow2_0x0001 mag=0x0001 u2192 feature=0x00
PASS       pow2_0x0002 mag=0x0002 u2192 feature=0x10
PASS       pow2_0x0004 mag=0x0004 u2192 feature=0x20
PASS       pow2_0x0080 mag=0x0080 u2192 feature=0x70
PASS       pow2_0x0100 mag=0x0100 u2192 feature=0x80
PASS       pow2_0x8000 mag=0x8000 u2192 feature=0xf0

--- TEST 3: Non-zero mantissa ---
PASS            0x0003 mag=0x0003 u2192 feature=0x18
PASS            0xC000 mag=0xc000 u2192 feature=0xf8
PASS            0x0F00 mag=0x0f00 u2192 feature=0xbe
PASS            0x5A5A mag=0x5a5a u2192 feature=0xe6

--- TEST 4: Maximum 0xFFFF ---
PASS        max_0xFFFF mag=0xffff u2192 feature=0xff

--- TEST 5: Monotonicity sweep ---
PASS  TEST 5: monotonicity holds across sweep

--- TEST 6: No spurious feature_valid ---
PASS  TEST 6: no spurious feature_valid

========== fft_feature_quantizer_tb COMPLETE ==========
Tests run: 14  Errors: 0
RESULT: PASS
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\fft_feature_quantizer_tb.v:213: $finish called at 5465000 (1ps)
```

</details>

### `fft_magnitude_tb.v` — FFT Magnitude (Alphamax+Betamax + bin downsampling)

**Status:** ❌ FAIL

**Tests covered:**

- Pure-real input → magnitude ≈ 0.96 × |real|
- Pure-imaginary input → same approximation
- Equal I/Q (45°) → Alphamax+Betamax formula
- Odd-indexed bins suppressed (downsampling)
- Every-4th bin passes (bins 0,4,8,…,252)
- Bins ≥ 256 suppressed (mirror half)
- spec_bin_index = fft_bin_index >> 2 for all 64 bins
- Large magnitude saturates to 0xFFFF
- Negative real/imaginary (abs-value) correct

**Issues:**

```
FAIL bin=0: spec_bin=0 expected=0
FAIL bin=4: spec_bin=1 expected=1
FAIL bin=8: spec_bin=2 expected=2
FAIL bin=12: spec_bin=3 expected=3
FAIL  TEST 6: 64 bin-index mapping errors
FAIL        saturation bin=0: mag=63 expected=65535
```

<details>
<summary>Simulation output (click to expand)</summary>

```
VCD info: dumpfile fft_magnitude_tb.vcd opened for output.

--- TEST 1: Pure-real input, bin 0 ---
PASS    pure_real_bin0 bin=0 â†’ mag=245 spec_bin=0

--- TEST 2: Pure-imag input, bin 4 ---
PASS    pure_imag_bin4 bin=4 â†’ mag=245 spec_bin=1

--- TEST 3: Equal I/Q (45-degree angle), bin 8 ---
PASS     equal_iq_bin8 bin=8 â†’ mag=347 spec_bin=2

--- TEST 4: Downsampling â€” odd-indexed bins suppressed ---
PASS    bin_1_suppress bin=1 â†’ suppressed (no valid)
PASS    bin_2_suppress bin=2 â†’ suppressed (no valid)
PASS    bin_3_suppress bin=3 â†’ suppressed (no valid)
PASS    bin_5_suppress bin=5 â†’ suppressed (no valid)

--- TEST 4b: Downsampled bins pass ---
PASS            bin_12 bin=12 â†’ mag=245 spec_bin=3
PASS           bin_252 bin=252 â†’ mag=245 spec_bin=63

--- TEST 5: Bins 256+ suppressed ---
PASS           bin_256 bin=256 â†’ suppressed (no valid)
PASS           bin_260 bin=260 â†’ suppressed (no valid)
PASS           bin_511 bin=511 â†’ suppressed (no valid)

--- TEST 6: spec_bin_index = fft_bin_index >> 2 ---
  FAIL bin=0: spec_bin=0 expected=0
  FAIL bin=4: spec_bin=1 expected=1
  FAIL bin=8: spec_bin=2 expected=2
  FAIL bin=12: spec_bin=3 expected=3
FAIL  TEST 6: 64 bin-index mapping errors

--- TEST 7: Large magnitude saturates to 0xFFFF ---
FAIL        saturation bin=0: mag=63 expected=65535

--- TEST 8: Negative real input (sign extension) ---
PASS          neg_real bin=0 â†’ mag=245 spec_bin=0

========== fft_magnitude_tb COMPLETE ==========
Tests run: 15  Errors: 2
RESULT: FAIL
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\fft_magnitude_tb.v:224: $finish called at 1620000 (1ps)
```

</details>

### `spectrogram_buffer_64x64_tb.v` — 64×64 Spectrogram Buffer (BRAM staging)

**Status:** ✅ PASS

**Tests covered:**

- Full frame (64 lines) → exactly 1 frame_complete pulse
- frame_id increments on each frame boundary
- Partial write (32 lines) → no frame_complete
- 5 back-to-back frames → 5 pulses
- line_index==63 is the sole frame trigger
- frame_id wraps through 0xFF → 0x00

<details>
<summary>Simulation output (click to expand)</summary>

```
VCD info: dumpfile spectrogram_buffer_64x64_tb.vcd opened for output.

--- TEST 1: Full frame write (lines 0..63) ---
PASS  TEST 1: frame_complete fired once
PASS  TEST 1: frame_id incremented to 1

--- TEST 2: Second frame ---
PASS  TEST 2: frame_id=2 after 2nd frame

--- TEST 3: Partial write (32 lines, no frame_complete) ---
PASS  TEST 3: no frame_complete after 32-line partial write

--- TEST 4: 5 back-to-back frames ---
PASS  TEST 4: 5 frame_complete pulses for 5 frames

--- TEST 5: Line index 63 is the frame trigger ---
PASS  TEST 5a: no frame_complete on line 62
PASS  TEST 5b: frame_complete fires on line 63

--- TEST 6: frame_id overflow (write 256 frames) ---
PASS  TEST 6: frame_id after 256 frames = 8 (wrap-around tested)

========== spectrogram_buffer_64x64_tb COMPLETE ==========
Tests run: 8  Errors: 0
Total frame_complete pulses: 264
RESULT: PASS
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\spectrogram_buffer_64x64_tb.v:229: $finish called at 506225000 (1ps)
```

</details>

### `fft_backpressure_tb.v` — FFT Window Buffer (backpressure regression)

**Status:** ❌ FAIL

**Tests covered:**

- Fill ring buffer with 512 samples (Phase 1)
- Forced backpressure stalls during streaming (Phase 2)
- Frame continuity: FFT_N samples per frame
- Extended run: 2048 samples, periodic stalls (Phase 3)

<details>
<summary>Simulation output (click to expand)</summary>

```
ERROR: C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\src_main\fft_window_buffer.v:84: $readmemh: Unable to open hann_512_q15.mem for reading.
VCD info: dumpfile fft_backpressure_tb.vcd opened for output.

--- Phase 1: Fill ring buffer (512 samples) ---
  Filled 512 samples. Streaming=0
  After first frame: stream_count=0, frame_count=0

--- Phase 2: Backpressure test (HOP_N samples + stalls) ---

--- Phase 3: Extended run (2048 samples, periodic stalls) ---

========== BACKPRESSURE TEST COMPLETE ==========
Total samples fed:    2752
Total streamed out:   9199
Frames completed:     0
Stall cycles injected: 133
Errors detected:      0
RESULT: FAIL
C:\Users\gavin\OneDrive\Desktop\SUTD\Term 6\Digital System Lab\DSL Project\testbench\fft_backpressure_tb.v:189: $finish called at 1498648385 (1ps)
```

</details>

---

## Running Simulations

### Option 1: Vivado xsim (recommended — no extra install)

```powershell
.\scripts\build.ps1 -Action simulate
```

### Option 2: Icarus Verilog

Install from https://steveicarus.github.io/iverilog/ then:

```powershell
# From repo root
# UART 8N1 Transmitter
iverilog -g2001 -o testbench/uart_tx_tb.vvp testbench/uart_tx_tb.v src_main/uart_tx.v
vvp testbench/uart_tx_tb.vvp

# I2S Receiver (INMP441)
iverilog -g2001 -o testbench/i2s_receiver_tb.vvp testbench/i2s_receiver_tb.v src_main/i2s_receiver.v
vvp testbench/i2s_receiver_tb.vvp

# FFT Feature Quantizer (log2 companding)
iverilog -g2001 -o testbench/fft_feature_quantizer_tb.vvp testbench/fft_feature_quantizer_tb.v src_main/fft_feature_quantizer.v
vvp testbench/fft_feature_quantizer_tb.vvp

# FFT Magnitude (Alphamax+Betamax + bin downsampling)
iverilog -g2001 -o testbench/fft_magnitude_tb.vvp testbench/fft_magnitude_tb.v src_main/fft_magnitude.v
vvp testbench/fft_magnitude_tb.vvp

# 64×64 Spectrogram Buffer (BRAM staging)
iverilog -g2001 -o testbench/spectrogram_buffer_64x64_tb.vvp testbench/spectrogram_buffer_64x64_tb.v src_main/spectrogram_buffer_64x64.v
vvp testbench/spectrogram_buffer_64x64_tb.vvp

# FFT Window Buffer (backpressure regression)
iverilog -g2001 -o testbench/fft_backpressure_tb.vvp testbench/fft_backpressure_tb.v src_main/fft_window_buffer.v
vvp testbench/fft_backpressure_tb.vvp

```

### Option 3: Re-run this script (auto-detects iverilog or xsim)

```powershell
python tools/run_simulations.py
```