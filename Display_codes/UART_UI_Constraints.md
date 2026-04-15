# ESP32 Display UI Constraints for FPGA UART Integration

## Purpose
This document reflects the current ESP32 UI and UART2 integration behavior as implemented in code.

## System Context
- FPGA receives 24-bit microphone ADC data.
- FPGA processing paths:
  - RMS accumulator
  - Raw amplitude path for display
  - FFT spectrogram path into CNN (binary normal/abnormal output)
- FPGA sends relevant display data to ESP32 over UART.
- ESP32 renders UI on a 480x320 display using LVGL.

## Current UI Elements (from Screen2)
Source file: screens/ui_Screen2.c

Notes:
- Screen1 is now preload/splash only.
- Screen2 is the active monitoring screen after boot.

### 1) Arc: ui_Arc1
- Object type: LVGL Arc
- Size: 250 x 250
- Position: center-aligned, offset x = -112, y = 0 (left zone)
- Initial value: 50
- Explicit range in code: not set
- Effective LVGL default range: 0 to 100
- Touch interaction: disabled (`LV_OBJ_FLAG_CLICKABLE` and `LV_OBJ_FLAG_CLICK_FOCUSABLE` removed)

Design intent:
- Arc runs continuously based on uptime.
- Arc remains neutral (gray baseline) and abnormal events are rendered as red dot markers on ring positions.
- Ring position for dot markers uses uptime modulo 360 seconds.
- Dot persistence is 3 rotations with fading opacity.
- Dot severity follows amplitude-derived severity index:
  - Low/Medium: small red dot
  - High: larger, brighter red dot

Integration note:
- Runtime code sets arc range to 0..359 and updates value from uptime seconds modulo 360.

### 2) Bar: ui_Bar1
- Object type: LVGL Bar
- Range: 0 to 255 (explicitly configured)
- Initial value: 10
- Size: 18 x 214
- Position: inside right telemetry panel
- Touch interaction: disabled (`LV_OBJ_FLAG_CLICKABLE` and `LV_OBJ_FLAG_CLICK_FOCUSABLE` removed)

Design intent:
- Bar visualizes sound amplitude from FPGA raw input path.

Integration note:
- 8-bit unsigned amplitude is directly compatible.

### 3) Labels
- Label1: ui_Label1
  - Initial text: "Normal"
  - Position: inside right telemetry panel (status line)
  - Intended runtime meaning: CNN binary output (normal/abnormal)
- Label2: ui_Label2
  - Initial text: "uptime"
  - Position: inside right telemetry panel
  - Intended runtime meaning: local ESP32 recording uptime
- Label3: ui_Label3
  - Initial text: "Active"
  - Position: inside right telemetry panel
  - Intended runtime meaning: FPGA activity state (awake/sleep)

Runtime overlay labels (created in firmware at runtime):
- Severity line:
  - Severity index (0..100) from amplitude
  - Severity band (Low/Med/High)
  - RMS current value
  - RMS min/max over the last 10 seconds
- Health line:
  - Last anomaly age (seconds)
  - Rolling anomaly count over the last 60 seconds
  - Compact comms counters (drop/fail/reorder)

## Data Ownership (who computes what)

### FPGA -> ESP32
Current transmitted fields (implemented):

**Frame 1: RMS Telemetry (8 bytes, sync AA 55)**
- result: 8 bits
  - 0 = Normal
  - non-zero = Abnormal
- rms: 8 bits
  - 0..255 for bar update
- flags: 8 bits
  - bit0 = fpga_active (0 = Sleep/Idle, 1 = Active/Awake)
  - bit1..bit7 currently reserved
- seq: 8 bits
  - rolling frame sequence counter (modulo 256)
- metric: 8 bits
  - reserved auxiliary/confidence byte (currently not used for severity)

**Frame 2: Spectrogram Slice (6 bytes each, sync DD 77) — Burst Mode**
- bin_index: 8 bits (0–63)
- bin_magnitude_low: 8 bits (LSB of 16-bit magnitude)
- bin_magnitude_high: 8 bits (MSB of 16-bit magnitude)
- checksum: DD XOR 77 XOR bin_index XOR bin_low XOR bin_high
- Cadence: All 64 bins burst-transmitted after each RMS frame (~3.84 ms burst, ~18 Hz refresh)
- Frequency range: 0–23.4 kHz, ~366 Hz/bin (46875/512 × 4)
- ESP32 parser must detect both sync patterns (AA for RMS, DD for spectrogram)

