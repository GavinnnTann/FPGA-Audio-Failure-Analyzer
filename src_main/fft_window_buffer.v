// FFT window buffer with Hann windowing.
//
// Flow:
// 1) Capture FFT_N decimated samples when sample_valid pulses.
// 2) Stream FFT_N windowed samples (one per clk) to the FFT IP AXI input.
//
// Hann coefficients are loaded from COEFF_FILE as Q1.(COEFF_W-1) fixed-point.
// Use scripts/gen_hann_coeffs.py to generate the .mem file.
module fft_window_buffer #(
    parameter integer FFT_N = 512,
    parameter integer HOP_N = 64,
    parameter integer DATA_W = 24,
    parameter integer COEFF_W = 16,
    parameter        COEFF_FILE = "hann_512_q15.mem"
) (
    input  wire                          clk,
    input  wire                          rst_n,

    input  wire signed [DATA_W-1:0]      sample_in,
    input  wire                          sample_valid,
    input  wire                          fft_ready,

    output reg  signed [DATA_W-1:0]      fft_data,
    output reg                           fft_valid,
    output reg                           fft_last,

    output wire                          capturing,
    output wire                          streaming
);

    function integer clog2;
        input integer value;
        integer v;
        begin
            v = value - 1;
            clog2 = 0;
            while (v > 0) begin
                v = v >> 1;
                clog2 = clog2 + 1;
            end
        end
    endfunction

    localparam integer PTR_W = clog2(FFT_N);

    reg [PTR_W-1:0] wr_ptr;
    reg [PTR_W-1:0] rd_ptr;
    reg [PTR_W-1:0] coeff_ptr;
    reg [PTR_W:0]   sample_count;
    reg [PTR_W:0]   hop_count;
    reg             stream_active;

    reg signed [DATA_W-1:0] sample_buf [0:FFT_N-1];
    reg signed [COEFF_W-1:0] hann_coeff [0:FFT_N-1];

    // DSP pipeline registers for multiply (allows MREG/PREG inference).
    reg signed [DATA_W-1:0]          mul_a;
    reg signed [COEFF_W-1:0]         mul_b;
    reg signed [DATA_W+COEFF_W-1:0]  win_mult;

    function [PTR_W-1:0] ptr_inc;
        input [PTR_W-1:0] ptr;
        begin
            if (ptr == FFT_N-1)
                ptr_inc = {PTR_W{1'b0}};
            else
                ptr_inc = ptr + {{(PTR_W-1){1'b0}}, 1'b1};
        end
    endfunction

    function [PTR_W-1:0] ptr_sub;
        input [PTR_W-1:0] ptr;
        input integer dec;
        integer tmp;
        begin
            tmp = ptr - dec;
            while (tmp < 0)
                tmp = tmp + FFT_N;
            ptr_sub = tmp[PTR_W-1:0];
        end
    endfunction

    initial begin
        $readmemh(COEFF_FILE, hann_coeff);
    end

    assign capturing = 1'b1;
    assign streaming = stream_active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr    <= {PTR_W{1'b0}};
            rd_ptr    <= {PTR_W{1'b0}};
            coeff_ptr <= {PTR_W{1'b0}};
            sample_count <= {(PTR_W+1){1'b0}};
            hop_count    <= {(PTR_W+1){1'b0}};
            stream_active <= 1'b0;
            fft_data  <= {DATA_W{1'b0}};
            fft_valid <= 1'b0;
            fft_last  <= 1'b0;
            mul_a     <= {DATA_W{1'b0}};
            mul_b     <= {COEFF_W{1'b0}};
            win_mult  <= {(DATA_W+COEFF_W){1'b0}};
        end else begin
            // DSP pipeline: register multiply inputs and product.
            mul_a    <= sample_buf[rd_ptr];
            mul_b    <= hann_coeff[coeff_ptr];
            win_mult <= mul_a * mul_b;

            // Continuous capture into ring buffer.
            if (sample_valid) begin
                sample_buf[wr_ptr] <= sample_in;
                wr_ptr <= ptr_inc(wr_ptr);

                if (sample_count < FFT_N)
                    sample_count <= sample_count + {{PTR_W{1'b0}}, 1'b1};

                if (hop_count == HOP_N-1)
                    hop_count <= {(PTR_W+1){1'b0}};
                else
                    hop_count <= hop_count + {{PTR_W{1'b0}}, 1'b1};

                // Launch a new FFT window every HOP_N samples once ring is full.
                if (!stream_active && (sample_count >= FFT_N) && (hop_count == HOP_N-1)) begin
                    rd_ptr <= wr_ptr;
                    coeff_ptr <= {PTR_W{1'b0}};
                    stream_active <= 1'b1;
                end
            end

            // Stream data to FFT with ready/valid backpressure handling.
            if (stream_active) begin
                fft_data  <= win_mult >>> (COEFF_W - 1);
                fft_valid <= 1'b1;
                fft_last  <= (coeff_ptr == FFT_N-1);

                if (fft_ready) begin
                    if (coeff_ptr == FFT_N-1) begin
                        stream_active <= 1'b0;
                        fft_valid <= 1'b0;
                        fft_last  <= 1'b0;
                    end else begin
                        coeff_ptr <= coeff_ptr + {{(PTR_W-1){1'b0}}, 1'b1};
                        rd_ptr <= ptr_inc(rd_ptr);
                    end
                end
            end else begin
                fft_valid <= 1'b0;
                fft_last  <= 1'b0;
            end
        end
    end

endmodule
