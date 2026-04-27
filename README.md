# FPGA-Based Acoustic Monitoring for 3D Printer Anomaly Detection

## Project Context

This project is part of the Singapore University of Technology and Design (SUTD) Term 6 Digital Signals Lab 2026. The course is conducted and supervised by Prof. Teo Tee Hui.

Modern 3D printers are typically monitored using vision-based systems (cameras + CV models), manual inspection, or post-failure diagnostics. These approaches share several limitations:

- Continuous video streaming is computationally expensive
- Image-based models require high data bandwidth and storage
- Visual anomalies are often detected **after** defects have already formed

### Core Insight

> Mechanical faults in 3D printers manifest acoustically before they become visually observable.

Examples:
- Layer shifting → irregular stepper motor patterns
- Nozzle clogging → high-frequency jitter
- Belt misalignment → periodic tonal distortion

### Project Objective

> Develop a low-cost, real-time acoustic monitoring system that detects anomalies using sound instead of vision — with all signal processing and inference running on a single low-cost FPGA.

### One-Line Thesis

> This project demonstrates that acoustic sensing, combined with FPGA-based real-time inference, can replace computationally expensive vision systems for continuous 3D printer monitoring.

---

## Why Acoustic Monitoring Over Vision

| | Vision System | Acoustic System |
|---|---|---|
| **Compute** | Thousands of pixels per frame; heavy CNN pipelines | 1D signal → compact 64-bin spectrogram |
| **Bandwidth** | Continuous high-bandwidth video stream | Compressed features only (RMS + classification) |
| **Fault timing** | Detects after visual defect forms | Detects micro-vibrations and transient anomalies early |
| **Cost** | Camera + GPU/MCU | MEMS mic + low-cost FPGA |
| **Robustness** | Affected by lighting, occlusion | Independent of visual conditions |

## Why FPGA

- Real-time STFT computation with deterministic timing
- Parallel CNN inference without OS scheduling delays
- Continuous streaming without dropped samples
- Tight integration between DSP and inference pipeline — no data copies, no bus arbitration

> Reliable, low-latency anomaly detection suitable for continuous monitoring.

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
             │
             └─ ESP32 Wi-Fi uploader (HTTP POST)
              │
              └─ Supabase `telemetry` table
                    │
                    └─ Next.js web dashboard (realtime)
