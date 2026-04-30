// Self-checking testbench for fft_magnitude
//
// Tests the Alphamax+Betamax magnitude approximation and bin downsampling.
// Formula: approx_mag = ((max[33:8] * 62914) + (min[33:8] * 26084)) >> 16
// Downsampling: only bins 0,4,8,...,252 (fft_bin_index[1:0]==0, index<256) are valid.
//
// Verifies:
//   TEST 1  Pure-real input: mag ≈ 0.96 × real_abs
//   TEST 2  Pure-imag input: mag ≈ 0.96 × imag_abs
//   TEST 3  Equal I/Q: mag ≈ (0.96+0.398) × |I|   (Alphamax+Betamax)
//   TEST 4  Bin downsampling: only every-4th bin from 0..255 passes through
//   TEST 5  Bins 256+ are suppressed
//   TEST 6  spec_bin_index = fft_bin_index >> 2

`timescale 1ns/1ps

module fft_magnitude_tb;

    localparam CLK_PERIOD = 10;

    reg        clk   = 0;
    reg        rst_n = 0;

    reg [79:0] fft_tdata    = 0;
    reg        fft_tvalid   = 0;
    reg [9:0]  fft_bin_index = 0;

    wire [15:0] magnitude;
    wire        magnitude_valid;
    wire [5:0]  spec_bin_index;

    fft_magnitude dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .fft_tdata     (fft_tdata),
        .fft_tvalid    (fft_tvalid),
        .fft_bin_index (fft_bin_index),
        .magnitude     (magnitude),
        .magnitude_valid(magnitude_valid),
        .spec_bin_index(spec_bin_index)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer errors = 0;
    integer tests  = 0;

    // ----------------------------------------------------------------
    // Helper: pack real and imag (34-bit signed) into fft_tdata[79:0]
    //   real at [33:0], imag at [73:40]
    // ----------------------------------------------------------------
    function [79:0] pack_iq;
        input signed [33:0] r;
        input signed [33:0] q;
        begin
            pack_iq = 80'd0;
            pack_iq[33:0]  = r;
            pack_iq[73:40] = q;
        end
    endfunction

    // ----------------------------------------------------------------
    // Reference: compute expected magnitude using same integer arithmetic
    // ----------------------------------------------------------------
    function [15:0] ref_mag;
        input [33:0] abs_r;
        input [33:0] abs_q;
        reg [33:0] mx, mn;
        reg [25:0] approx;
        begin
            mx = (abs_r > abs_q) ? abs_r : abs_q;
            mn = (abs_r > abs_q) ? abs_q : abs_r;
            approx = ((mx[33:8] * 26'd62914) + (mn[33:8] * 26'd26084)) >> 16;
            if (approx > 26'd65535)
                ref_mag = 16'hFFFF;
            else
                ref_mag = approx[15:0];
        end
    endfunction

    // ----------------------------------------------------------------
    // Task: drive one sample, wait one cycle, check result
    // ----------------------------------------------------------------
    task drive_check;
        input [33:0] real_in;
        input [33:0] imag_in;
        input [9:0]  bin;
        input        expect_valid;
        input [15:0] expect_mag;
        input [5:0]  expect_bin_idx;
        input [127:0] label;
        begin
            @(negedge clk);
            fft_tdata     = pack_iq(real_in, imag_in);
            fft_bin_index = bin;
            fft_tvalid    = 1'b1;
            @(posedge clk); #1;
            // Check before deasserting — DUT registered fft_tvalid=1 this cycle

            tests = tests + 1;
            if (magnitude_valid !== expect_valid) begin
                $display("FAIL  %s bin=%0d: magnitude_valid=%b expected=%b",
                         label, bin, magnitude_valid, expect_valid);
                errors = errors + 1;
            end else if (expect_valid && magnitude !== expect_mag) begin
                $display("FAIL  %s bin=%0d: mag=%0d expected=%0d",
                         label, bin, magnitude, expect_mag);
                errors = errors + 1;
            end else if (expect_valid && spec_bin_index !== expect_bin_idx) begin
                $display("FAIL  %s bin=%0d: spec_bin=%0d expected=%0d",
                         label, bin, spec_bin_index, expect_bin_idx);
                errors = errors + 1;
            end else begin
                if (expect_valid)
                    $display("PASS  %s bin=%0d → mag=%0d spec_bin=%0d",
                             label, bin, magnitude, spec_bin_index);
                else
                    $display("PASS  %s bin=%0d → suppressed (no valid)", label, bin);
            end
            @(negedge clk);
            fft_tvalid = 1'b0;
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    integer i;

    initial begin
        $dumpfile("waveforms/fft_magnitude_tb.vcd");
        $dumpvars(0, fft_magnitude_tb);

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // ---- TEST 1: Pure-real, bin 0 (downsampled) ----
        // real = 0x10000 = 65536, imag = 0
        // ref_mag: mx=65536, mx[33:8]=256, approx=(256*62914+0)>>16 = 16105984>>16 = 245
        $display("\n--- TEST 1: Pure-real input, bin 0 ---");
        drive_check(34'sh0010000, 34'sh0, 10'd0, 1'b1,
                    ref_mag(34'h0010000, 34'h0), 6'd0,
                    "pure_real_bin0");

        // ---- TEST 2: Pure-imaginary, bin 4 ----
        $display("\n--- TEST 2: Pure-imag input, bin 4 ---");
        drive_check(34'sh0, 34'sh0010000, 10'd4, 1'b1,
                    ref_mag(34'h0, 34'h0010000), 6'd1,
                    "pure_imag_bin4");

        // ---- TEST 3: Equal I/Q magnitude ---
        // Alphamax+Betamax: both = 0x10000 → mx=mn → (62914+26084)*256>>16=(88998*256)>>16
        $display("\n--- TEST 3: Equal I/Q (45-degree angle), bin 8 ---");
        drive_check(34'sh0010000, 34'sh0010000, 10'd8, 1'b1,
                    ref_mag(34'h0010000, 34'h0010000), 6'd2,
                    "equal_iq_bin8");

        // ---- TEST 4a: Non-downsampled bins should be suppressed ----
        $display("\n--- TEST 4: Downsampling — odd-indexed bins suppressed ---");
        drive_check(34'sh0010000, 34'sh0, 10'd1, 1'b0, 16'd0, 6'd0, "bin_1_suppress");
        drive_check(34'sh0010000, 34'sh0, 10'd2, 1'b0, 16'd0, 6'd0, "bin_2_suppress");
        drive_check(34'sh0010000, 34'sh0, 10'd3, 1'b0, 16'd0, 6'd0, "bin_3_suppress");
        drive_check(34'sh0010000, 34'sh0, 10'd5, 1'b0, 16'd0, 6'd0, "bin_5_suppress");

        // ---- TEST 4b: Every-4th bin passes ----
        $display("\n--- TEST 4b: Downsampled bins pass ---");
        drive_check(34'sh0010000, 34'sh0, 10'd12, 1'b1,
                    ref_mag(34'h0010000, 34'h0), 6'd3, "bin_12");
        drive_check(34'sh0010000, 34'sh0, 10'd252, 1'b1,
                    ref_mag(34'h0010000, 34'h0), 6'd63, "bin_252");

        // ---- TEST 5: Bins >= 256 suppressed ----
        $display("\n--- TEST 5: Bins 256+ suppressed ---");
        drive_check(34'sh0010000, 34'sh0, 10'd256, 1'b0, 16'd0, 6'd0, "bin_256");
        drive_check(34'sh0010000, 34'sh0, 10'd260, 1'b0, 16'd0, 6'd0, "bin_260");
        drive_check(34'sh0010000, 34'sh0, 10'd511, 1'b0, 16'd0, 6'd0, "bin_511");

        // ---- TEST 6: spec_bin_index mapping ----
        $display("\n--- TEST 6: spec_bin_index = fft_bin_index >> 2 ---");
        begin : t6
            integer b;
            integer t6_errors;
            t6_errors = 0;
            for (b = 0; b < 256; b = b + 4) begin
                @(negedge clk);
                fft_tdata     = pack_iq(34'sh0001000, 34'sh0);
                fft_bin_index = b[9:0];
                fft_tvalid    = 1'b1;
                @(negedge clk);
                fft_tvalid = 1'b0;
                @(posedge clk); #1;
                if (!magnitude_valid || spec_bin_index !== b[7:2]) begin
                    t6_errors = t6_errors + 1;
                    if (t6_errors < 5)
                        $display("  FAIL bin=%0d: spec_bin=%0d expected=%0d",
                                 b, spec_bin_index, b/4);
                end
            end
            tests = tests + 1;
            if (t6_errors > 0) begin
                $display("FAIL  TEST 6: %0d bin-index mapping errors", t6_errors);
                errors = errors + 1;
            end else
                $display("PASS  TEST 6: all 64 bin indices mapped correctly");
        end

        // ---- TEST 7: Saturation to 0xFFFF ----
        $display("\n--- TEST 7: Large magnitude saturates to 0xFFFF ---");
        drive_check(34'h1FFFFFF0, 34'h0, 10'd0, 1'b1, 16'hFFFF, 6'd0, "saturation");

        // ---- TEST 8: Negative real/imag (abs value) ----
        $display("\n--- TEST 8: Negative real input (sign extension) ---");
        // -65536 in 34-bit signed = 34'sh3FFFF0000 (two's complement)
        drive_check(-34'sh0010000, 34'sh0, 10'd0, 1'b1,
                    ref_mag(34'h0010000, 34'h0), 6'd0, "neg_real");

        // ----------------------------------------------------------------
        $display("\n========== fft_magnitude_tb COMPLETE ==========");
        $display("Tests run: %0d  Errors: %0d", tests, errors);
        if (errors == 0) $display("RESULT: PASS");
        else             $display("RESULT: FAIL");
        $finish;
    end

endmodule
