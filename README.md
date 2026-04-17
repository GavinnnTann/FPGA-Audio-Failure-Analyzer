# FPGA-Based Acoustic Monitoring for 3D Printer Anomaly Detection

## Project Overview

A real-time acoustic anomaly detection system that uses sound instead of vision to monitor 3D printers. An INMP441 I2S microphone feeds a CMOD A7 FPGA, which performs STFT spectrogram generation and CNN autoencoder inference entirely in hardware. Results are streamed over UART to an ESP32 LVGL display and a Python desktop viewer.

**Key result:** End-to-end pipeline — audio capture → FFT → spectrogram → CNN inference → anomaly classification — running fully on-FPGA with ~20 sweeps/second throughput and 1.8 ms CNN inference latency.

---

## System Architecture

```
INMP441 (I2S Mic, 46.875 kHz)
  │
  ├─ RMS path: ÷6 decimation → ~7.8 kHz → amplitude metering
  └─ FFT path: Full-rate 46.875 kHz
       │
       Hann Window (512 samples, hop=64)
       │
       512-point FFT (Xilinx FFT v9.1 IP)
       │
       Magnitude (Alphamax+Betamax) → 64 bins (0–23.4 kHz)
       │
       8-bit log₂ companding → 64×64 spectrogram buffer (BRAM)
       │
       CNN Autoencoder (hls4ml, 100 MHz, 15-layer)
       │
       MAE Scorer → NORMAL / ABNORMAL classification
       │
       Dual UART (1 Mbaud) → ESP32 display + PC viewer
```

### Hardware
- **FPGA:** Digilent CMOD A7-35T (xc7a35tcpg236-1)
- **Microphone:** INMP441 I2S MEMS (on PMOD JA)
- **Display:** ESP32 + TFT with LVGL UI
- **Clock domains:** 12 MHz system, 100 MHz CNN (via MMCM)

### FPGA Resource Utilization (Post-Implementation)
| Resource | Used | Available | Util% |
|----------|------|-----------|-------|
| LUTs | 14,036 | 20,800 | 67.5% |
| Registers | ~17,200 | 41,600 | ~41% |
| Block RAM | 36.5 | 50 | 73% |
| DSP48 | 2 | 90 | 2.2% |

All timing met (WNS = 1.101 ns on 100 MHz CNN clock).

---

## Project Structure

```
├── src_main/              Verilog source files
│   ├── recorder_top.v         Top-level integration
│   ├── i2s_receiver.v         INMP441 I2S interface
│   ├── uart_tx.v              UART 8N1 transmitter
│   ├── fft_frontend.v         FFT pipeline orchestration
│   ├── fft_window_buffer.v    Hann window + hop scheduler
│   ├── fft_magnitude.v        Complex→magnitude + bin downsampling
│   ├── fft_feature_quantizer.v  16→8-bit log₂ companding
│   ├── spectrogram_buffer_64x64.v  64×64 BRAM staging
│   ├── spectrogram_pingpong.v  Double-buffered CNN input (BRAM)
│   ├── cnn_wrapper.v          CNN FSM controller
│   ├── cnn_axi_feeder.v       Pixel streamer to CNN AXI-S
│   ├── cnn_anomaly_scorer.v   MAE computation + threshold
│   ├── clk_gen.v              100 MHz clock generation (MMCM)
│   └── hann_512_q15.mem       Window coefficients
├── ip/                    Xilinx IP cores (FFT v9.1, CNN HLS)
├── constraints/           XDC pin constraint files
│   └── recorder.xdc          Active constraint file
├── scripts/               Build automation
│   ├── build.ps1              PowerShell build driver
│   ├── build.tcl              Vivado TCL synthesis/implementation
│   ├── config.tcl             Source file list & settings
│   ├── program.tcl            JTAG programming
│   └── flash.tcl              SPI flash programming
├── tools/                 PC-side utilities
│   └── spectrogram_viewer.py  Real-time Python viewer (tkinter + matplotlib)
├── testbench/             Simulation testbenches
├── Display_codes/         ESP32 LVGL display firmware (PlatformIO)
├── Documentations/        Detailed technical documentation
│   ├── CNN_INTEGRATION_PLAN.md
│   ├── DESIGN_REVIEW_REPORT_FPGA_STFT.md
│   ├── UART_SPECTROGRAM_PROTOCOL.md
│   ├── INSTRUCTIONS.md            (DSL Starter Kit hardware reference)
│   ├── BUILD_SUMMARY.md
│   ├── Project_template_readme.md
│   └── TEMPLATE_GUIDE.md
├── build_reports/         Vivado synthesis/implementation logs
├── CMOD_A7_PROJECT_REFERENCE.md   Comprehensive technical reference
└── README.md              This file
```

