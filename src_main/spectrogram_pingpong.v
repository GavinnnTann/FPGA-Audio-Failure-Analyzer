// Ping-pong spectrogram double buffer (64×64×8-bit)
//
// Write side (12 MHz): Receives 512-bit line_data, deserializes to
//   64 sequential byte writes into BRAM.
// Read side (100 MHz): Exposes byte-addressable read port for CNN feeder.
// Swap: Toggles buffer selection on frame_complete when CNN is idle.
module spectrogram_pingpong (
    // Write-side (12 MHz domain)
    input  wire         wr_clk,
    input  wire         wr_rst_n,
    input  wire         line_valid,
    input  wire [5:0]   line_index,
    input  wire [511:0] line_data,

    output reg          frame_complete,
    output reg  [7:0]   frame_id,

    // Read-side (100 MHz domain)
    input  wire         rd_clk,
    input  wire [11:0]  rd_addr,
    output reg  [7:0]   rd_data,

    // Swap control (active in 12 MHz domain)
    input  wire         cnn_idle_sync,   // CNN idle, synchronized to wr_clk
    output reg          frame_ready,     // Pulse: new frame available for CNN
    output reg          sel              // 0: write A / read B, 1: write B / read A
);

    // ----------------------------------------------------------------
    // True dual-port BRAMs (inferred)
    // Port A: 12 MHz write, Port B: 100 MHz read
    // ----------------------------------------------------------------
    (* ram_style = "block" *) reg [7:0] bram_a [0:4095];
    (* ram_style = "block" *) reg [7:0] bram_b [0:4095];

    // ----------------------------------------------------------------
    // Write-side: line deserializer
    // Captures 512-bit line_data, writes 64 bytes over 64 clock cycles
    // ----------------------------------------------------------------
    reg [511:0] wr_line_buf;
    reg [5:0]   wr_row;
    reg [6:0]   wr_byte_cnt;   // 0..64, 7 bits (64 = idle sentinel)
    reg         wr_active;
    wire [11:0] wr_addr = {wr_row, wr_byte_cnt[5:0]};
    wire [7:0]  wr_byte = wr_line_buf[{wr_byte_cnt[5:0], 3'b000} +: 8];

    always @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_active      <= 1'b0;
            wr_byte_cnt    <= 7'd64;
            wr_row         <= 6'd0;
            wr_line_buf    <= 512'd0;
            frame_complete <= 1'b0;
            frame_id       <= 8'd0;
            frame_ready    <= 1'b0;
            sel            <= 1'b0;
        end else begin
            frame_complete <= 1'b0;
            frame_ready    <= 1'b0;

            if (line_valid && !wr_active) begin
                wr_line_buf <= line_data;
                wr_row      <= line_index;
                wr_byte_cnt <= 7'd0;
                wr_active   <= 1'b1;
            end

            if (wr_active) begin
                if (wr_byte_cnt == 7'd63) begin
                    wr_active <= 1'b0;
                    wr_byte_cnt <= 7'd64;

                    // Frame complete when row 63 finishes
                    if (wr_row == 6'd63) begin
                        frame_complete <= 1'b1;
                        frame_id <= frame_id + 8'd1;

                        // Swap buffers if CNN is idle
                        if (cnn_idle_sync) begin
                            sel         <= ~sel;
                            frame_ready <= 1'b1;
                        end
                        // If CNN busy, don't swap — next frame overwrites same buffer
                    end
                end else begin
                    wr_byte_cnt <= wr_byte_cnt + 7'd1;
                end
            end
        end
    end

    // ----------------------------------------------------------------
    // BRAM write process — separate from reset to enable BRAM inference
    // BRAMs do not support asynchronous reset; keeping writes in a
    // synchronous-only block lets Vivado infer block RAM.
    // ----------------------------------------------------------------
    always @(posedge wr_clk) begin
        if (wr_active) begin
            if (sel == 1'b0)
                bram_a[wr_addr] <= wr_byte;
            else
                bram_b[wr_addr] <= wr_byte;
        end
    end

    // ----------------------------------------------------------------
    // Read-side: byte-addressable read from the "process" BRAM
    // Process buffer is the one NOT being written to:
    //   sel=0 → writing A, reading B
    //   sel=1 → writing B, reading A
    // ----------------------------------------------------------------
    // sel is in wr_clk domain but changes only when CNN is idle
    // (no active reads), so it's safe to use directly in rd_clk.
    // For extra safety, we register sel in rd_clk domain.
    reg sel_rd_sync1, sel_rd_sync2;
    always @(posedge rd_clk) begin
        sel_rd_sync1 <= sel;
        sel_rd_sync2 <= sel_rd_sync1;
    end

    always @(posedge rd_clk) begin
        if (sel_rd_sync2 == 1'b0)
            rd_data <= bram_b[rd_addr];  // sel=0: write A, read B
        else
            rd_data <= bram_a[rd_addr];  // sel=1: write B, read A
    end

endmodule
