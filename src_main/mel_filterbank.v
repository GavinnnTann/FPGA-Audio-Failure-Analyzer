// Mel filterbank — warps 256 linear FFT bins into 64 mel-spaced bands.
//
// Why: the CNN autoencoder (submission/src/qmodel.ipynb) was trained on
// librosa mel spectrograms (Slaney scale, 64 bands, 0-8000 Hz). The FPGA's
// own linear-bin decimation ("every 4th of 256 bins") does not match that
// frequency axis. This module applies a same-shaped mel filterbank (see
// scripts/gen_mel_coeffs.py) to the FPGA's own 256 linear FFT bins so the
// CNN sees a perceptually mel-shaped spectrum again, matching what it was
// trained on. Bins above ~8 kHz carry zero weight by construction (the
// training data never had energy above its own 16 kHz/2 Nyquist), so they
// are naturally excluded rather than special-cased.
//
// Because contiguous triangular mel filters only overlap their immediate
// neighbour, any single linear bin contributes to at most two mel bands.
// mel_coeffs.mem stores exactly those two (band, weight) pairs per bin.
//
// Pipeline: accumulate all 256 per-bin contributions into 64 running sums
// (ACCUM state), then on the last bin of the frame (bin_idx==255) spend 64
// cycles streaming the finished bands out one per cycle (FLUSH state),
// clearing each accumulator immediately behind the read so the module is
// ready to accumulate the next frame. Frame period is ~1.37 ms at 12 MHz
// (64-sample FFT hop); flush takes 64 cycles (~5.3 us) — no danger of the
// next frame's bin 0 arriving before flush completes.
module mel_filterbank #(
    parameter COEFF_FILE = "mel_coeffs.mem"
) (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [15:0] mag_in,
    input  wire        mag_valid,
    input  wire [7:0]  bin_idx_in,   // 0..255

    output reg  [15:0] mel_out,
    output reg  [5:0]  mel_bin_idx,  // 0..63
    output reg          mel_valid
);

    // ------------------------------------------------------------------
    // Coefficient ROM: one 32-bit word per linear bin (0..255).
    //   [29:24] mel_idx_b   [23:16] weight_b (Q0.8, unsigned)
    //   [13:8]  mel_idx_a   [7:0]   weight_a (Q0.8, unsigned)
    // ------------------------------------------------------------------
    (* rom_style = "block" *) reg [31:0] coeff_rom [0:255];

    initial begin
        $readmemh(COEFF_FILE, coeff_rom);
    end

    wire [31:0] coeff        = coeff_rom[bin_idx_in];
    wire [5:0]  mel_a        = coeff[13:8];
    wire [7:0]  w_a          = coeff[7:0];
    wire [5:0]  mel_b        = coeff[29:24];
    wire [7:0]  w_b          = coeff[23:16];
    wire        same_band    = (mel_a == mel_b);

    // Product scaled back from Q0.8 weight * 16-bit magnitude.
    // Explicit intermediate widths (16b x 8b = 24b) avoid relying on
    // Verilog's context-dependent sizing rules for the shift operand.
    wire [23:0] mul_a  = mag_in * w_a;
    wire [23:0] mul_b  = mag_in * w_b;
    wire [23:0] prod_a = mul_a >> 8;
    wire [23:0] prod_b = mul_b >> 8;

    // ------------------------------------------------------------------
    // 64 running accumulators. Max plausible sum: widest mel band spans
    // roughly the top third of the active 0-87 bin range at full-scale
    // magnitude (65535) — comfortably inside 24 bits.
    // ------------------------------------------------------------------
    reg [23:0] accum [0:63];

    localparam S_ACCUM = 1'b0,
               S_FLUSH = 1'b1;

    reg        state;
    reg [5:0]  flush_idx;
    integer    i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= S_ACCUM;
            flush_idx   <= 6'd0;
            mel_out     <= 16'd0;
            mel_bin_idx <= 6'd0;
            mel_valid   <= 1'b0;
            for (i = 0; i < 64; i = i + 1)
                accum[i] <= 24'd0;
        end else begin
            mel_valid <= 1'b0;

            case (state)
                S_ACCUM: begin
                    if (mag_valid) begin
                        if (same_band)
                            accum[mel_a] <= accum[mel_a] + prod_a + prod_b;
                        else begin
                            accum[mel_a] <= accum[mel_a] + prod_a;
                            accum[mel_b] <= accum[mel_b] + prod_b;
                        end

                        if (bin_idx_in == 8'd255) begin
                            state     <= S_FLUSH;
                            flush_idx <= 6'd0;
                        end
                    end
                end

                S_FLUSH: begin
                    mel_out     <= (accum[flush_idx] > 24'd65535) ? 16'hFFFF : accum[flush_idx][15:0];
                    mel_bin_idx <= flush_idx;
                    mel_valid   <= 1'b1;
                    accum[flush_idx] <= 24'd0;

                    if (flush_idx == 6'd63)
                        state <= S_ACCUM;
                    else
                        flush_idx <= flush_idx + 6'd1;
                end
            endcase
        end
    end

endmodule
