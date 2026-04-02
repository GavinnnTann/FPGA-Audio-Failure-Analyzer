// I2S Master/Receiver for INMP441 Microphone
// Generates SCK (3 MHz) and WS from 12 MHz system clock.
// Captures 24-bit audio samples from the left channel (L/R pin = GND).
module i2s_receiver (
    input  wire        clk,          // 12 MHz system clock
    input  wire        rst_n,        // Active-low reset
    input  wire        i2s_sd,       // Serial data from INMP441
    output wire        i2s_sck,      // Serial clock to INMP441 (3 MHz)
    output reg         i2s_ws,       // Word select to INMP441
    output reg  [23:0] sample_data,  // 24-bit audio sample
    output reg         sample_valid  // Pulse high for 1 clk when sample ready
);

    // SCK generation: 12 MHz / 4 = 3 MHz
    // sck_div[1] toggles every 2 system clocks
    reg [1:0] sck_div;
    assign i2s_sck = sck_div[1];

    // Bit counter within I2S frame (0-63)
    // 0-31: left channel (WS=0), 32-63: right channel (WS=1)
    reg [5:0] bit_cnt;

    // Input register for metastability protection
    reg sd_r;

    // Shift register for incoming data
    reg [23:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sck_div      <= 2'd0;
            sd_r         <= 1'b0;
            bit_cnt      <= 6'd0;
            i2s_ws       <= 1'b0;
            shift_reg    <= 24'd0;
            sample_data  <= 24'd0;
            sample_valid <= 1'b0;
        end else begin
            sck_div      <= sck_div + 2'd1;
            sd_r         <= i2s_sd;
            sample_valid <= 1'b0;

            // SCK rising edge (sck_div transitions 1→2, sck_div[1] goes 0→1)
            // sd_r holds the value captured one system clock ago, giving the
            // INMP441 ample setup time after the previous SCK falling edge.
            if (sck_div == 2'd2) begin
                // I2S standard: 1-clock delay after WS transition, then 24 data bits
                // bit_cnt 0 = delay cycle, bit_cnt 1 = MSB, bit_cnt 24 = LSB
                if (!i2s_ws && bit_cnt >= 6'd1 && bit_cnt <= 6'd24)
                    shift_reg <= {shift_reg[22:0], sd_r};

                if (!i2s_ws && bit_cnt == 6'd24) begin
                    sample_data  <= {shift_reg[22:0], sd_r};
                    sample_valid <= 1'b1;
                end
            end

            // SCK falling edge (sck_div transitions 3→0, sck_div[1] goes 1→0)
            // Advance bit counter and toggle WS on channel boundaries.
            if (sck_div == 2'd0) begin
                bit_cnt <= (bit_cnt == 6'd63) ? 6'd0 : bit_cnt + 6'd1;

                if (bit_cnt == 6'd31) i2s_ws <= 1'b1;  // right channel
                if (bit_cnt == 6'd63) i2s_ws <= 1'b0;  // left channel
            end
        end
    end

endmodule
