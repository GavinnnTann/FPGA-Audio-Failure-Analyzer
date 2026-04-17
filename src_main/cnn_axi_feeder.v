// AXI-Stream feeder: reads spectrogram BRAM → drives CNN input
//
// Sequentially reads 4,096 bytes from the ping-pong process buffer
// and streams them to myproject's input_4 AXI-Stream port.
// Respects TREADY backpressure.
module cnn_axi_feeder (
    input  wire        clk,         // 100 MHz
    input  wire        rst_n,

    // Control
    input  wire        start,       // Pulse to begin feeding
    output reg         feeding,     // High while streaming data
    output reg         feed_done,   // Pulse when all 4096 sent

    // BRAM read port
    output reg  [11:0] rd_addr,
    input  wire [7:0]  rd_data,     // 1-cycle read latency

    // AXI-Stream to CNN
    output reg  [7:0]  tdata,
    output reg         tvalid,
    input  wire        tready
);

    localparam [1:0] S_IDLE    = 2'd0,
                     S_PREFETCH = 2'd1,
                     S_FEED    = 2'd2,
                     S_DONE    = 2'd3;

    reg [1:0]  state;
    reg [12:0] pixel_cnt;  // 0..4095 + overflow sentinel

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= S_IDLE;
            rd_addr   <= 12'd0;
            tdata     <= 8'd0;
            tvalid    <= 1'b0;
            feeding   <= 1'b0;
            feed_done <= 1'b0;
            pixel_cnt <= 13'd0;
        end else begin
            feed_done <= 1'b0;

            case (state)
                S_IDLE: begin
                    tvalid  <= 1'b0;
                    feeding <= 1'b0;
                    if (start) begin
                        rd_addr   <= 12'd0;
                        pixel_cnt <= 13'd0;
                        feeding   <= 1'b1;
                        state     <= S_PREFETCH;
                    end
                end

                // Wait one cycle for BRAM read latency
                S_PREFETCH: begin
                    state <= S_FEED;
                end

                S_FEED: begin
                    tdata  <= rd_data;
                    tvalid <= 1'b1;

                    if (tready) begin
                        if (pixel_cnt == 13'd4095) begin
                            tvalid    <= 1'b0;
                            feed_done <= 1'b1;
                            state     <= S_DONE;
                        end else begin
                            pixel_cnt <= pixel_cnt + 13'd1;
                            rd_addr   <= rd_addr + 12'd1;
                            // Next cycle: BRAM provides new rd_data,
                            // we present it as tdata
                            state     <= S_PREFETCH;
                        end
                    end
                    // If !tready, hold tdata/tvalid (backpressure)
                end

                S_DONE: begin
                    tvalid  <= 1'b0;
                    feeding <= 1'b0;
                    state   <= S_IDLE;
                end
            endcase
        end
    end

endmodule