---

## Quick Start

### Prerequisites
- Xilinx Vivado ML Edition (with Artix-7 support)
- Digilent CMOD A7-35T + USB cable
- INMP441 microphone wired to PMOD JA (see [CMOD_A7_PROJECT_REFERENCE.md](CMOD_A7_PROJECT_REFERENCE.md))
- Python 3.10+ with `pyserial`, `numpy`, `matplotlib` (for PC viewer)

### Build & Program
```powershell
# Build bitstream
powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action build

# Program FPGA (volatile — clears on power cycle)
powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action program

# Build + Flash (non-volatile — persists after power cycle)
powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action allflash
```

### Run the PC Viewer
```powershell
python tools/spectrogram_viewer.py
```
Select the COM port, connect at 1 Mbaud, and observe real-time spectrogram, CNN anomaly status, and comparison tools.

---

## UART Protocol

Two frame types at 1 Mbaud 8N1:

**RMS Frame (8 bytes):** `AA 55 result rms flags seq metric checksum`
- `flags`: bit0=FPGA active, bit1=CNN anomaly, bit2=CNN has run
- `metric`: MAE score (0–255) when CNN active, debug byte otherwise
- Threshold: MAE ≥ 30 → ABNORMAL

**Spectrogram Burst (64 × 6 bytes):** `DD 77 bin_idx bin_lo bin_hi checksum`
- All 64 bins burst-transmitted after each RMS frame (~3.8 ms)
- 16-bit linear magnitude per bin, little-endian

Full protocol details: [Documentations/UART_SPECTROGRAM_PROTOCOL.md](Documentations/UART_SPECTROGRAM_PROTOCOL.md)

---

## CNN Autoencoder

- **Architecture:** 15-layer convolutional autoencoder (hls4ml generated)
- **Input:** 64×64×1 spectrogram (8-bit unsigned, streamed via AXI-Stream)
- **Output:** Reconstructed 64×64×1 → MAE compared against input
- **Clock:** 100 MHz (dedicated domain via MMCM)
- **Latency:** ~178,600 cycles = 1.786 ms per inference
- **Anomaly threshold:** MAE ≥ 30/255

Integration details: [Documentations/CNN_INTEGRATION_PLAN.md](Documentations/CNN_INTEGRATION_PLAN.md)

---

## Documentation Index

| Document | Description |
|----------|-------------|
| [CMOD_A7_PROJECT_REFERENCE.md](CMOD_A7_PROJECT_REFERENCE.md) | Comprehensive technical reference (modules, pins, protocol, build) |
| [Documentations/UART_SPECTROGRAM_PROTOCOL.md](Documentations/UART_SPECTROGRAM_PROTOCOL.md) | Full UART protocol specification |
| [Documentations/CNN_INTEGRATION_PLAN.md](Documentations/CNN_INTEGRATION_PLAN.md) | CNN architecture, ports, resource budget, integration plan |
| [Documentations/DESIGN_REVIEW_REPORT_FPGA_STFT.md](Documentations/DESIGN_REVIEW_REPORT_FPGA_STFT.md) | Design review findings and resolutions |
| [Documentations/BUILD_SUMMARY.md](Documentations/BUILD_SUMMARY.md) | Build reports (resource utilization, timing) |
| [Documentations/INSTRUCTIONS.md](Documentations/INSTRUCTIONS.md) | DSL Starter Kit hardware configuration & pin reference |
| [Display_codes/UART_UI_Constraints.md](Display_codes/UART_UI_Constraints.md) | ESP32 display UI constraints |
| [testbench/README.md](testbench/README.md) | Simulation and testbench guide |

---

## Status