### Local ESP32
- Uptime timer and formatting for Label2
- Continuous arc progression over time (one full revolution every 6 minutes)
- Arc dot plotting and persistence/fade logic for anomaly events
- Vibration pulse on abnormal edge (120 ms on rising transition)
- Amplitude-derived severity index (0..100) and severity band
- 10-second RMS min/max window computation
- 60-second rolling anomaly count

## UART Transmission Schema (Implemented)

Frame size: 8 bytes fixed

Byte layout:
- Byte0: 0xAA (sync A)
- Byte1: 0x55 (sync B)
- Byte2: result
- Byte3: rms
- Byte4: flags
- Byte5: seq (rolling sequence counter from FPGA, 0..255)
- Byte6: metric (reserved confidence/aux byte from FPGA)
- Byte7: checksum

Checksum rule:
- `checksum = 0xAA XOR 0x55 XOR result XOR rms XOR flags XOR seq XOR metric`

Parser behavior on ESP32:
- Bytes are consumed by a UART2 state machine waiting for 0xAA then 0x55.
- A frame is accepted only if checksum matches.
- The Raw Data 2 monitor shows periodic runtime stats (valid/checksum_fail/sync_reset/seq_drop/seq_reorder/last_seq).
- On valid frame:
  - Label1 updates from `result` (Normal/Abnormal)
  - Bar updates from `rms`
  - Label3 updates from `flags.bit0` (Active/Sleep)
  - `metric` byte is accepted for forward compatibility (current severity is amplitude-derived on ESP32)
  - Sequence continuity is checked (`seq` expected to increment by +1 modulo 256)
  - Rollover is explicit: after `seq=255`, the next in-order value is `seq=0`
  - Example in-order sequence across wrap: `... 253, 254, 255, 0, 1 ...`
  - Example drop across wrap: `255 -> 2` implies dropped `0` and `1` (drop count +2)
  - Forward jumps increment `seq_drop` (dropped frame estimate)
  - Backward/old arrivals increment `seq_reorder`
  - Arc stays neutral; anomaly events place dot markers on the ring
  - Telemetry timestamp is refreshed
- On invalid checksum:
  - Frame is discarded
  - `checksum_fail` counter increments
  - Parser resynchronizes from next potential sync byte

No-data timeout behavior (implemented):
- If no valid telemetry frame arrives for ~400 ms:
  - Label3 is forced to `Sleep`
  - Label1 is forced to `No Data`
  - Arc and bar are grayed out
  - Bar target decays toward zero

Severity behavior (implemented):
- No model confidence is required.
- Severity index is computed locally from amplitude (`rms`) and scaled to 0..100.
- Higher amplitude maps to higher severity.

## Runtime Behavior Expectations
- Label1 updates whenever cnn_state changes.
- Bar updates with each amplitude sample/frame.
- Label3 reflects FPGA awake/sleep state.
- Label2 increments locally on ESP32 (not sent from FPGA).
- Arc motion is continuous from local time.
- Arc stays neutral and anomaly moments are marked with red dots on uptime ring positions.
- Arc and Bar are display-only in UI (not user-adjustable via touch).

Implemented runtime details:
- UART2 is configured on GPIO32 (RX) and GPIO33 (TX).
- UART2 baud is 1000000 with SERIAL_8N1.
- RX buffer size is configured to 1024 bytes.
- Main loop parses UART before UI handling.
- Screen1 is used as preload/splash, then Screen2 is loaded after a 2-second delay.

## Value and Range Constraints
- Arc value: local uptime-driven, runtime range 0..359
- Bar value: 0..255
- Label1 text states: "Normal" / "Abnormal"
- Label3 text states: "Active" / "Sleep" (or chosen equivalent)
- UART result field: 0 = Normal, non-zero = Abnormal
- UART flags.bit0: 0 = Sleep, 1 = Active

## Current Implementation Status
- Widget definitions and static layout are present in Screen2.
- Arc/Bar touch interaction is explicitly disabled in UI code.
- Screen flow is implemented: preload screen (Screen1) then monitoring screen (Screen2).
- UART parsing and live UI update logic are implemented in `src/main.cpp` using a fixed 8-byte frame.
- UART2 monitor (Raw Data 2 tab) displays periodic frame statistics.
- Only checksum-valid frames update telemetry widgets.
- UART0 monitor tab exists in UI but is not actively fed in the current loop.

## Suggested Next Step
Optional protocol hardening and observability improvements:
- Add payload length/version for forward compatibility.
- Replace XOR checksum with CRC-8/CRC-16 for stronger error detection.
