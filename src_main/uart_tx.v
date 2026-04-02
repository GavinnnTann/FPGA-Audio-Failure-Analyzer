// Simple UART transmitter (8N1)
module uart_tx #(
    parameter integer CLK_FREQ_HZ = 12_000_000,
    parameter integer BAUD_RATE   = 1_000_000
) (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [7:0] data,
    output reg        tx,
    output reg        busy,
    output reg        done
);

    localparam integer BAUD_DIV = CLK_FREQ_HZ / BAUD_RATE;

    reg [15:0] baud_cnt;
    reg [3:0]  bit_idx;
    reg [9:0]  shreg;

    always @(posedge clk) begin
        if (!rst_n) begin
            tx       <= 1'b1;
            busy     <= 1'b0;
            done     <= 1'b0;
            baud_cnt <= 16'd0;
            bit_idx  <= 4'd0;
            shreg    <= 10'h3FF;
        end else begin
            done <= 1'b0;

            if (!busy) begin
                tx <= 1'b1;
                if (start) begin
                    // Frame: start(0), data[7:0] LSB-first, stop(1)
                    shreg    <= {1'b1, data, 1'b0};
                    busy     <= 1'b1;
                    bit_idx  <= 4'd0;
                    baud_cnt <= 16'd0;
                    tx       <= 1'b0;
                end
            end else begin
                if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 16'd0;
                    bit_idx  <= bit_idx + 4'd1;
                    shreg    <= {1'b1, shreg[9:1]};
                    tx       <= shreg[1];

                    if (bit_idx == 4'd9) begin
                        busy <= 1'b0;
                        done <= 1'b1;
                        tx   <= 1'b1;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 16'd1;
                end
            end
        end
    end

endmodule
