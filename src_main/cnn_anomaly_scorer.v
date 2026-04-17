// CNN anomaly scorer: computes reconstruction error (MAE)
//
// During CNN output phase, re-reads the process BRAM at the same
// address sequence to compute |input[i] - output[i]| per pixel.
// Accumulates the total absolute error and produces an 8-bit MAE
// (mean absolute error = error_sum >> 12).
module cnn_anomaly_scorer (
    input  wire        clk,          // 100 MHz
    input  wire        rst_n,

    // Control
    input  wire        start,        // Pulse: begin comparison (after feeder done)
    output reg         scoring,      // High while accumulating
    output reg         score_valid,  // Pulse: anomaly_score is ready
    output reg  [7:0]  anomaly_score,

    // BRAM read port (muxed by wrapper — scorer uses it during output phase)
    output reg  [11:0] rd_addr,
    input  wire [7:0]  rd_data,

    // AXI-Stream from CNN output
    input  wire [7:0]  out_tdata,
    input  wire        out_tvalid,
    output reg         out_tready
);

    localparam [1:0] S_IDLE    = 2'd0,
                     S_WAIT    = 2'd1,
                     S_COMPARE = 2'd2,
                     S_DONE    = 2'd3;

    reg [1:0]  state;
    reg [12:0] cmp_cnt;       // Pixel counter (0..4095)
    reg [19:0] error_sum;     // max = 255 × 4096 = 1,044,480 (fits 20 bits)

    wire [7:0] abs_diff = (rd_data > out_tdata)
                         ? (rd_data - out_tdata)
                         : (out_tdata - rd_data);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            scoring       <= 1'b0;
            score_valid   <= 1'b0;
            anomaly_score <= 8'd0;
            rd_addr       <= 12'd0;
            cmp_cnt       <= 13'd0;
            error_sum     <= 20'd0;
            out_tready    <= 1'b0;
        end else begin
            score_valid <= 1'b0;

            case (state)
                S_IDLE: begin
                    out_tready <= 1'b0;
                    scoring    <= 1'b0;
                    if (start) begin
                        cmp_cnt    <= 13'd0;
                        error_sum  <= 20'd0;
                        rd_addr    <= 12'd0;
                        scoring    <= 1'b1;
                        out_tready <= 1'b1;
                        state      <= S_WAIT;
                    end
                end

                // Wait for first CNN output and prefetch BRAM
                S_WAIT: begin
                    if (out_tvalid) begin
                        state <= S_COMPARE;
                    end
                end

                S_COMPARE: begin
                    if (out_tvalid) begin
                        // rd_data is already available (prefetched)
                        error_sum <= error_sum + {12'd0, abs_diff};

                        if (cmp_cnt == 13'd4095) begin
                            out_tready <= 1'b0;
                            state      <= S_DONE;
                        end else begin
                            cmp_cnt <= cmp_cnt + 13'd1;
                            rd_addr <= rd_addr + 12'd1;
                            // BRAM read latency: next cycle rd_data updates
                            // CNN output rate is ~1 per 43 cycles, so
                            // BRAM is always ready before next tvalid
                        end
                    end
                end

                S_DONE: begin
                    // MAE = error_sum / 4096 = error_sum >> 12
                    anomaly_score <= error_sum[19:12];
                    score_valid   <= 1'b1;
                    scoring       <= 1'b0;
                    state         <= S_IDLE;
                end
            endcase
        end
    end

endmodule