```

### Hardware
- **FPGA:** Digilent CMOD A7-35T (xc7a35tcpg236-1)
- **Microphone:** INMP441 I2S MEMS (on PMOD JA)
- **Display:** ESP32 + TFT with LVGL UI
- **Clock domains:** 12 MHz system, 100 MHz CNN (via MMCM)

### System Block Diagram

![High-level Architecture](Pictures%20and%20Docs/High-level%20Architecture%20Simplified.png)

### Key Result

End-to-end pipeline — audio capture → FFT → spectrogram → CNN inference → anomaly classification — running fully on-FPGA with **~20 sweeps/second** throughput and **1.8 ms** CNN inference latency.

---

## FPGA Processing Pipeline

### 1. Audio Acquisition
Digital audio captured via I2S from INMP441 at 46.875 kHz, 24-bit.

### 2. Time-Frequency Representation (FFT)
- **FFT core:** Xilinx FFT v9.1 IP (512-point, pipelined streaming I/O)
- **Window:** Hann (512 coefficients, Q1.15 fixed-point, DSP48-pipelined multiply)
- **Hop:** 64 samples overlap → ~20 frames/second
- **Dual-path:**
  - RMS path: ÷6 decimation → amplitude metering
  - FFT path: Full-rate for maximum bandwidth
- **Output:** 64-bin spectrogram (first 256 of 512 bins, every 4th → 64 bins)
  - Frequency range: 0–23.4 kHz
  - Bin spacing: ~366 Hz
  - Magnitude: Alphamax+Betamax approximation
  - 8-bit feature quantization: log₂ companding `{lz[3:0], norm[14:11]}` (monotonic 0–255)

### 3. CNN Inference (On FPGA)
- **Architecture:** 15-layer convolutional autoencoder (hls4ml generated)
- **Input:** 64×64×1 spectrogram (8-bit unsigned, streamed via AXI-Stream)
- **Output:** Reconstructed 64×64×1 → MAE compared against input
- **Clock:** 100 MHz (dedicated domain via MMCM)
- **Latency:** ~178,600 cycles = 1.786 ms per inference
- **Anomaly threshold:** MAE >= 26/255 → ABNORMAL
- **Double-buffered** via ping-pong BRAM so FFT writes don't stall CNN reads

### 4. Communication
- Dual UART outputs: N3 (ESP32) + J18 (USB bridge for PC debug)
- 1 Mbaud 8N1
- RMS frame (8 bytes): `AA 55 result rms flags seq metric checksum`
  - `flags`: bit0=FPGA active, bit1=CNN anomaly, bit2=CNN has run
  - `metric`: MAE score (0–255) when CNN active
- Spectrogram burst (64 × 6 bytes): `DD 77 bin_idx bin_lo bin_hi checksum`
- Full protocol: [Documentations/UART_SPECTROGRAM_PROTOCOL.md](Documentations/UART_SPECTROGRAM_PROTOCOL.md)

### 5. Display Interface (ESP32)
- Receives UART packets
- Updates LVGL-based UI: system state (NORMAL/ABNORMAL), RMS bar, spectral indicators

| Main Status Screen | Spectrogram View |
|---|---|
| ![ESP32 Telemetry Display](Pictures%20and%20Docs/ESP32%20Telemetry.jpg) | ![ESP32 Spectrogram Display](Pictures%20and%20Docs/ESP32%20Spectrogram.jpg) |

### 6. Cloud Telemetry Upload (ESP32 Wi-Fi)
- ESP32 runs a non-blocking uploader task pinned to **Core 0** (radio core) so TLS/HTTP cannot stall UI/UART on Core 1
- Telemetry snapshots are queued and uploaded to Supabase via HTTPS REST endpoint:
  - Endpoint: `/rest/v1/telemetry`
  - Method: `POST` with `apikey` and `Authorization: Bearer <anon key>`
  - Upload cadence: configurable via `UPLOAD_INTERVAL_MS` (default 2000 ms)
- Payload fields uploaded: `device_ms`, `rms`, `result`, `seq`, `metric`, `anomaly`, `cnn_ran`, `fpga_active`

### 7. Web Dashboard (Next.js + Supabase Realtime)
- Web app subscribes to inserts on Supabase `telemetry` table using `@supabase/supabase-js`
- Displays:
  - Live status (LIVE / NO DATA)
  - RMS timeline with anomaly markers
  - Anomaly rate and packet counters
  - Raw telemetry feed (`rms`, `result`, `seq`, `metric`, `flags`, `cnn_ran`, `fpga_active`)
- Dashboard app path: `Display_codes/Audio Failure Analyzer Dashboard/`

**Desktop Dashboard**

![Web App Desktop](Pictures%20and%20Docs/Web%20App%20Desktop.png)

**Mobile View**

| Overview | Telemetry Feed |
|---|---|
| ![Web App Mobile 1](Pictures%20and%20Docs/Web%20App%201.jpg) | ![Web App Mobile 2](Pictures%20and%20Docs/Web%20App%202.jpg) |

---

## FPGA Resource Utilization (Post-Implementation)

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
│   ├── src/wifi_uploader.cpp   ESP32 Core0 Wi-Fi + Supabase uploader task
│   ├── src/example_wifi_config.h  Wi-Fi/Supabase config template
│   └── Audio Failure Analyzer Dashboard/  Next.js realtime web dashboard
├── Documentations/        Detailed technical documentation
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

### Enable Wi-Fi + Supabase Upload (ESP32)
1. Copy `Display_codes/src/example_wifi_config.h` to `Display_codes/src/wifi_config.h`.
2. Fill in:
  - `WIFI_SSID`, `WIFI_PASS`
  - `SUPABASE_HOST`, `SUPABASE_KEY`, `SUPABASE_TABLE`
3. In Supabase SQL editor, create the `telemetry` table and RLS policy as documented in `example_wifi_config.h`.
4. Build and flash ESP32 firmware from `Display_codes/` (PlatformIO).

### Run Web Dashboard
```powershell
cd "Display_codes/Audio Failure Analyzer Dashboard"
npm install
copy .env.local.example .env.local
```
Edit `.env.local`:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`

Then start the app:
```powershell
npm run dev
```
Open `http://localhost:3000` to view live telemetry.

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
| [Display_codes/src/example_wifi_config.h](Display_codes/src/example_wifi_config.h) | Wi-Fi + Supabase setup template (table schema, RLS, credentials) |
| [Display_codes/Audio Failure Analyzer Dashboard](Display_codes/Audio Failure Analyzer Dashboard) | Next.js + Supabase realtime monitoring dashboard |
| [testbench/README.md](testbench/README.md) | Simulation and testbench guide |
| [Pictures and Docs/Audio Failure Analyzer Schematic.pdf](Pictures%20and%20Docs/Audio%20Failure%20Analyzer%20Schematic.pdf) | Full hardware schematic (FPGA, ESP32, mic, display wiring) |

*Note, autoencoder development and testing was done in a separate repository: https://github.com/ericraze16/fpga-audio-autoencoder/tree/main*
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
- ESP32 Wi-Fi telemetry upload to Supabase (non-blocking background task)
- Next.js web dashboard for realtime telemetry and anomaly monitoring
- Python real-time viewer with blit rendering, diagnostics, and comparison tools
- Backpressure regression testbench

### Acknowledged Limitations
- Requires training data for acoustic signatures
- Sensitive to environmental noise
- Model generalization across printer types not yet validated
- Power signoff workflow not yet run

### Contributors
- Gavin Tan from Singapore University of Technology and Design, Electrical Engineering (Product Development)
- Eric Aleong from University of Waterloo, Mechatronics Engineering

---
