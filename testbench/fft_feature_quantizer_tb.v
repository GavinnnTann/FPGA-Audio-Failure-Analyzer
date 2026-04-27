// Self-checking testbench for fft_feature_quantizer
//
// The quantizer implements log2 companding:
//   feature = { lz[3:0], norm[14:11] }
// where lz = position of leading '1', norm = magnitude_in << (15 - lz).
//
// Verifies:
//   TEST 1  Special case: 0x0000 → 0x00
//   TEST 2  Boundary powers-of-two: 0x0001, 0x0002, 0x0004, 0x0080, 0x8000
//   TEST 3  Non-power-of-two values with non-zero mantissa
//   TEST 4  Maximum: 0xFFFF → 0xFF
//   TEST 5  Monotonicity sweep: feature[n+1] >= feature[n] for all n

`timescale 1ns/1ps

module fft_feature_quantizer_tb;

    localparam CLK_PERIOD = 10;  // 100 MHz — module is clock-independent

    reg        clk              = 0;
    reg        rst_n            = 0;
    reg [15:0] magnitude_in     = 0;
    reg        magnitude_valid  = 0;

    wire [7:0] feature_out;
    wire       feature_valid;

    fft_feature_quantizer dut (
        .clk            (clk),
        .rst_n          (rst_n),
        .magnitude_in   (magnitude_in),
        .magnitude_valid(magnitude_valid),
        .feature_out    (feature_out),
        .feature_valid  (feature_valid)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer errors = 0;
    integer tests  = 0;

    // ----------------------------------------------------------------
    // Reference function: mirrors the Verilog logic
    // ----------------------------------------------------------------
    function [7:0] expected_feature;
        input [15:0] x;
        reg [4:0]  lz;
        reg [15:0] norm;
        begin
            if (x == 16'd0) begin
                expected_feature = 8'd0;
            end else begin
                // Leading one position
                casex (x)
                    16'b1xxxxxxxxxxxxxxx: lz = 5'd15;
                    16'b01xxxxxxxxxxxxxx: lz = 5'd14;
                    16'b001xxxxxxxxxxxxx: lz = 5'd13;
                    16'b0001xxxxxxxxxxxx: lz = 5'd12;
                    16'b00001xxxxxxxxxxx: lz = 5'd11;
                    16'b000001xxxxxxxxxx: lz = 5'd10;
                    16'b0000001xxxxxxxxx: lz = 5'd9;
                    16'b00000001xxxxxxxx: lz = 5'd8;
                    16'b000000001xxxxxxx: lz = 5'd7;
                    16'b0000000001xxxxxx: lz = 5'd6;
                    16'b00000000001xxxxx: lz = 5'd5;
                    16'b000000000001xxxx: lz = 5'd4;
                    16'b0000000000001xxx: lz = 5'd3;
                    16'b00000000000001xx: lz = 5'd2;
                    16'b000000000000001x: lz = 5'd1;
                    16'b0000000000000001: lz = 5'd0;
                    default:              lz = 5'd0;
                endcase
                norm = x << (15 - lz);
                expected_feature = {lz[3:0], norm[14:11]};
            end
        end
    endfunction

    // ----------------------------------------------------------------
    // Task: apply one stimulus, wait one clock, check output
    // ----------------------------------------------------------------
    task check;
        input [15:0] mag;
        input [7:0]  exp;
        input [127:0] label;
        begin
            @(negedge clk);
            magnitude_in    = mag;
            magnitude_valid = 1'b1;
            @(posedge clk);  // DUT registers magnitude_valid=1, feature_valid fires
            #1;
            // Check before deasserting — feature_valid is high this cycle
            tests = tests + 1;
            if (!feature_valid) begin
                $display("FAIL  %s mag=0x%04h: feature_valid not asserted", label, mag);
                errors = errors + 1;
            end else if (feature_out !== exp) begin
                $display("FAIL  %s mag=0x%04h: got=0x%02h exp=0x%02h",
                         label, mag, feature_out, exp);
                errors = errors + 1;
            end else begin
                $display("PASS  %s mag=0x%04h \u2192 feature=0x%02h", label, mag, feature_out);
            end
            @(negedge clk);
            magnitude_valid = 1'b0;
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    integer i;
    reg [7:0] prev_feat;
    reg [7:0] cur_feat;

    initial begin
        $dumpfile("fft_feature_quantizer_tb.vcd");
        $dumpvars(0, fft_feature_quantizer_tb);

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // ---- TEST 1: Zero input ----
        $display("\n--- TEST 1: Zero special case ---");
        check(16'h0000, 8'h00, "zero");

        // ---- TEST 2: Powers of two ----
        $display("\n--- TEST 2: Powers of two ---");
        // lz=0: 0x0001 → norm=0x8000, norm[14:11]=0 → {0000,0000}=0x00
        check(16'h0001, expected_feature(16'h0001), "pow2_0x0001");
        // lz=1: 0x0002 → norm=0x8000, norm[14:11]=0 → {0001,0000}=0x10
        check(16'h0002, expected_feature(16'h0002), "pow2_0x0002");
        // lz=2: 0x0004 → {0010,0000}=0x20
        check(16'h0004, expected_feature(16'h0004), "pow2_0x0004");
        // lz=7: 0x0080 → {0111,0000}=0x70
        check(16'h0080, expected_feature(16'h0080), "pow2_0x0080");
        // lz=8: 0x0100 → {1000,0000}=0x80
        check(16'h0100, expected_feature(16'h0100), "pow2_0x0100");
        // lz=15: 0x8000 → {1111,0000}=0xF0
        check(16'h8000, expected_feature(16'h8000), "pow2_0x8000");

        // ---- TEST 3: Non-power-of-two (non-zero mantissa) ----
        $display("\n--- TEST 3: Non-zero mantissa ---");
        // 0x0003: lz=1, norm=0xC000=1100_0000_0000_0000, norm[14:11]=1000=8 → {0001,1000}=0x18
        check(16'h0003, expected_feature(16'h0003), "0x0003");
        // 0xC000: lz=15, norm=0xC000, norm[14:11]=1000=8 → {1111,1000}=0xF8
        check(16'hC000, expected_feature(16'hC000), "0xC000");
        // 0x0F00: lz=11, norm=0x7800, norm[14:11]= ...
        check(16'h0F00, expected_feature(16'h0F00), "0x0F00");
        // 0x5A5A
        check(16'h5A5A, expected_feature(16'h5A5A), "0x5A5A");

        // ---- TEST 4: Maximum value ----
        $display("\n--- TEST 4: Maximum 0xFFFF ---");
        check(16'hFFFF, 8'hFF, "max_0xFFFF");

        // ---- TEST 5: Monotonicity — sweep 0x0001 to 0xFFFF (sampled) ----
        $display("\n--- TEST 5: Monotonicity sweep ---");
        begin : mono
            integer mono_errors;
            reg [7:0] prev_f;
            reg [7:0] cur_f;
            integer step;
            mono_errors = 0;
            prev_f = 8'd0;
            step = 256;  // sample every 256 steps for speed

            for (i = 1; i < 65536; i = i + step) begin
                @(negedge clk);
                magnitude_in    = i[15:0];
                magnitude_valid = 1'b1;
                @(negedge clk);
                magnitude_valid = 1'b0;
                @(posedge clk);
                #1;
                cur_f = feature_out;

                if (cur_f < prev_f) begin
                    if (mono_errors < 5)  // limit noise
                        $display("  FAIL mono: i=0x%04h feature=0x%02h < prev=0x%02h",
                                 i, cur_f, prev_f);
                    mono_errors = mono_errors + 1;
                end
                prev_f = cur_f;
            end

            tests = tests + 1;
            if (mono_errors > 0) begin
                $display("FAIL  TEST 5: %0d monotonicity violations", mono_errors);
                errors = errors + 1;
            end else
                $display("PASS  TEST 5: monotonicity holds across sweep");
        end

        // ---- TEST 6: feature_valid not asserted when magnitude_valid=0 ----
        $display("\n--- TEST 6: No spurious feature_valid ---");
        begin
            repeat (4) @(posedge clk);
            tests = tests + 1;
            if (feature_valid) begin
                $display("FAIL  TEST 6: feature_valid asserted without input"); errors = errors + 1;
            end else
                $display("PASS  TEST 6: no spurious feature_valid");
        end

        // ----------------------------------------------------------------
        $display("\n========== fft_feature_quantizer_tb COMPLETE ==========");
        $display("Tests run: %0d  Errors: %0d", tests, errors);
        if (errors == 0) $display("RESULT: PASS");
        else             $display("RESULT: FAIL");
        $finish;
    end

endmodule
