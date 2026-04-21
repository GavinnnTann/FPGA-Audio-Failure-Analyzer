// Real-time audio to UART packet bridge for CMOD A7 + INMP441
//
// Pipeline implemented:
// 1) I2S receive (24-bit left channel)
// 2) Decimate by 6 to ~7.812 kHz, convert to signed 16-bit
// 3) STFT frontend (Hann window + FFT + magnitude + feature quantization)
// 4) Spectrogram ping-pong buffer (2 × 64x64x8 BRAM)
// 5) CNN autoencoder inference (hls4ml myproject @ 100 MHz)
// 6) Reconstruction error → anomaly score (MAE)
// 7) Build UART frames:
//    - RMS telemetry: 0xAA, 0x55, RESULT, RMS_ENERGY, FLAGS, SEQ, METRIC, CHECKSUM
//    - Spectrogram slice: 0xDD, 0x77, BIN_IDX, BIN_LOW, BIN_HIGH, CHECKSUM
//    RESULT = CNN anomaly detection, METRIC = CNN anomaly score (MAE)
module recorder_top (
    input  wire clk,      // 12 MHz system clock
    input  wire btn0,     // Reserved for future use
    input  wire btn1,     // Reserved for future use
    input  wire i2s_sd,   // I2S serial data from INMP441
    output wire i2s_sck,  // I2S serial clock to INMP441
    output wire i2s_ws,   // I2S word select to INMP441
    output reg  led,      // Status LED (A17)
    output wire led_amp,  // Amplitude LED via PWM (C16)
    output wire uart_tx,  // UART TX to ESP32 RX (N3, edge header)
    output wire uart_tx_usb // UART TX mirror to PC via USB-UART bridge (J18)
);

    localparam DECIM            = 6;
    localparam WINDOW_SAMPLES   = 391;     // ~50ms @ 7812.5 Hz
    localparam AMP_SHIFT        = 5;       // scale mean_abs to 8-bit
    localparam CNN_ANOMALY_THRESHOLD = 8'd26; // CNN MAE anomaly threshold (0-255)

    // UART: 1,000,000 baud, 8N1 at 12 MHz
    localparam UART_BAUD        = 1_000_000;

    // ----------------------------------------------------------------
    // Clock generation: 12 MHz → 100 MHz for CNN
    // ----------------------------------------------------------------
    wire clk_100m;
    wire mmcm_locked;

    clk_gen clk_gen_inst (
        .clk_in   (clk),
        .clk_100m (clk_100m),
        .locked   (mmcm_locked)
    );

    // ----------------------------------------------------------------
    // Power-on reset (8 clock cycles + wait for MMCM lock)
    // ----------------------------------------------------------------
    reg [3:0] rst_cnt = 4'd0;
    wire rst_n = rst_cnt[3] & mmcm_locked;
    always @(posedge clk)
        if (!rst_cnt[3]) rst_cnt <= rst_cnt + 4'd1;

    // ----------------------------------------------------------------
    // I2S receiver
    // ----------------------------------------------------------------
    wire [23:0] sample_data;
    wire        sample_valid;

    i2s_receiver i2s_inst (
        .clk          (clk),
        .rst_n        (rst_n),
        .i2s_sd       (i2s_sd),
        .i2s_sck      (i2s_sck),
        .i2s_ws       (i2s_ws),
        .sample_data  (sample_data),
        .sample_valid (sample_valid)
    );

    // ----------------------------------------------------------------
    // Decimator and sample shaping
    // ----------------------------------------------------------------
    // Decimator and sample shaping
    // ----------------------------------------------------------------
    reg  [2:0] decim_cnt = 3'd0;
    reg [15:0] sample_s16 = 16'd0;
    reg        sample_ena = 1'b0;

    // Raw 16-bit I2S sample (no decimation) for FFT path
    // Full bandwidth: 46.875 kHz sample rate -> 23.4 kHz Nyquist
    wire [15:0] raw_s16 = sample_data[23:8];

    wire [15:0] abs_sample = sample_s16[15] ? (~sample_s16 + 16'd1) : sample_s16;

    always @(posedge clk) begin
        sample_ena <= 1'b0;
        if (sample_valid) begin
            if (decim_cnt == DECIM - 1) begin
                decim_cnt  <= 3'd0;
                sample_s16 <= sample_data[23:8];
                sample_ena <= 1'b1;
            end else begin
                decim_cnt <= decim_cnt + 3'd1;
            end
        end
    end

    // ----------------------------------------------------------------
    // FFT frontend and spectrogram staging
    // ----------------------------------------------------------------
    wire [1023:0] spec_bin_magnitude;
    wire [511:0]  spec_bin_feature8;
    wire          spec_frame_valid;
    wire [7:0]    spec_frame_index;

    fft_frontend #(
        .FFT_N(512),
        .HOP_N(64),
        .DATA_W(24)
    ) fft_frontend_inst (
        .clk              (clk),
        .rst_n            (rst_n),
        .sample_in        (raw_s16),
        .sample_valid     (sample_valid),
        .spec_bin_magnitude(spec_bin_magnitude),
        .spec_bin_feature8(spec_bin_feature8),
        .spec_frame_valid (spec_frame_valid),
        .spec_frame_index (spec_frame_index)
    );

    wire        spec_frame_complete;
    wire [7:0]  spec_buffer_frame_id;
    wire        spec_frame_ready;
    wire        spec_sel;

    // CNN read port wires (100 MHz domain)
    wire [11:0] cnn_bram_rd_addr;
    wire [7:0]  cnn_bram_rd_data;

    // CDC: cnn_busy from 100 MHz → 12 MHz (level sync)
    wire        cnn_busy_100m;
    reg         cnn_busy_sync1, cnn_busy_sync2;
    always @(posedge clk) begin
        cnn_busy_sync1 <= cnn_busy_100m;
        cnn_busy_sync2 <= cnn_busy_sync1;
    end
    wire cnn_idle_sync = ~cnn_busy_sync2;

    spectrogram_pingpong spectrogram_buffer_inst (
        .wr_clk        (clk),
        .wr_rst_n      (rst_n),
        .line_valid    (spec_frame_valid),
        .line_index    (spec_frame_index[5:0]),
        .line_data     (spec_bin_feature8),
        .frame_complete(spec_frame_complete),
        .frame_id      (spec_buffer_frame_id),
        .rd_clk        (clk_100m),
        .rd_addr       (cnn_bram_rd_addr),
        .rd_data       (cnn_bram_rd_data),
        .cnn_idle_sync (cnn_idle_sync),
        .frame_ready   (spec_frame_ready),
        .sel           (spec_sel)
    );

    // ----------------------------------------------------------------
    // CDC: frame_ready pulse from 12 MHz → 100 MHz (toggle sync)
    // ----------------------------------------------------------------
    reg frame_ready_toggle = 1'b0;
    always @(posedge clk)
        if (spec_frame_ready) frame_ready_toggle <= ~frame_ready_toggle;

    reg fr_toggle_s1, fr_toggle_s2, fr_toggle_s3;
    always @(posedge clk_100m) begin
        fr_toggle_s1 <= frame_ready_toggle;
        fr_toggle_s2 <= fr_toggle_s1;
        fr_toggle_s3 <= fr_toggle_s2;
    end
    wire frame_ready_100m = fr_toggle_s2 ^ fr_toggle_s3;

    // ----------------------------------------------------------------
    // CNN wrapper (100 MHz domain)
    // ----------------------------------------------------------------
    wire        cnn_done_100m;
    wire [7:0]  cnn_anomaly_score_100m;

    // Reset synchronizer for 100 MHz domain
    reg rst_100m_n_s1, rst_100m_n_s2;
    always @(posedge clk_100m) begin
        rst_100m_n_s1 <= rst_n;
        rst_100m_n_s2 <= rst_100m_n_s1;
    end
    wire rst_100m_n = rst_100m_n_s2;

    wire [7:0] cnn_dbg_byte_100m;

    cnn_wrapper cnn_wrapper_inst (
        .clk          (clk_100m),
        .rst_n        (rst_100m_n),
        .bram_rd_addr (cnn_bram_rd_addr),
        .bram_rd_data (cnn_bram_rd_data),
        .frame_ready  (frame_ready_100m),
        .cnn_busy     (cnn_busy_100m),
        .cnn_done     (cnn_done_100m),
        .anomaly_score(cnn_anomaly_score_100m),
        .dbg_byte     (cnn_dbg_byte_100m)
    );

    // ----------------------------------------------------------------
    // CDC: CNN debug byte from 100MHz → 12MHz (level sync, slow-changing)
    // ----------------------------------------------------------------
    reg [7:0] cnn_dbg_sync1, cnn_dbg_sync2;
    always @(posedge clk) begin
        cnn_dbg_sync1 <= cnn_dbg_byte_100m;
        cnn_dbg_sync2 <= cnn_dbg_sync1;
    end

    // ----------------------------------------------------------------
    // CDC: CNN results from 100MHz → 12MHz
    // ----------------------------------------------------------------
    // cnn_done pulse: toggle synchronizer
    reg cnn_done_toggle = 1'b0;
    always @(posedge clk_100m)
        if (cnn_done_100m) cnn_done_toggle <= ~cnn_done_toggle;

    reg cd_toggle_s1, cd_toggle_s2, cd_toggle_s3;
    always @(posedge clk) begin
        cd_toggle_s1 <= cnn_done_toggle;
        cd_toggle_s2 <= cd_toggle_s1;
        cd_toggle_s3 <= cd_toggle_s2;
    end
    wire cnn_done_sync = cd_toggle_s2 ^ cd_toggle_s3;

    // anomaly_score bus: latched in 100 MHz, stable when cnn_done arrives
    reg [7:0] cnn_anomaly_score_sync;
    reg       cnn_result_sync;
    reg       cnn_ran = 1'b0;  // Latches high once CNN completes at least once
    always @(posedge clk) begin
        if (!rst_n) begin
            cnn_anomaly_score_sync <= 8'd0;
            cnn_result_sync <= 1'b0;
            cnn_ran <= 1'b0;
        end else if (cnn_done_sync) begin
            cnn_anomaly_score_sync <= cnn_anomaly_score_100m;
            // Treat threshold as inclusive so MAE=26 is classified as anomaly.
            cnn_result_sync <= (cnn_anomaly_score_100m >= CNN_ANOMALY_THRESHOLD);
            cnn_ran <= 1'b1;
        end
    end

    reg [5:0] spec_bin_idx = 6'd0;
    wire [15:0] current_spec_bin;
    assign current_spec_bin = spec_bin_magnitude[{spec_bin_idx, 4'b0000} +: 16];
    reg [15:0] latched_spec_bin;  // Latched at start of each spec packet to avoid race

    // ----------------------------------------------------------------
    // Window statistics: mean absolute amplitude over ~50ms
    // ----------------------------------------------------------------
    reg [31:0] abs_sum       = 32'd0;
    reg [15:0] sample_count  = 16'd0;
    reg [31:0] mean_abs      = 32'd0;
    reg [7:0]  rms_energy    = 8'd0;
    wire [31:0] window_mean_calc = (abs_sum + abs_sample) / WINDOW_SAMPLES;

    // ----------------------------------------------------------------
    // Local amplitude LED (always live from real-time sample)
    // ----------------------------------------------------------------
    reg [7:0] pwm_cnt      = 8'd0;
    reg [7:0] live_amp_byte = 8'd0;
    always @(posedge clk) pwm_cnt <= pwm_cnt + 8'd1;
    assign led_amp = (pwm_cnt < live_amp_byte);

    // ----------------------------------------------------------------
    // UART packet FSM
    // Frame: 0xAA 0x55 RESULT RMS_ENERGY FLAGS SEQ METRIC CHECKSUM
    // ----------------------------------------------------------------
    reg        uart_start = 1'b0;
    reg [7:0]  uart_data  = 8'd0;
    wire       uart_busy;
    wire       uart_done;

    reg [4:0]  tx_state = 5'd0;
    reg [7:0]  tx_result = 8'd0;
    reg [7:0]  tx_rms    = 8'd0;
    reg [7:0]  tx_flags  = 8'd0;
    reg [7:0]  tx_seq    = 8'd0;
    reg [7:0]  tx_metric = 8'd0;
    reg [7:0]  tx_chk    = 8'd0;

    uart_tx #(
        .CLK_FREQ_HZ (12_000_000),
        .BAUD_RATE   (UART_BAUD)
    ) uart_tx_inst (
        .clk    (clk),
        .rst_n  (rst_n),
        .start  (uart_start),
        .data   (uart_data),
        .tx     (uart_tx),
        .busy   (uart_busy),
        .done   (uart_done)
    );

    // Mirror UART TX to the onboard USB-UART bridge for PC monitoring
    assign uart_tx_usb = uart_tx;

    always @(posedge clk) begin
        uart_start <= 1'b0;

        if (!rst_n) begin
            abs_sum        <= 32'd0;
            sample_count   <= 16'd0;
            mean_abs       <= 32'd0;
            rms_energy     <= 8'd0;
            live_amp_byte  <= 8'd0;
            led            <= 1'b0;
            tx_state       <= 5'd0;
            tx_result      <= 8'd0;
            tx_rms         <= 8'd0;
            tx_flags       <= 8'd0;
            tx_seq         <= 8'd0;
            tx_metric      <= 8'd0;
            tx_chk         <= 8'd0;
            spec_bin_idx   <= 6'd0;
        end else begin
            // Running status LED heartbeat (slow blink)
            led <= pwm_cnt[7] ^ btn0;

            // btn1 clears current window accumulation immediately.
            if (btn1) begin
                abs_sum      <= 32'd0;
                sample_count <= 16'd0;
                live_amp_byte <= 8'd0;
            end

            // Live amplitude estimate for LED PWM
            if (sample_ena) begin
                if (abs_sample[15:8] != 8'd0)
                    live_amp_byte <= 8'hFF;
                else
                    live_amp_byte <= (abs_sample[7:0] << 1);
            end

            // 8-second stats window (RMS energy calculation)
            if (sample_ena) begin
                if (sample_count == WINDOW_SAMPLES - 1) begin
                    mean_abs <= window_mean_calc;

                    // RMS byte scaling (mean absolute, shifted)
                    if ((window_mean_calc >> AMP_SHIFT) > 32'd255)
                        rms_energy <= 8'hFF;
                    else
                        rms_energy <= window_mean_calc[AMP_SHIFT+7:AMP_SHIFT];

                    abs_sum      <= 32'd0;
                    sample_count <= 16'd0;

                    // CNN anomaly detection replaces energy-threshold approach
                    tx_result <= cnn_result_sync ? 8'd1 : 8'd0;
                    if ((window_mean_calc >> AMP_SHIFT) > 32'd255)
                        tx_rms <= 8'hFF;
                    else
                        tx_rms <= window_mean_calc[AMP_SHIFT+7:AMP_SHIFT];
                    // bit0=1 FPGA active; bit1=CNN anomaly detected; bit2=CNN has run
                    tx_flags <= {5'b0, cnn_ran, cnn_result_sync, 1'b1};
                    // CNN anomaly score or debug byte (debug when CNN hasn't run)
                    tx_metric <= cnn_ran ? cnn_anomaly_score_sync : cnn_dbg_sync2;
                    tx_chk   <= 8'hAA ^ 8'h55
                                ^ (cnn_result_sync ? 8'd1 : 8'd0)
                                ^ (((window_mean_calc >> AMP_SHIFT) > 32'd255)
                                    ? 8'hFF
                                    : window_mean_calc[AMP_SHIFT+7:AMP_SHIFT])
                                ^ {5'b0, cnn_ran, cnn_result_sync, 1'b1}
                                ^ tx_seq
                                ^ (cnn_ran ? cnn_anomaly_score_sync : cnn_dbg_sync2);
                    if (tx_state == 5'd0)
                        tx_state <= 5'd1;
                end else begin
                    abs_sum      <= abs_sum + abs_sample;
                    sample_count <= sample_count + 16'd1;
                end
            end

            // UART frame send state machine
            case (tx_state)
                5'd0: begin
                    // Wait for next window to request a frame.
                end

                5'd1: begin
                    if (!uart_busy) begin
                        uart_data  <= 8'hAA;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd2;
                    end
                end

                5'd2: if (uart_done) tx_state <= 5'd3;

                5'd3: begin
                    if (!uart_busy) begin
                        uart_data  <= 8'h55;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd4;
                    end
                end

                5'd4: if (uart_done) tx_state <= 5'd5;

                5'd5: begin
                    if (!uart_busy) begin
                        uart_data  <= tx_result;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd6;
                    end
                end

                5'd6: if (uart_done) tx_state <= 5'd7;

                5'd7: begin
                    if (!uart_busy) begin
                        uart_data  <= tx_rms;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd8;
                    end
                end

                5'd8: if (uart_done) tx_state <= 5'd9;

                5'd9: begin
                    if (!uart_busy) begin
                        uart_data  <= tx_flags;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd10;
                    end
                end

                5'd10: if (uart_done) tx_state <= 5'd11;

                5'd11: begin
                    if (!uart_busy) begin
                        uart_data  <= tx_seq;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd12;
                    end
                end

                5'd12: if (uart_done) tx_state <= 5'd13;

                5'd13: begin
                    if (!uart_busy) begin
                        uart_data  <= tx_metric;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd14;
                    end
                end

                5'd14: if (uart_done) tx_state <= 5'd15;

                5'd15: begin
                    if (uart_done) begin
                        // RMS frame complete, move to spectrogram slice packet.
                        tx_state <= 5'd16;
                    end else if (!uart_busy) begin
                        uart_data  <= tx_chk;
                        uart_start <= 1'b1;
                    end
                end

                // Spectrogram packet: DD 77 idx bin_lo bin_hi chk
                5'd16: begin
                    if (!uart_busy) begin
                        latched_spec_bin <= current_spec_bin;  // Latch before sending
                        uart_data  <= 8'hDD;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd17;
                    end
                end

                5'd17: if (uart_done) tx_state <= 5'd18;

                5'd18: begin
                    if (!uart_busy) begin
                        uart_data  <= 8'h77;
                        uart_start <= 1'b1;
                        tx_state   <= 5'd19;
                    end
                end

                5'd19: if (uart_done) tx_state <= 5'd20;

                5'd20: begin
                    if (!uart_busy) begin
                        uart_data  <= {2'b00, spec_bin_idx};
                        uart_start <= 1'b1;
                        tx_state   <= 5'd21;
                    end
                end

                5'd21: if (uart_done) tx_state <= 5'd22;

                5'd22: begin
                    if (!uart_busy) begin
                        uart_data  <= latched_spec_bin[7:0];
                        uart_start <= 1'b1;
                        tx_state   <= 5'd23;
                    end
                end

                5'd23: if (uart_done) tx_state <= 5'd24;

                5'd24: begin
                    if (!uart_busy) begin
                        uart_data  <= latched_spec_bin[15:8];
                        uart_start <= 1'b1;
                        tx_state   <= 5'd25;
                    end
                end

                5'd25: if (uart_done) tx_state <= 5'd26;

                5'd26: begin
                    if (!uart_busy) begin
                        uart_data  <= 8'hDD ^ 8'h77 ^ {2'b00, spec_bin_idx}
                                   ^ latched_spec_bin[7:0] ^ latched_spec_bin[15:8];
                        uart_start <= 1'b1;
                        tx_state   <= 5'd27;
                    end
                end

                5'd27: begin
                    if (uart_done) begin
                        if (spec_bin_idx == 6'd63) begin
                            // All 64 bins sent — advance seq, restart
                            spec_bin_idx <= 6'd0;
                            tx_seq <= tx_seq + 8'd1;
                            tx_state <= 5'd0;
                        end else begin
                            // More bins to send — loop back to spec header
                            spec_bin_idx <= spec_bin_idx + 6'd1;
                            tx_state <= 5'd16;
                        end
                    end
                end

                default: tx_state <= 5'd0;
            endcase
        end
    end

endmodule
