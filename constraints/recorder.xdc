## Audio Recorder - Pin Constraints
## Target: CmodA7 rev. B (xc7a35tcpg236-1)
## Subsystem: I2S INMP441 on Pmod JA, btn0, LED

## 12 MHz Clock Signal
set_property -dict { PACKAGE_PIN L17   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 83.33 -waveform {0 41.66} [get_ports {clk}];

## Status LED (CMOD A7 onboard LED 1)
set_property -dict { PACKAGE_PIN A17   IOSTANDARD LVCMOS33 } [get_ports { led }];

## Amplitude LED (CMOD A7 onboard LED 2) – PWM brightness shows audio level during playback
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { led_amp }];

## Button 0 – Record / Play (active-high, directly on CMOD A7)
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { btn0 }];

## Button 1 – Clear / Stop (active-high, directly on CMOD A7)
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { btn1 }];

## I2S Interface — INMP441 on Pmod Header JA (Row 1)
## Wiring: JA[1]=SCK, JA[2]=WS, JA[3]=SD, JA pin 5=GND, JA pin 6=VCC 3.3V
## INMP441 L/R pin tied to GND → left channel active
set_property -dict { PACKAGE_PIN P3   IOSTANDARD LVCMOS33 } [get_ports { i2s_sck }];
set_property -dict { PACKAGE_PIN N1   IOSTANDARD LVCMOS33 } [get_ports { i2s_ws  }];
set_property -dict { PACKAGE_PIN M2   IOSTANDARD LVCMOS33 } [get_ports { i2s_sd  }];

## UART TX to ESP32 RX on edge header Pin 18 (pio18 / PACKAGE_PIN N3)
set_property -dict { PACKAGE_PIN N3    IOSTANDARD LVCMOS33 } [get_ports { uart_tx }];

## UART TX mirror to PC via onboard USB-UART bridge (FTDI FT2232HQ Channel B)
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { uart_tx_usb }];

## Clock domain crossing constraints
## The 100 MHz CNN clock is generated from sys_clk_pin via MMCM — treat as asynchronous
set_clock_groups -asynchronous -group [get_clocks sys_clk_pin] -group [get_clocks -of_objects [get_pins clk_gen_inst/mmcm_inst/CLKOUT0]]

## Configuration
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
