// Self-checking testbench for mel_filterbank
//
// Builds a behavioral reference model from the SAME mel_coeffs.mem ROM the
// DUT loads (identical multiply/shift/accumulate/saturate arithmetic), then
// drives full 256-bin frames into the DUT and checks every one of the 64
// flushed mel bands against the reference, bit-exact. A mismatch here means
// an actual RTL bug, not a hand-derived expected value that could itself be
// wrong.
//
// Requires mel_coeffs.mem in the simulation working directory (same
// requirement as fft_window_buffer's $readmemh of hann_512_q15.mem).
//
// Verifies:
//   TEST 1  Constant magnitude across all 256 bins -> matches reference model
//   TEST 2  Impulse (single active bin) -> only its 1-2 owning bands are nonzero
//   TEST 3  Pseudo-random magnitude per bin -> matches reference model
//   TEST 4  Full-scale magnitude (saturation path) -> matches reference model
//   TEST 5  Two consecutive frames -> accumulators fully clear between frames
//   TEST 6  Flush sequencing -> mel_bin_idx always counts 0..63 in order, no gaps

`timescale 1ns/1ps

module mel_filterbank_tb;

    localparam CLK_PERIOD = 10;

    reg clk = 0;
    reg rst_n = 0;

    reg  [15:0] mag_in;
    reg         mag_valid;
    reg  [7:0]  bin_idx_in;

    wire [15:0] mel_out;
    wire [5:0]  mel_bin_idx;
    wire        mel_valid;

    mel_filterbank #(
        .COEFF_FILE ("mel_coeffs.mem")
    ) dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .mag_in      (mag_in),
        .mag_valid   (mag_valid),
        .bin_idx_in  (bin_idx_in),
        .mel_out     (mel_out),
        .mel_bin_idx (mel_bin_idx),
        .mel_valid   (mel_valid)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer errors = 0;
    integer tests  = 0;

    // ------------------------------------------------------------------
    // Reference model: same ROM, same fixed-point arithmetic as the RTL.
    // ------------------------------------------------------------------
    reg [31:0] ref_rom [0:255];
    initial $readmemh("mel_coeffs.mem", ref_rom);

    reg [15:0] stim_mag [0:255];
    reg [23:0] ref_accum [0:63];
    reg [15:0] ref_mel [0:63];

    task compute_reference;
        integer k;
        reg [31:0] coeff;
        reg [5:0]  ma, mb;
        reg [7:0]  wa, wb;
        reg [23:0] pa, pb;
        begin
            for (k = 0; k < 64; k = k + 1) ref_accum[k] = 24'd0;
            for (k = 0; k < 256; k = k + 1) begin
                coeff = ref_rom[k];
                mb = coeff[29:24]; wb = coeff[23:16];
                ma = coeff[13:8];  wa = coeff[7:0];
                pa = (stim_mag[k] * wa) >> 8;
                pb = (stim_mag[k] * wb) >> 8;
                if (ma == mb)
                    ref_accum[ma] = ref_accum[ma] + pa + pb;
                else begin
                    ref_accum[ma] = ref_accum[ma] + pa;
                    ref_accum[mb] = ref_accum[mb] + pb;
                end
            end
            for (k = 0; k < 64; k = k + 1)
                ref_mel[k] = (ref_accum[k] > 24'd65535) ? 16'hFFFF : ref_accum[k][15:0];
        end
    endtask

    // ------------------------------------------------------------------
    // Drive one full 256-bin frame (stim_mag[] must already be set),
    // capture all 64 flushed bands, check sequencing and values.
    // ------------------------------------------------------------------
    reg [15:0] dut_mel [0:63];
    reg [63:0] dut_seen;  // bitmask of which mel_bin_idx values arrived

    task feed_frame;
        input [255:0] label;
        integer k;
        integer flush_count;
        integer seq_errors;
        integer expected_next;
        begin
            compute_reference;

            for (k = 0; k < 256; k = k + 1) begin
                @(negedge clk);
                mag_in     = stim_mag[k];
                bin_idx_in = k[7:0];
                mag_valid  = 1'b1;
                @(negedge clk);
                mag_valid  = 1'b0;
            end

            // Collect exactly 64 flush pulses, checking sequencing.
            flush_count = 0;
            seq_errors  = 0;
            expected_next = 0;
            dut_seen = 64'd0;
            while (flush_count < 64) begin
                @(posedge clk); #1;
                if (mel_valid) begin
                    if (mel_bin_idx !== expected_next[5:0]) seq_errors = seq_errors + 1;
                    dut_mel[mel_bin_idx] = mel_out;
                    dut_seen[mel_bin_idx] = 1'b1;
                    flush_count = flush_count + 1;
                    expected_next = expected_next + 1;
                end
            end

            tests = tests + 1;
            if (seq_errors > 0) begin
                $display("FAIL  %0s: %0d out-of-order flush indices", label, seq_errors);
                errors = errors + 1;
            end else if (dut_seen !== 64'hFFFFFFFFFFFFFFFF) begin
                $display("FAIL  %0s: not all 64 bands were flushed (seen=%h)", label, dut_seen);
                errors = errors + 1;
            end else begin
                $display("PASS  %0s: flush sequencing 0..63 correct", label);
            end

            tests = tests + 1;
            begin : value_check
                integer m;
                integer val_errors;
                val_errors = 0;
                for (m = 0; m < 64; m = m + 1) begin
                    if (dut_mel[m] !== ref_mel[m]) begin
                        val_errors = val_errors + 1;
                        if (val_errors < 6)
                            $display("  FAIL band %0d: dut=%0d expected=%0d", m, dut_mel[m], ref_mel[m]);
                    end
                end
                if (val_errors > 0) begin
                    $display("FAIL  %0s: %0d/64 band value mismatches", label, val_errors);
                    errors = errors + 1;
                end else begin
                    $display("PASS  %0s: all 64 band values match reference model", label);
                end
            end
        end
    endtask

    integer i;

    initial begin
        $dumpfile("waveforms/mel_filterbank_tb.vcd");
        $dumpvars(0, mel_filterbank_tb);

        mag_in = 16'd0; mag_valid = 1'b0; bin_idx_in = 8'd0;

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // ---- TEST 1: Constant magnitude across all bins ----
        $display("\n--- TEST 1: Constant magnitude (1000) across all 256 bins ---");
        for (i = 0; i < 256; i = i + 1) stim_mag[i] = 16'd1000;
        feed_frame("TEST1_constant");

        // ---- TEST 2: Impulse — only bin 50 active ----
        $display("\n--- TEST 2: Impulse at bin 50 ---");
        for (i = 0; i < 256; i = i + 1) stim_mag[i] = 16'd0;
        stim_mag[50] = 16'd65535;
        feed_frame("TEST2_impulse");
        begin : impulse_check
            integer m, nonzero_count;
            nonzero_count = 0;
            for (m = 0; m < 64; m = m + 1)
                if (ref_mel[m] != 16'd0) nonzero_count = nonzero_count + 1;
            tests = tests + 1;
            if (nonzero_count < 1 || nonzero_count > 2) begin
                $display("FAIL  TEST2_impulse: expected 1-2 nonzero bands, got %0d", nonzero_count);
                errors = errors + 1;
            end else begin
                $display("PASS  TEST2_impulse: %0d band(s) touched by a single bin, as expected", nonzero_count);
            end
        end

        // ---- TEST 3: Pseudo-random magnitude per bin ----
        $display("\n--- TEST 3: Pseudo-random per-bin magnitude ---");
        for (i = 0; i < 256; i = i + 1) stim_mag[i] = $random & 16'hFFFF;
        feed_frame("TEST3_random");

        // ---- TEST 4: Full-scale magnitude (saturation path) ----
        $display("\n--- TEST 4: Full-scale (0xFFFF) magnitude across all bins ---");
        for (i = 0; i < 256; i = i + 1) stim_mag[i] = 16'hFFFF;
        feed_frame("TEST4_fullscale");

        // ---- TEST 5: Two consecutive frames — accumulators must clear ----
        $display("\n--- TEST 5: Frame N+1 after full-scale frame N must not leak ---");
        for (i = 0; i < 256; i = i + 1) stim_mag[i] = 16'd0;
        feed_frame("TEST5_post_saturation_zero");
        begin : leak_check
            integer m, leak_errors;
            leak_errors = 0;
            for (m = 0; m < 64; m = m + 1)
                if (dut_mel[m] !== 16'd0) leak_errors = leak_errors + 1;
            tests = tests + 1;
            if (leak_errors > 0) begin
                $display("FAIL  TEST5: %0d bands nonzero after all-zero frame (accumulator leak)", leak_errors);
                errors = errors + 1;
            end else begin
                $display("PASS  TEST5: no accumulator leakage between frames");
            end
        end

        // ----------------------------------------------------------------
        $display("\n========== mel_filterbank_tb COMPLETE ==========");
        $display("Tests run: %0d  Errors: %0d", tests, errors);
        if (errors == 0) $display("RESULT: PASS");
        else             $display("RESULT: FAIL");
        $finish;
    end

endmodule
