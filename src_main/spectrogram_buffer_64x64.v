// 64x64x8 spectrogram staging buffer.
// Writes one 64-bin line on line_valid, indexed by line_index.
module spectrogram_buffer_64x64 (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         line_valid,
    input  wire [7:0]   line_index,
    input  wire [511:0] line_data,

    output reg          frame_complete,
    output reg  [7:0]   frame_id,
    output wire [511:0] latest_line
);

    reg [7:0] mem [0:63][0:63];
    integer i;

    assign latest_line = line_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frame_complete <= 1'b0;
            frame_id <= 8'd0;
        end else begin
            frame_complete <= 1'b0;
            if (line_valid) begin
                for (i = 0; i < 64; i = i + 1)
                    mem[line_index[5:0]][i] <= line_data[(i+1)*8-1 -: 8];

                if (line_index[5:0] == 6'd63) begin
                    frame_complete <= 1'b1;
                    frame_id <= frame_id + 8'd1;
                end
            end
        end
    end

endmodule
