// FFT feature quantizer
// Converts 16-bit linear magnitude into 8-bit compressed feature for CNN input.
// Output = {lz[3:0], mantissa[14:11]}: 16 log-scale bands × 16 fractional steps = 256 values.
// Monotonic for magnitudes 1..65535. Zero input maps to 0.
module fft_feature_quantizer (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [15:0] magnitude_in,
    input  wire        magnitude_valid,
    output reg  [7:0]  feature_out,
    output reg         feature_valid
);

    function [4:0] leading_one_pos;
        input [15:0] x;
        begin
            casex (x)
                16'b1xxxxxxxxxxxxxxx: leading_one_pos = 5'd15;
                16'b01xxxxxxxxxxxxxx: leading_one_pos = 5'd14;
                16'b001xxxxxxxxxxxxx: leading_one_pos = 5'd13;
                16'b0001xxxxxxxxxxxx: leading_one_pos = 5'd12;
                16'b00001xxxxxxxxxxx: leading_one_pos = 5'd11;
                16'b000001xxxxxxxxxx: leading_one_pos = 5'd10;
                16'b0000001xxxxxxxxx: leading_one_pos = 5'd9;
                16'b00000001xxxxxxxx: leading_one_pos = 5'd8;
                16'b000000001xxxxxxx: leading_one_pos = 5'd7;
                16'b0000000001xxxxxx: leading_one_pos = 5'd6;
                16'b00000000001xxxxx: leading_one_pos = 5'd5;
                16'b000000000001xxxx: leading_one_pos = 5'd4;
                16'b0000000000001xxx: leading_one_pos = 5'd3;
                16'b00000000000001xx: leading_one_pos = 5'd2;
                16'b000000000000001x: leading_one_pos = 5'd1;
                16'b0000000000000001: leading_one_pos = 5'd0;
                default: leading_one_pos = 5'd0;
            endcase
        end
    endfunction

    reg [4:0] lz;
    reg [15:0] norm;
    reg [7:0] compand;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            feature_out <= 8'd0;
            feature_valid <= 1'b0;
            lz <= 5'd0;
            norm <= 16'd0;
            compand <= 8'd0;
        end else begin
            feature_valid <= 1'b0;

            if (magnitude_valid) begin
                if (magnitude_in == 16'd0) begin
                    feature_out <= 8'd0;
                end else begin
                    lz = leading_one_pos(magnitude_in);
                    norm = magnitude_in << (15 - lz);
                    // log2 approximation packed into 8 bits: 4-bit integer + 4-bit fraction.
                    // 16 log-scale bands × 16 fractional steps = full 0..255 range.
                    feature_out <= {lz[3:0], norm[14:11]};
                end

                feature_valid <= 1'b1;
            end
        end
    end

endmodule