### Completed
- Audio capture via I2S (46.875 kHz, 24-bit)
- FFT pipeline (512-point, Hann window, hop=64, DSP-pipelined)
- 64-bin spectrogram output (0–23.4 kHz, 8-bit log₂ features)
- 64×64 spectrogram staging buffer (BRAM)
- CNN autoencoder inference on-FPGA (100 MHz, MAE scoring)
- Dual UART output (ESP32 + USB debug) at 1 Mbaud
- ESP32 LVGL display with spectrogram and status UI
- Python real-time viewer with blit rendering, diagnostics, and comparison tools
- Backpressure regression testbench

### Acknowledged Limitations
- Requires training data for acoustic signatures
- Sensitive to environmental noise
- Model generalization across printer types not yet validated
- Power signoff workflow not yet run

---

## License

See [LICENSE](LICENSE).
# FPGA-Based Acoustic Monitoring for 3D Printer Anomaly Detection

---

## Project Context

Modern 3D printers are typically monitored using:

- Vision-based systems (cameras + CV models)
- Manual inspection
- Post-failure diagnostics

However, these approaches introduce several limitations:

- Continuous video streaming is computationally expensive
- Image-based models require high data bandwidth and storage
- Visual anomalies are often detected after defects have already formed

---

## Core Insight

> Mechanical faults in 3D printers manifest acoustically before they become visually observable.

Examples:
- Layer shifting -> irregular stepper motor patterns
- Nozzle clogging -> high-frequency jitter
- Belt misalignment -> periodic tonal distortion

---

## Project Objective

> Develop a low-cost, real-time acoustic monitoring system that detects anomalies using sound instead of vision.

---

## System Architecture

### Signal Flow

INMP441 (I2S Microphone)
-> CMOD A7 FPGA
-> ESP32 (Display Interface)

---

### FPGA Processing Pipeline

The FPGA performs fully parallel, deterministic signal processing:

#### 1. Audio Acquisition
- Digital audio captured via I2S from INMP441

#### 2. Time-Frequency Representation (FFT Pipeline)
- **FFT Implementation**: Xilinx FFT v9.1 IP core (512-point, real input)
- **Window Function**: Hann window (512 coefficients, hop=64 overlap)
- **Dual-path decimation**:
  - RMS path: ÷6 decimation (46.875 kHz → ~7.8 kHz) for amplitude metering
  - FFT path: Full-rate 46.875 kHz (no decimation) for maximum bandwidth
- **Output**: 64-bin spectrogram (first 256 of 512 bins, every 4th → 64 bins)
  - Frequency range: 0 to ~23.4 kHz (46875 / 2)
  - Bin spacing: ~366 Hz per bin (46875 / 512 × 4)
  - Magnitude extraction: Alphamax+Betamax approximation
  - 8-bit feature quantization: log2 companding via leading-one detector, output `{lz[3:0], norm[14:11]}` (monotonic 0–255)

#### 3. Feature Extraction
- Spectrogram treated as a 2D feature map

#### 4. CNN Inference (On FPGA)
- Lightweight convolutional neural network
- Input: 64 x 64 spectrogram
- Output: Binary classification
  - NORMAL
  - ABNORMAL

#### 5. Parallel Signal Metric
- RMS amplitude computed alongside STFT
- Represents real-time acoustic energy

#### 6. Communication
- Dual UART outputs: N3 (ESP32) + J18 (USB bridge for PC debug)
- 1 Mbaud 8N1
- RMS telemetry (8 bytes) + spectrogram burst (64 × 6 bytes) per cycle
- RMS transmitted every ~54 ms; all 64 spec bins burst-transmitted immediately after (~3.84 ms burst)
- Full spectrogram refresh rate: ~18 Hz

---

### ESP32 Responsibilities

- Receives UART packets
- Updates LVGL-based UI
- Displays:
  - System state (NORMAL / ABNORMAL)
  - RMS activity (amplitude bar)
  - Optional spectral indicators

---

## Why Acoustic Monitoring Instead of Vision

### Computational Efficiency

Vision systems:
- Process thousands of pixels per frame
- Require high-throughput pipelines (for example, CNNs on images)

Acoustic system:
- Operates on 1D signals transformed into compact spectrograms
- Significantly lower data rate and compute requirement

---

### Bandwidth Efficiency

Video streaming:
- Continuous high-bandwidth transmission
- Storage-intensive

