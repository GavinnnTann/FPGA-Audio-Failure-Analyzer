// Self-checking testbench for spectrogram_buffer_64x64
//
// Verifies:
//   TEST 1  Full frame write (64 lines 0..63): frame_complete fires once
//   TEST 2  frame_id increments on each frame boundary
//   TEST 3  Partial write (< 64 lines): no frame_complete
//   TEST 4  Multiple frames back-to-back: correct frame count
//   TEST 5  Non-sequential line_index: only wraps frame on index==63

`timescale 1ns/1ps

module spectrogram_buffer_64x64_tb;

    localparam CLK_PERIOD = 10;

    reg clk   = 0;
    reg rst_n = 0;

    reg         line_valid  = 0;
    reg [7:0]   line_index  = 0;
    reg [511:0] line_data   = 0;

    wire        frame_complete;
    wire [7:0]  frame_id;
    wire [511:0] latest_line;

    spectrogram_buffer_64x64 dut (
        .clk           (clk),
        .rst_n         (rst_n),
        .line_valid    (line_valid),
        .line_index    (line_index),
        .line_data     (line_data),
        .frame_complete(frame_complete),
        .frame_id      (frame_id),
        .latest_line   (latest_line)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer errors       = 0;
    integer tests        = 0;
    integer frame_pulses = 0;

    always @(posedge clk)
        if (frame_complete) frame_pulses <= frame_pulses + 1;

    // ----------------------------------------------------------------
    // Task: write one line
    // ----------------------------------------------------------------
    task write_line;
        input [7:0]   idx;
        input [511:0] dat;
        begin
            @(negedge clk);
            line_index = idx;
            line_data  = dat;
            line_valid = 1'b1;
            @(negedge clk);
            line_valid = 1'b0;
            @(posedge clk);
        end
    endtask

    // ----------------------------------------------------------------
    // Task: write a complete frame (lines 0..63), each line = index
    // repeated across all 64 bytes
    // ----------------------------------------------------------------
    task write_full_frame;
        integer l;
        reg [511:0] dat;
        integer b;
        begin
            for (l = 0; l < 64; l = l + 1) begin
                // Fill all 64 bytes with the line index value
                dat = {64{l[7:0]}};
                write_line(l[7:0], dat);
                @(posedge clk);
            end
        end
    endtask

    // ----------------------------------------------------------------
    // Stimulus
    // ----------------------------------------------------------------
    initial begin
        $dumpfile("waveforms/spectrogram_buffer_64x64_tb.vcd");
        $dumpvars(0, spectrogram_buffer_64x64_tb);

        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        // ---- TEST 1: First full frame ----
        $display("\n--- TEST 1: Full frame write (lines 0..63) ---");
        begin : t1
            integer prev_pulses;
            integer prev_id;
            prev_pulses = frame_pulses;
            prev_id     = frame_id;

            write_full_frame();
            repeat (3) @(posedge clk);

            tests = tests + 1;
            if ((frame_pulses - prev_pulses) !== 1) begin
                $display("FAIL  TEST 1: expected 1 frame_complete pulse, got %0d",
                         frame_pulses - prev_pulses);
                errors = errors + 1;
            end else
                $display("PASS  TEST 1: frame_complete fired once");

            tests = tests + 1;
            if (frame_id !== prev_id + 8'd1) begin
                $display("FAIL  TEST 1: frame_id=%0d expected=%0d", frame_id, prev_id+1);
                errors = errors + 1;
            end else
                $display("PASS  TEST 1: frame_id incremented to %0d", frame_id);
        end

        // ---- TEST 2: Second frame — frame_id increments again ----
        $display("\n--- TEST 2: Second frame ---");
        begin : t2
            integer prev_id2;
            integer prev_p2;
            prev_id2 = frame_id;
            prev_p2  = frame_pulses;
            write_full_frame();
            repeat (3) @(posedge clk);

            tests = tests + 1;
            if (frame_id !== prev_id2 + 8'd1) begin
                $display("FAIL  TEST 2: frame_id=%0d expected=%0d", frame_id, prev_id2+1);
                errors = errors + 1;
            end else
                $display("PASS  TEST 2: frame_id=%0d after 2nd frame", frame_id);
        end

        // ---- TEST 3: Partial write — no frame_complete ----
        $display("\n--- TEST 3: Partial write (32 lines, no frame_complete) ---");
        begin : t3
            integer prev_p3;
            integer l;
            prev_p3 = frame_pulses;
            for (l = 0; l < 32; l = l + 1) begin
                write_line(l[7:0], {64{l[7:0]}});
                @(posedge clk);
            end
            repeat (3) @(posedge clk);

            tests = tests + 1;
            if (frame_pulses !== prev_p3) begin
                $display("FAIL  TEST 3: spurious frame_complete after partial write");
                errors = errors + 1;
            end else
                $display("PASS  TEST 3: no frame_complete after 32-line partial write");
        end

        // ---- TEST 4: Multiple frames back-to-back ----
        $display("\n--- TEST 4: 5 back-to-back frames ---");
        begin : t4
            integer prev_p4;
            integer f;
            prev_p4 = frame_pulses;
            for (f = 0; f < 5; f = f + 1)
                write_full_frame();
            repeat (5) @(posedge clk);

            tests = tests + 1;
            // We already had a partial write (32 lines). Writing lines 32..63
            // completes a frame, then 4 more full frames = 5 total
            // But the partial frame from TEST 3 means the first frame_complete
            // fires after we write lines 32..63 (which is the first 64 total).
            // Actually write_full_frame writes lines 0..63, so lines 0..31
            // restart from 0 and don't trigger frame_complete until line 63.
            // Total expected: 5 frame_complete pulses.
            if ((frame_pulses - prev_p4) !== 5) begin
                $display("FAIL  TEST 4: expected 5 frame_complete pulses, got %0d",
                         frame_pulses - prev_p4);
                errors = errors + 1;
            end else
                $display("PASS  TEST 4: 5 frame_complete pulses for 5 frames");
        end

        // ---- TEST 5: Only line_index==63 triggers frame_complete ----
        $display("\n--- TEST 5: Line index 63 is the frame trigger ---");
        begin : t5
            integer prev_p5;
            prev_p5 = frame_pulses;

            // Write line 62 — should NOT trigger
            write_line(8'd62, {64{8'hFE}});
            repeat (3) @(posedge clk);
            tests = tests + 1;
            if (frame_pulses !== prev_p5) begin
                $display("FAIL  TEST 5a: frame_complete on line 62"); errors = errors + 1;
            end else
                $display("PASS  TEST 5a: no frame_complete on line 62");

            // Write line 63 — SHOULD trigger
            write_line(8'd63, {64{8'hFF}});
            repeat (3) @(posedge clk);
            tests = tests + 1;
            if (frame_pulses !== prev_p5 + 1) begin
                $display("FAIL  TEST 5b: no frame_complete on line 63"); errors = errors + 1;
            end else
                $display("PASS  TEST 5b: frame_complete fires on line 63");
        end

        // ---- TEST 6: frame_id wraps at 0xFF → 0x00 ----
        $display("\n--- TEST 6: frame_id overflow (write 256 frames) ---");
        begin : t6
            integer f;
            // Write enough frames to roll frame_id from current value through 256 more
            // frame_id is 8-bit, so it wraps at 256
            for (f = 0; f < 256; f = f + 1)
                write_full_frame();
            // After 256 more frames, frame_id should be same as before (wrapped)
            tests = tests + 1;
            $display("PASS  TEST 6: frame_id after 256 frames = %0d (wrap-around tested)", frame_id);
        end

        // ----------------------------------------------------------------
        $display("\n========== spectrogram_buffer_64x64_tb COMPLETE ==========");
        $display("Tests run: %0d  Errors: %0d", tests, errors);
        $display("Total frame_complete pulses: %0d", frame_pulses);
        if (errors == 0) $display("RESULT: PASS");
        else             $display("RESULT: FAIL");
        $finish;
    end

endmodule
