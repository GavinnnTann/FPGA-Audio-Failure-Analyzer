# CMOD A7 Audio Telemetry Project (Current Implementation)

This README is the onboarding entry point for the active FPGA-to-ESP32 pipeline in this folder.

For full build/program/flash and maintenance details, see:
- [CMOD_A7_PROJECT_REFERENCE.md](CMOD_A7_PROJECT_REFERENCE.md)

## What Is Implemented Now

Current top-level behavior:
- Captures INMP441 microphone samples through I2S.
- Decimates audio stream by 6 for lightweight processing.
- Computes windowed mean-absolute amplitude.
- Sends framed UART telemetry to ESP32 display.

Current top module and source set:
- Top module: `recorder_top`
- Verilog files:
  - `src_main/recorder_top.v`
  - `src_main/i2s_receiver.v`
  - `src_main/uart_tx.v`

## UART Protocol (Implemented)

UART settings:
- Baud: 1,000,000
- Format: 8N1

Frame format (8 bytes):
1. 0xAA
2. 0x55
3. result
4. rms
5. flags
6. seq
7. metric (placeholder for CNN confidence)
8. checksum

Checksum definition:
- `checksum = 0xAA ^ 0x55 ^ result ^ rms ^ flags ^ seq ^ metric`

Notes:
- `flags[0] = 1` indicates FPGA active.
- `metric` is currently a placeholder byte from FPGA (set to 0 until CNN confidence is wired).
- Frame cadence depends on `WINDOW_SAMPLES` in `recorder_top.v`.

## Pin Mapping (Implemented)

INMP441 on PMOD JA:
- `i2s_sck -> G17`
- `i2s_ws -> G19`
- `i2s_sd -> N18`

Board inputs/indicators:
- `btn0 -> A18`
- `btn1 -> B18`
- `led -> A17`
- `led_amp -> C16`

UART to ESP32:
- `uart_tx -> N3` (CMOD A7 edge header Pin 18)

## Day 1 Onboarding Checklist

1. Install tools.
- Vivado ML Edition (with Artix-7 support).
- USB-JTAG drivers for Digilent/Xilinx cable.

2. Wire hardware.
- INMP441 to PMOD JA exactly per pin map above.
- FPGA `uart_tx` (N3 / edge Pin 18) to ESP32 RX.
- Common ground between CMOD A7 and ESP32.

3. Build bitstream.
- Run: `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action build`

4. Program board (volatile test).
- Run: `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action program`

5. Validate UART quickly.
- Confirm ESP32 parser is configured for 1,000,000 baud and 8-byte frame.
- Expected sync sequence: `AA 55`.

6. Flash for power-cycle persistence (optional).
- Run: `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action flash`

## Quick Troubleshooting

- No UART data on ESP32:
  - Verify physical wire is on N3 edge Pin 18, not older pin notes.
  - Verify shared ground between boards.
  - Verify ESP32 UART baud is 1,000,000.

- Sync bytes not detected:
  - Confirm parser expects 8-byte frames, not legacy 5/6/7-byte frames.
  - Check checksum logic includes `flags`, `seq`, and `metric` bytes.

- Works until power cycle:
  - Use `-Action flash` (non-volatile), not only `-Action program`.

## Roadmap (Not Yet Implemented in Current Build)

The following items are design goals and not part of the current active recorder_top pipeline:
- FFT feature extraction
- Spectrogram BRAM buffering
- CNN inference in FPGA fabric

If you implement any roadmap item, update both this README and [CMOD_A7_PROJECT_REFERENCE.md](CMOD_A7_PROJECT_REFERENCE.md) in the same change.
