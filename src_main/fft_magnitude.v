// FFT Magnitude Extraction
// Converts I/Q FFT output to magnitude in 16-bit format
// Supports bin downsampling for spectrogram (512 FFT bins -> 64 spectrogram bins)
module fft_magnitude (
    input  wire        clk,
    input  wire        rst_n,

    // FFT IP output (AXI M_AXIS_DATA)
    // Bits [33:0]:   Real part (34-bit signed, Q23 fixed-point)
    // Bits [73:40]:  Imaginary part (34-bit signed, Q23 fixed-point)
    input  wire [79:0] fft_tdata,
    input  wire        fft_tvalid,
    input  wire [9:0]  fft_bin_index,  // Which bin (0-511) is this output

    // Magnitude output
    output reg [15:0]  magnitude,
    output reg         magnitude_valid,
    output reg [5:0]   spec_bin_index   // Downsampled bin (0-63)
);

    // Extract I and Q components
    wire signed [33:0] real_part = fft_tdata[33:0];
    wire signed [33:0] imag_part = fft_tdata[73:40];

    // Compute absolute values
    wire signed [33:0] abs_real = (real_part[33]) ? -real_part : real_part;
    wire signed [33:0] abs_imag = (imag_part[33]) ? -imag_part : imag_part;

    // Find max and min
    wire [33:0] max_val = (abs_real > abs_imag) ? abs_real : abs_imag;
    wire [33:0] min_val = (abs_real > abs_imag) ? abs_imag : abs_real;

    // Magnitude approximation using Alphamax+Betamax
    // mag ≈ 0.96*max + 0.398*min
    // Using Q16 fixed-point: 0.96 ≈ 62914, 0.398 ≈ 26084 (out of 65536)
    // To avoid overflow, we shift right by 8 first
    wire [25:0] approx_mag = ((max_val[33:8] * 26'd62914) + (min_val[33:8] * 26'd26084)) >> 16;

    // Downsampling: take every 4th bin from the first 256 bins (real FFT)
    // 256 / 4 = 64 output bins covering 0 to Nyquist
    // Bins 256-511 are conjugate mirrors and are skipped.
    wire is_downsampled_bin = (fft_bin_index < 10'd256) && (fft_bin_index[1:0] == 2'b0);
    wire [5:0] downsampled_index = fft_bin_index[7:2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            magnitude       <= 16'd0;
            magnitude_valid <= 1'b0;
            spec_bin_index  <= 6'd0;
        end else begin
            magnitude_valid <= 1'b0;

            // Output every 8th bin
            if (fft_tvalid && is_downsampled_bin) begin
                // Saturate to 16-bit
                if (approx_mag > 26'd65535) begin
                    magnitude <= 16'hFFFF;
                end else begin
                    magnitude <= approx_mag[15:0];
                end

                spec_bin_index  <= downsampled_index;
                magnitude_valid <= 1'b1;
            end
        end
    end

endmodule
