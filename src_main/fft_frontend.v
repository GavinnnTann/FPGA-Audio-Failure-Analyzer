// FFT Frontend - Windowing + FFT IP Interface + Magnitude Extraction
//
// Signal flow:
// Decimated audio samples -> Hann window buffer -> FFT IP -> Magnitude calc -> Spectrogram storage
//
// This module manages:
// 1. Sample buffering and windowing via fft_window_buffer
// 2. FFT IP instantiation with AXI-Stream handshake
// 3. Magnitude extraction and bin downsampling
// 4. Spectrogram frame accumulation (64 bins per frame)
module fft_frontend #(
    parameter integer FFT_N = 512,
    parameter integer HOP_N = 64,
    parameter integer DATA_W = 24
) (
    input  wire          clk,
    input  wire          rst_n,

    // From decimator (audio input)
    input  wire [15:0]   sample_in,
    input  wire          sample_valid,

    // Spectrogram output (64 bins × 16 bits = 1024-bit packed bus)
    // spec_bin_magnitude[15:0] = bin 0, [31:16] = bin 1, ... [1023:1008] = bin 63
    output wire [1023:0] spec_bin_magnitude,
    output wire [511:0]  spec_bin_feature8,
    output reg           spec_frame_valid,
    output reg  [7:0]    spec_frame_index   // Frame counter for UART
);

    // ======================================================================
    // Internal signals
    // ======================================================================

    // FFT window buffer outputs
    wire [DATA_W-1:0]  windowed_sample;
    wire               window_valid;
    wire               window_last;

    // FFT IP input (AXI-Stream slave)
    wire               fft_s_tready;
    reg                fft_s_tvalid;
    reg [47:0]         fft_s_tdata;
    reg                fft_s_tlast;
    reg                fft_s_pending;
    reg [47:0]         fft_s_pending_data;
    reg                fft_s_pending_last;

    // FFT IP output (AXI-Stream master)
    wire [79:0]        fft_m_tdata;
    wire               fft_m_tvalid;
    wire               fft_m_tlast;

    // FFT config (fixed for forward transform)
    wire               fft_cfg_tready;
    reg                fft_cfg_tvalid;
    reg [7:0]          fft_cfg_tdata;

    // Magnitude outputs
    wire [15:0]        mag_output;
    wire               mag_valid;
    wire [5:0]         mag_bin_index;

    // Quantized 8-bit feature output
    wire [7:0]         feature8;
    wire               feature8_valid;

    // Delayed bin index for feature8 writes (quantizer adds 1-cycle pipeline)
    reg [5:0]          mag_bin_index_d1;

    // Explicit FFT output bin index
    reg [9:0]          fft_out_bin_idx;

    // ======================================================================
    // 1. Window Buffer Module
    // ======================================================================

    fft_window_buffer #(
        .FFT_N        (FFT_N),
        .HOP_N        (HOP_N),
        .DATA_W       (DATA_W),
        .COEFF_W      (16),
        .COEFF_FILE   ("hann_512_q15.mem")
    ) window_buffer_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .sample_in    ({{(DATA_W-16){sample_in[15]}}, sample_in}),  // sign-extend 16→24
        .sample_valid (sample_valid),
        .fft_ready    (!fft_s_pending),
        .fft_data     (windowed_sample),
        .fft_valid    (window_valid),
        .fft_last     (window_last),
        .capturing    (),
        .streaming    ()
    );

    // ======================================================================
    // 2. FFT IP Instantiation (xfft_1)
    // ======================================================================

    xfft_1 fft_ip_inst (
        .aclk                    (clk),
        
        // Input data stream (windowed samples)
        .s_axis_data_tdata       (fft_s_tdata),
        .s_axis_data_tvalid      (fft_s_tvalid),
        .s_axis_data_tready      (fft_s_tready),
        .s_axis_data_tlast       (fft_s_tlast),
        
        // Config stream (transform direction: 0=forward, 1=inverse)
        .s_axis_config_tdata     (fft_cfg_tdata),
        .s_axis_config_tvalid    (fft_cfg_tvalid),
        .s_axis_config_tready    (fft_cfg_tready),
        
        // Output data stream (FFT bins)
        .m_axis_data_tdata       (fft_m_tdata),
        .m_axis_data_tvalid      (fft_m_tvalid),
        .m_axis_data_tlast       (fft_m_tlast),
        
        // Status/events (unused)
        .event_frame_started     (),
        .event_tlast_unexpected  (),
        .event_tlast_missing     (),
        .event_data_in_channel_halt ()
    );

    // ======================================================================
    // 3. Wire Window Buffer to FFT IP Input
    // ======================================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fft_s_tvalid <= 1'b0;
            fft_s_tdata  <= 48'd0;
            fft_s_tlast  <= 1'b0;
            fft_s_pending <= 1'b0;
            fft_s_pending_data <= 48'd0;
            fft_s_pending_last <= 1'b0;
            fft_cfg_tvalid <= 1'b0;
            fft_cfg_tdata <= 8'h00;
        end else begin
            // One-time FFT config pulse after reset.
            if (!fft_cfg_tvalid && fft_cfg_tready) begin
                fft_cfg_tvalid <= 1'b1;
                fft_cfg_tdata  <= 8'h00;
            end else begin
                fft_cfg_tvalid <= 1'b0;
            end

            // Capture output from window generator into pending register.
            if (!fft_s_pending && window_valid) begin
                fft_s_pending <= 1'b1;
                fft_s_pending_data <= {{24{windowed_sample[DATA_W-1]}}, windowed_sample};
                fft_s_pending_last <= window_last;
            end

            // Drive AXI source from pending register until handshake completes.
            fft_s_tvalid <= fft_s_pending;
            fft_s_tdata  <= fft_s_pending_data;
            fft_s_tlast  <= fft_s_pending_last;

            if (fft_s_pending && fft_s_tready) begin
                fft_s_pending <= 1'b0;
            end
        end
    end

    // ======================================================================
    // 4. Magnitude Extraction Module
    // ======================================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fft_out_bin_idx <= 10'd0;
        end else if (fft_m_tvalid) begin
            if (fft_m_tlast)
                fft_out_bin_idx <= 10'd0;
            else
                fft_out_bin_idx <= fft_out_bin_idx + 10'd1;
        end
    end

    fft_magnitude magnitude_inst (
        .clk           (clk),
        .rst_n         (rst_n),
        .fft_tdata     (fft_m_tdata),
        .fft_tvalid    (fft_m_tvalid),
        .fft_bin_index (fft_out_bin_idx),
        .magnitude     (mag_output),
        .magnitude_valid (mag_valid),
        .spec_bin_index (mag_bin_index)
    );

    fft_feature_quantizer feature_quantizer_inst (
        .clk           (clk),
        .rst_n         (rst_n),
        .magnitude_in  (mag_output),
        .magnitude_valid(mag_valid),
        .feature_out   (feature8),
        .feature_valid (feature8_valid)
    );

    // ======================================================================
    // 5. Spectrogram Storage (64-bin circular buffer)
    // ======================================================================

    reg [15:0] spec_storage [0:63];
    reg [7:0]  feature8_storage [0:63];
    reg [6:0]  line_count;
    reg [6:0]  feature_line_count;

    // Pack spectrogram storage into output bus
    // Bin i is at bits [(i+1)*16-1 : i*16]
    generate
        genvar i;
        for (i = 0; i < 64; i = i + 1) begin : gen_spec_pack
            assign spec_bin_magnitude[(i+1)*16-1 : i*16] = spec_storage[i];
            assign spec_bin_feature8[(i+1)*8-1 : i*8] = feature8_storage[i];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            spec_frame_index <= 8'd0;
            line_count   <= 7'd0;
            feature_line_count <= 7'd0;
            spec_frame_valid <= 1'b0;
            mag_bin_index_d1 <= 6'd0;
        end else begin
            spec_frame_valid <= 1'b0;

            // Track delayed bin index for feature8 writes.
            if (mag_valid)
                mag_bin_index_d1 <= mag_bin_index;

            // Store 16-bit magnitude on mag_valid.
            if (mag_valid) begin
                spec_storage[mag_bin_index] <= mag_output;
                line_count <= (line_count == 7'd63) ? 7'd0 : line_count + 7'd1;
            end

            // Store 8-bit feature using delayed index; derive frame-valid from feature count.
            if (feature8_valid) begin
                feature8_storage[mag_bin_index_d1] <= feature8;

                if (feature_line_count == 7'd63) begin
                    feature_line_count <= 7'd0;
                    spec_frame_index <= spec_frame_index + 8'd1;
                    spec_frame_valid <= 1'b1;
                end else begin
                    feature_line_count <= feature_line_count + 7'd1;
                end
            end
        end
    end

endmodule
