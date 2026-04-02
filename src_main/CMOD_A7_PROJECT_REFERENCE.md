# CMOD A7 Recorder Project Reference

## Scope
This document is the single reference for the CMOD A7 real-time audio telemetry project based on recorder_top.

Target board: Digilent CMOD A7 (xc7a35tcpg236-1)
Primary function: capture microphone audio, compute a compact amplitude/result payload, and stream to ESP32 display over UART.

## Build Target Summary
- Top module: recorder_top
- Source root used by build: src_main/
- Constraint file used by build: constraints/recorder.xdc
- Build scripts: scripts/build.ps1 and scripts/build.tcl

## Verilog Files Related to recorder_top
All recorder_top-related Verilog files are located in src_main.

1. recorder_top.v
- Role: project top-level integration.
- Main functions:
  - Consumes microphone samples from i2s_receiver.
  - Decimates samples by 6.
  - Computes mean-absolute amplitude over a fixed window.
  - Produces RESULT, RMS, FLAGS fields.
  - Frames UART packet: AA 55 result rms flags seq metric checksum.
  - Drives status LEDs.

2. i2s_receiver.v
- Role: INMP441 interface block.
- Main functions:
  - Generates/uses I2S timing.
  - Captures 24-bit sample stream.
  - Asserts sample_valid for recorder_top processing.

3. uart_tx.v
- Role: UART byte transmitter.
- Main functions:
  - 8N1 serialization.
  - Parameterized baud generation.
  - Handshake signals used by recorder_top frame FSM.

## Constraints Used
Active constraints are defined in constraints/recorder.xdc.

1. Clock
- clk -> L17, LVCMOS33
- create_clock period 83.33 ns (12 MHz)

2. On-board indicators
- led -> A17, LVCMOS33
- led_amp -> C16, LVCMOS33

3. Buttons
- btn0 -> A18, LVCMOS33
- btn1 -> B18, LVCMOS33

4. I2S microphone (INMP441 on PMOD JA)
- i2s_sck -> G17, LVCMOS33
- i2s_ws -> G19, LVCMOS33
- i2s_sd -> N18, LVCMOS33

5. UART to ESP32
- uart_tx -> N3, LVCMOS33
- Wiring note: this corresponds to CMOD A7 edge header Pin 18.

6. Configuration voltage
- CFGBVS = VCCO
- CONFIG_VOLTAGE = 3.3

## Communication Protocol (FPGA -> ESP32)
Fixed 8-byte frame format:
1. 0xAA
2. 0x55
3. result
4. rms
5. flags
6. seq
7. metric (placeholder for CNN confidence)
8. checksum = AA XOR 55 XOR result XOR rms XOR flags XOR seq XOR metric

Typical UART settings:
- 1,000,000 baud
- 8 data bits, no parity, 1 stop bit

## Display Code Reference
Display integration is implemented in Display_codes/.

Primary files:
1. Display_codes/src/main.cpp
- UART2 RX parser state machine.
- Checksum validation.
- UI updates for bar/labels/arc.

2. Display_codes/screens/ui_Screen2.c
- Screen2 widget creation.
- Helper append functions for monitor text areas.

3. Display_codes/UART_UI_Constraints.md
- UI behavior and protocol notes for the ESP32 side.

## Build and Programming Flows
From workspace root:

- Build bitstream:
  powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action build

- Program volatile FPGA SRAM (clears on power cycle):
  powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action program

- Flash non-volatile configuration memory (boots after power cycle):
  powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action flash

- Build and flash in one step:
  powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action allflash

## From-Scratch Onboarding (Day 1)
1. Install Vivado ML Edition and confirm Artix-7 device support is present.
2. Connect CMOD A7 over USB-JTAG.
3. Wire INMP441 to PMOD JA using the exact mapping in this document.
4. Wire UART:
  - CMOD `uart_tx` on package pin N3 (edge Pin 18) -> ESP32 RX.
  - Connect board grounds together.
5. Build and program:
  - Build: `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action build`
  - Program: `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action program`
6. Verify serial protocol on ESP32 side:
  - UART 1,000,000 baud, 8N1.
  - Frame length 8 bytes.
  - Sync bytes `AA 55`.
  - Checksum includes flags, seq, and metric bytes.
7. If persistence after power cycle is required, run:
  - `powershell -ExecutionPolicy Bypass -File scripts/build.ps1 -Action flash`

## Known Legacy Mismatch To Avoid
- Some older notes describe a 5-byte packet and different UART pin labels.
- For active builds, trust this reference and `src_main/README.md`: protocol is 8 bytes and `uart_tx` is N3.

## Notes for Maintenance
- Keep SOURCE_FILES in scripts/config.tcl aligned with src_main/.
- Keep constraints/recorder.xdc synchronized with physical wiring.
- If UART framing changes, update both recorder_top.v and Display_codes/src/main.cpp together.
