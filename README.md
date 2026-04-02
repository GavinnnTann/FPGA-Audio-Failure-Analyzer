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

#### 2. Time-Frequency Representation
- Short-Time Fourier Transform (STFT)
- Generates a 64 x 64 spectrogram
  - Time axis: sliding window frames
  - Frequency axis: band-limited FFT bins

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
- CNN output + RMS packaged into UART frames
- Transmitted every 50 ms to ESP32

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

## Key Contribution

- End-to-end pipeline:
  - Signal acquisition -> STFT -> CNN -> decision -> UI
- Fully hardware-accelerated inference on FPGA
- Practical alternative to vision-based monitoring

---