Acoustic monitoring:
- Transmits compressed features only (RMS + classification)
- Minimal bandwidth (bytes per frame)

---

### Early Fault Detection

Sound captures:
- Micro-vibrations
- Mechanical inconsistencies
- Transient anomalies

These often occur before visual defects are observable.

---

## Why FPGA

The FPGA enables:

- Real-time STFT computation with deterministic timing
- Parallel CNN inference without OS scheduling delays
- Continuous streaming without dropped samples
- Tight integration between DSP and inference pipeline

This ensures:

> Reliable, low-latency anomaly detection suitable for continuous monitoring.

---

## System Advantages

- Low-cost compared to camera-based systems
- Real-time response
- Low power consumption
- Scalable to multiple machines
- Robust to lighting and visual occlusion

---

## Limitations (Acknowledged)

- Requires training data for acoustic signatures
- Sensitive to environmental noise
- Model generalization across printer types must be validated

---

## One-Line Thesis

> This project demonstrates that acoustic sensing, combined with FPGA-based real-time inference, can replace computationally expensive vision systems for continuous 3D printer monitoring.

---

## FFT Implementation Details

### Hardware Pipeline
The FPGA FFT pipeline converts time-domain audio samples into frequency-domain spectrograms:

```
I2S Input (46.875 kHz)
  ↓
  ├─ RMS path: Decimator (÷6) → ~7.8 kHz → RMS amplitude
  └─ FFT path: Full-rate 46.875 kHz (sign-extended 16→24 bit)
  ↓
Hann Window Buffer (512 samples, hop=64 overlap scheduler)
  ↓
FFT Core (512-point, pipelined)
  ↓
Magnitude Extraction (I/Q → real magnitude, Alphamax+Betamax)
  ↓
Bin Downsampling (first 256 bins, every 4th → 64 bins, 0–23.4 kHz)
  ↓
Feature Quantization (16-bit → 8-bit log2 companding: {lz[3:0], norm[14:11]} = 256 monotonic values)
  ↓
Spectrogram Staging Buffer (64×64×8 BRAM, delayed bin index + feature-count-derived frame pulse)
  ↓
Dual UART Output (1 Mbaud, N3 + J18):
  • RMS frame: AA 55 result rms flags seq metric chk (8 bytes)
  • Spec burst: 64 × [DD 77 bin_idx bin_lo bin_hi chk] (384 bytes)
```

### Spectrogram Format
**16-bit magnitude signal**: `spec_bin_magnitude[1023:0]`
- 64 frequency bins packed into 1024-bit vector
- Each bin is 16 bits (unsigned linear magnitude)
- Extraction: `bin_k = spec_bin_magnitude[(k+1)*16-1 : k*16]` for bin 0–63
- Valid pulse: `spec_frame_valid` (fires after all 64 feature8 bins are committed)

**8-bit feature signal**: `spec_bin_feature8[511:0]`
- 64 frequency bins packed into 512-bit vector
- Each bin is 8 bits (log2 companded for CNN input)
- Staged in 64x64x8 BRAM buffer for CNN frame accumulation

### Frequency-to-Bin Mapping
- Bin spacing: 46875 / 512 × 4 ≈ 366 Hz/bin
- Formula: `bin_index = round(freq_Hz / 366.2)`
- Examples:
  - 440 Hz → bin ~1
  - 1 kHz → bin ~3
  - 10 kHz → bin ~27
  - 15 kHz → bin ~41

### Spectrogram Usage Modes

**Mode 1: Real-time Display (Streaming to ESP32)**
- Extract all 64 bins at each `spec_frame_valid` pulse
- Send to ESP32 for real-time spectral visualization
- Display as frequency bar chart or waterfall

**Mode 2: CNN Input (On FPGA)**
- Stack spectrograms over time: (64 bins × 64 frames) → 64×64 feature map
- Feed directly into CNN inference layer
- Output: anomaly classification (NORMAL / ABNORMAL)

**Mode 3: Post-Processing (UART)**
- Stream full spectrogram metadata to ESP32
- Compute statistics (peak bin, bandwidth, entropy) on either device
- Log for offline analysis

---


- End-to-end pipeline:
  - Signal acquisition -> STFT -> CNN -> decision -> UI
- Fully hardware-accelerated inference on FPGA
- Practical alternative to vision-based monitoring

---
