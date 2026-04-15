# Testbench and Simulation Guide

## Overview
This directory contains testbenches for simulating and verifying the FPGA acoustic monitoring pipeline before deployment.

## Available Testbenches

### fft_test_simple.v
Simplified pipeline validation testbench that generates a 440 Hz test signal and monitors sample/frame counting:
- Generates a phase-accumulator approximation of sine at 440 Hz
- Decimates by 6 (matching the recorder_top decimation chain)
- Counts samples and frames (512 samples per frame)
- Outputs VCD waveform for inspection

### fft_test.v
Extended FFT testbench (for use with Vivado simulation and FFT IP).

### fft_backpressure_tb.v
Backpressure and no-drop regression testbench for `fft_window_buffer`:
- **Phase 1**: Fills ring buffer with 512 samples (no stalls), verifies first stream completes
- **Phase 2**: Feeds HOP_N × 3 samples with random `fft_ready` deassertion (every 7th sample, 3-cycle stalls)
- **Phase 3**: Extended run of 2048 samples with periodic backpressure stalls every 32 samples
- **Validates**: Frame continuity (each frame = FFT_N samples), reports errors
- **Output**: VCD waveform `fft_backpressure_tb.vcd`, console PASS/FAIL
- **Key signals**: `fft_ready`, `fft_valid`, `fft_last`, `streaming`, `frame_count`, `errors`

## Running Simulations

### Option 1: PowerShell Script (Automated)
```powershell
# Run simplified simulation (no Vivado IP dependency)
.\scripts\run_sim.ps1 -SimTime 100
```

### Option 2: Vivado Behavioral Simulation
```powershell
.\scripts\build.ps1 -Action simulate
```

## Simulation Output

### Console Output
The testbench prints sample and frame progress:
```
[time] Frame N: M samples processed
========== SIMULATION COMPLETE ==========
Samples generated: ...
Spectrogram frames: ...
```

### Waveform Files
- **Location**: `fft_sim/fft_test_simple.vcd`
- **Format**: VCD (open in Surfer, GTKWave, or similar)

## Key Signals to Monitor

| Signal | Description |
|--------|-------------|
| `phase_accum` | 440 Hz tone phase accumulator |
| `sample_ena` | Decimated sample strobe (~7.8 kHz) |
| `sample_count` | Running sample counter |
| `frame_count` | Spectrogram frame counter (increments every 512 samples) |
| `sine_sample` | Generated test audio sample |

## Verification Checklist
- [ ] `sample_ena` pulses regularly (~every 128 ns at 12 MHz / 6)
- [ ] `sample_count` increments at each pulse
- [ ] `frame_count` increments after 512 samples
- [ ] No timing violations in synthesis report

## Troubleshooting

### Simulation Hangs
- Check timeout watchdog (10s limit in testbench)
- Verify state machine transitions
- Ensure button press timing is correct

### No Waveform Output
- Check Vivado simulation settings
- Ensure `$dumpfile` and `$dumpvars` are present
- Run from Vivado GUI for interactive debugging

### Unexpected Results
- Compare testbench stimulus timing with actual hardware timing
- Check for race conditions in clock edges
- Verify LFSR initial seed produces expected randomness

## Best Practices

1. **Run simulations before building** - Catch bugs early
2. **Check timing constraints** - Verify critical paths
3. **Test edge cases** - Button glitches, max timer values
4. **Compare with hardware** - Validate simulation accuracy
5. **Document failures** - Track issues for debugging

## Creating New Testbenches

Template structure:
```verilog
`timescale 1ns / 1ps

module my_module_tb;
    // Declare signals
    reg clk;
    reg reset;
    wire [7:0] output_bus;
    
    // Instantiate UUT
    my_module uut (
        .clk(clk),
        .reset(reset),
        .output_bus(output_bus)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #41.667 clk = ~clk;  // 12MHz
    end
    
    // Test stimulus
    initial begin
        $dumpfile("my_module.vcd");
        $dumpvars(0, my_module_tb);
        
        reset = 1;
        #1000;
        reset = 0;
        
        // Your tests here
        
        #1000000;
        $finish;
    end
endmodule
```
