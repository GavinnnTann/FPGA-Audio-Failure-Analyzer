// Self-checking testbench for i2s_receiver
//
// Models an INMP441 MEMS microphone connected to the DUT.
// The receiver generates SCK (3 MHz) and WS internally; the testbench
// drives i2s_sd in sync with the DUT's generated SCK.
//
// Verifies:
//   TEST 1  Single 24-bit sample captured correctly (0xABCDEF)
//   TEST 2  Consecutive frames: N samples at I2S rate, counts match
//   TEST 3  Right-channel bits are discarded (left only)
//   TEST 4  Zero-value sample captured correctly

`timescale 1ns/1ps

module i2s_receiver_tb;

    localparam CLK_PERIOD = 83;   // 12 MHz

    reg clk   = 0;
    reg rst_n = 0;
    reg i2s_sd = 0;

    wire       i2s_sck;
    wire       i2s_ws;
    wire [23:0] sample_data;
    wire        sample_valid;

    i2s_receiver dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .i2s_sd      (i2s_sd),
        .i2s_sck     (i2s_sck),
        .i2s_ws      (i2s_ws),
        .sample_data (sample_data),
        .sample_valid(sample_valid)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer errors      = 0;
    integer tests       = 0;
    integer valid_count = 0;

    // Track how many samples fire
    always @(posedge clk)
        if (sample_valid) valid_count <= valid_count + 1;

    // ----------------------------------------------------------------
    // Task: drive a complete 64-bit I2S frame (32 left + 32 right)
    // The INMP441 outputs MSB first, 1 SCK after WS transition.
    // We use the DUT's SCK falling edge to set up data for the next
    // rising-edge sample (provides adequate setup time).
    // Bit mapping: bit_cnt 1..24 = sample bits [23..0]
    // ----------------------------------------------------------------
    task drive_frame;
        input [23:0] left_sample;
        input [23:0] right_sample;  // should be ignored by DUT
        integer b;
        reg    bit_val;
        begin
            // A frame is 64 SCK cycles = 256 system clocks.
            // We watch for SCK falling edges and set up data.
            // SCK falls when sck_div transitions 3→0 (sck_div[1] 1→0).
            // We need to drive sd such that it's stable before the rising edge.
            //
            // Approach: monitor i2s_sck negedge → set i2s_sd → captured on next posedge
            // left channel  bit_cnt 0: delay (WS just went low), skip
            // bit_cnt 1..24: left_sample[23]..left_sample[0]
            // bit_cnt 25..31: zeros (padding, ignored by DUT)
            // right channel bits (32..63): drive right_sample but DUT ignores them

            // Wait until WS goes low (start of left channel)
            @(negedge i2s_ws);

            // Drive bits on each SCK falling edge.
            // Timing: data driven at negedge of SCK (sck_div 3→0) is captured
            // by the DUT's sd_r register 1 clock later (sck_div=1) and then
            // sampled into shift_reg at sck_div=2 with bit_cnt already incremented.
            // Therefore: data driven when bit_cnt transitions N→N+1 is captured
            // at bit_cnt=N+1.
            // Mapping: b=0 → bit_cnt 0→1 → captured at bit_cnt=1 (MSB, sample[23])
            //           b=23 → bit_cnt 23→24 → captured at bit_cnt=24 (LSB, sample[0])
            for (b = 0; b < 64; b = b + 1) begin
                @(negedge i2s_sck);
                if (b >= 0 && b <= 23) begin
                    // Left channel: MSB first
                    i2s_sd = left_sample[23 - b];
                end else if (b >= 24 && b <= 31) begin
                    // Left channel padding zeros (bits 24-31 of 32-bit slot)
                    i2s_sd = 1'b0;
                end else if (b >= 32 && b <= 55) begin
                    // Right channel: b=32 is delay (bit_cnt 32→33), b=33=MSB
                    i2s_sd = (b == 32) ? 1'b0 : right_sample[55 - b];
                end else begin
                    i2s_sd = 1'b0;
                end
            end
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    initial begin
        $dumpfile("waveforms/i2s_receiver_tb.vcd");
        $dumpvars(0, i2s_receiver_tb);

        i2s_sd = 0;
        rst_n  = 0;
        repeat (20) @(posedge clk);
        rst_n = 1;

        // Wait for DUT to synchronise (first frame boundary)
        // The DUT starts at bit_cnt=0, WS=0 after reset.
        // Allow one full I2S frame (256 sys clocks) before issuing test frames.
        repeat (512) @(posedge clk);

        // ---- TEST 1: known sample 0xABCDEF ----
        $display("\n--- TEST 1: Capture 0xABCDEF ---");
        begin : t1
            integer prev_valid;
            prev_valid = valid_count;
            // Drive the frame in parallel with sampling monitoring
            fork
                drive_frame(24'hABCDEF, 24'h123456);
            join
            // Wait for sample_valid pulse (up to 2 frames)
            repeat (512) @(posedge clk);

            tests = tests + 1;
            if (valid_count == prev_valid) begin
                $display("FAIL  TEST 1: no sample_valid in time"); errors = errors + 1;
            end else if (sample_data !== 24'hABCDEF) begin
                $display("FAIL  TEST 1: sample_data=0x%06h expected=0xABCDEF", sample_data);
                errors = errors + 1;
            end else begin
                $display("PASS  TEST 1: sample_data=0x%06h", sample_data);
            end
        end

        // ---- TEST 2: Zero sample ----
        $display("\n--- TEST 2: Capture 0x000000 ---");
        begin : t2
            integer prev_valid2;
            prev_valid2 = valid_count;
            fork
                drive_frame(24'h000000, 24'hFFFFFF);
            join
            repeat (512) @(posedge clk);

            tests = tests + 1;
            if (sample_data !== 24'h000000) begin
                $display("FAIL  TEST 2: sample_data=0x%06h expected=0x000000", sample_data);
                errors = errors + 1;
            end else
                $display("PASS  TEST 2: sample_data=0x%06h", sample_data);
        end

        // ---- TEST 3: Max positive value 0x7FFFFF ----
        $display("\n--- TEST 3: Capture 0x7FFFFF ---");
        begin : t3
            fork
                drive_frame(24'h7FFFFF, 24'h000000);
            join
            repeat (512) @(posedge clk);

            tests = tests + 1;
            if (sample_data !== 24'h7FFFFF) begin
                $display("FAIL  TEST 3: sample_data=0x%06h expected=0x7FFFFF", sample_data);
                errors = errors + 1;
            end else
                $display("PASS  TEST 3: sample_data=0x%06h", sample_data);
        end

        // ---- TEST 4: Consecutive frames — count sample_valid pulses ----
        $display("\n--- TEST 4: 10 consecutive frames, count valid pulses ---");
        begin : t4
            integer start_count;
            integer i;
            start_count = valid_count;
            for (i = 0; i < 10; i = i + 1) begin
                drive_frame(24'hA5A5A5, 24'h000000);
            end
            repeat (512) @(posedge clk);

            tests = tests + 1;
            if ((valid_count - start_count) !== 10) begin
                $display("FAIL  TEST 4: got %0d valid pulses, expected 10",
                         valid_count - start_count);
                errors = errors + 1;
            end else
                $display("PASS  TEST 4: %0d valid pulses for 10 frames", valid_count - start_count);
        end

        // ---- TEST 5: Right-channel data not captured (left unchanged) ----
        $display("\n--- TEST 5: Right-channel ignored ---");
        begin : t5
            // Drive a known left, garbage right, then drive all-zero left
            // Check that the right-channel data from previous frame does not
            // corrupt the next left-channel capture
            fork
                drive_frame(24'hCAFEBA, 24'hFFFFFF);
            join
            repeat (256) @(posedge clk);
            fork
                drive_frame(24'h000001, 24'hFFFFFF);
            join
            repeat (512) @(posedge clk);

            tests = tests + 1;
            if (sample_data !== 24'h000001) begin
                $display("FAIL  TEST 5: sample_data=0x%06h expected=0x000001 (right channel leaked?)",
                         sample_data);
                errors = errors + 1;
            end else
                $display("PASS  TEST 5: right-channel isolation confirmed");
        end

        // ----------------------------------------------------------------
        $display("\n========== i2s_receiver_tb COMPLETE ==========");
        $display("Tests run: %0d  Errors: %0d", tests, errors);
        if (errors == 0) $display("RESULT: PASS");
        else             $display("RESULT: FAIL");
        $finish;
    end

endmodule
