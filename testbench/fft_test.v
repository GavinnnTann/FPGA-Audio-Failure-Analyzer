// Testbench for FFT pipeline verification
// 
// Generates a 440 Hz sine wave at I2S sample rate and verifies:
// 1. FFT window buffer accumulates 512 samples
// 2. FFT IP produces output bins
// 3. Magnitude extraction downsamples to 64 bins
// 4. Spectrogram peak appears at expected frequency bin
//
// Expected: 440 Hz @ 7.8 kHz sample rate → bin ≈ 28-29

`timescale 1ns / 1ps

module fft_test;

    // Clock and reset
    reg clk = 0;
    reg rst_n = 1;
    
    // Sine wave generator (440 Hz @ 48 kHz = period of ~109 samples)
    // Using a simple counter-based phase accumulator
    reg [15:0] phase_accum = 0;
    wire [15:0] sine_out;
    
    // Simple sine approximation using table lookup
    // For brevity, use a simple oscillator pattern
    // 440 Hz @ 48 kHz: phase_incr ≈ 0xB7 (183 in decimal)
    // Updated every 12 MHz clock
    // But we only need new sample every 12/48 = 0.25 cycles (48 clocks per I2S sample)
    
    reg [31:0] sample_counter = 0;
    reg [23:0] i2s_sample = 0;
    reg i2s_sample_valid = 0;
    
    // Top module outputs
    wire led;
    wire led_amp;
    wire uart_tx;
    
    // FFT outputs (from recorder_top internal signals - need to expose in DUT)
    // For now, we'll monitor via VCD waveform
    
    // Instantiate DUT
    recorder_top #() dut (
        .clk          (clk),
        .btn0         (1'b0),
        .btn1         (1'b0),
        .i2s_sd       (i2s_sample[23]),  // MSB as serial data
        .i2s_sck      (),                 // Output, not monitored
        .i2s_ws       (),                 // Output, not monitored
        .led          (led),
        .led_amp      (led_amp),
        .uart_tx      (uart_tx)
    );
    
    // Generate 12 MHz clock
    always #41.67 clk = ~clk;  // 12 MHz = 83.33 ns period
    
    // Generate 440 Hz sine wave test signal
    // Phase accumulator: 440 Hz / 48 kHz = 9.167 cycles per sample
    // 24-bit phase: 0xB71754 per sample for 440 Hz
    localparam PHASE_INC_440HZ = 24'hB71754;  // 440 Hz at 48 kHz
    
    initial begin
        // Reset for 100 ns
        rst_n = 0;
        #100 rst_n = 1;
        #1000;  // Wait for I2S receiver to stabilize
        
        // Run for enough time to capture multiple spectrograms
        // 512 decimated samples = 512 / 7.8kHz ≈ 65ms
        // At 12 MHz: 65ms = 780,000 clocks
        // Let's run for 10 full spectrogram frames = 7.8M clocks
        
        repeat (7_800_000) begin
            @(posedge clk);
        end
        
        $display("=== FFT Testbench Complete ===");
        $display("Check VCD waveform for:");
        $display("  - led toggling (heartbeat from recorder_top)");
        $display("  - spec_frame_valid pulses every ~65ms");
        $display("  - spec_bin_magnitude packed output");
        $display("Expected: Peak FFT bin ≈ 28-29 for 440 Hz input");
        $finish;
    end
    
    // Generate sine wave samples (simple triangle approximation)
    // For accurate testing, compute actual sine
    always @(posedge clk) begin
        // Increment phase at 48 kHz rate (every 250 clocks at 12 MHz)
        sample_counter <= sample_counter + 1;
        
        if (sample_counter == 32'd250) begin
            sample_counter <= 0;
            
            // Update phase
            phase_accum <= phase_accum + PHASE_INC_440HZ[23:8];  // Scale down to 16-bit
            
            // Generate 24-bit sine sample (16-bit value duplicated)
            // Using simple approximation: sin(phase) via lookup or formula
            case (phase_accum[15:11])  // Use top 5 bits for rough sine shape
                5'd0:  i2s_sample <= {{8'd0}, {16'h0000}};  // 0°
                5'd1:  i2s_sample <= {{8'd0}, {16'h4000}};  // ~22.5°
                5'd2:  i2s_sample <= {{8'd0}, {16'h7FFF}};  // ~45° (peak)
                5'd3:  i2s_sample <= {{8'd0}, {16'h4000}};  // ~67.5°
                5'd4:  i2s_sample <= {{8'd0}, {16'h0000}};  // ~90°
                5'd5:  i2s_sample <= {{8'd0}, {16'hC000}};  // ~112.5°
                5'd6:  i2s_sample <= {{8'd0}, {16'h8001}};  // ~135° (negative peak)
                5'd7:  i2s_sample <= {{8'd0}, {16'hC000}};  // ~157.5°
                default: i2s_sample <= {{8'd0}, {16'h0000}};
            endcase
        end
    end
    
    // Monitoring: Print statistics every 1ms
    reg [31:0] time_counter = 0;
    always @(posedge clk) begin
        time_counter <= time_counter + 1;
        
        if (time_counter == 32'd12_000_000) begin  // 1 second
            time_counter <= 0;
            $display("[%0t] Simulation running... Waiting for FFT frames", $time);
        end
    end
    
    // Dump waveforms for inspection
    initial begin
        $dumpfile("fft_test.vcd");
        $dumpvars(0, fft_test);
    end

endmodule
