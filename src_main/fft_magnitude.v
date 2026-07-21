// FFT Magnitude Extraction
// Converts I/Q FFT output to magnitude in 16-bit format.
// Passes through every one of the first 256 bins (the physically
// meaningful half-spectrum of a real-valued input; bins 256-511 are
// conjugate mirrors and are dropped). Downstream mel_filterbank.v does
// the bin reduction (256 linear bins -> 64 mel bands) — this module no
// longer decimates on its own.
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
    output reg [7:0]   spec_bin_index   // Linear bin index (0-255)
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
    //
    // The multiply-accumulate is done in explicitly wide (52-bit)
    // intermediates before the >>16 rescale. Verilog's context-determined
    // width propagation would otherwise truncate the 26-bit x 26-bit
    // products down to a 26-bit result *before* the shift if this were
    // written as a single expression assigned directly to a 26-bit wire —
    // silently wrapping instead of saturating for large FFT-bin values.
    // Since the FFT IP runs unscaled (no automatic rescale between
    // stages), large bin magnitudes are reachable for real audio (e.g. a
    // strong low-frequency/DC transient), so this isn't just a corner case.
    wire [51:0] mag_mul_max     = max_val[33:8] * 52'd62914;
    wire [51:0] mag_mul_min     = min_val[33:8] * 52'd26084;
    wire [51:0] mag_sum_wide    = mag_mul_max + mag_mul_min;
    wire [51:0] approx_mag_wide = mag_sum_wide >> 16;

    // Keep the first 256 bins (real FFT half-spectrum); bins 256-511 are
    // conjugate mirrors and are skipped. No further decimation here —
    // mel_filterbank.v consumes all 256 and reduces them to 64 mel bands.
    wire is_valid_bin = (fft_bin_index < 10'd256);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            magnitude       <= 16'd0;
            magnitude_valid <= 1'b0;
            spec_bin_index  <= 8'd0;
        end else begin
            magnitude_valid <= 1'b0;

            if (fft_tvalid && is_valid_bin) begin
                // Saturate to 16-bit
                if (approx_mag_wide > 52'd65535) begin
                    magnitude <= 16'hFFFF;
                end else begin
                    magnitude <= approx_mag_wide[15:0];
                end

                spec_bin_index  <= fft_bin_index[7:0];
                magnitude_valid <= 1'b1;
            end
        end
    end

endmodule
