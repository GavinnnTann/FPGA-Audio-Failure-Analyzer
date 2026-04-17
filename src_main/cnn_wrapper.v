// CNN integration wrapper
//
// Ties together:
//   - BRAM read port mux (feeder vs scorer)
//   - cnn_axi_feeder (BRAM → AXI-Stream input)
//   - myproject (HLS CNN autoencoder)
//   - cnn_anomaly_scorer (reconstruction error)
//
// Control FSM: IDLE → FEED → PROCESS → RESULT → IDLE
module cnn_wrapper (
    input  wire        clk,          // 100 MHz
    input  wire        rst_n,

    // Ping-pong BRAM read port
    output wire [11:0] bram_rd_addr,
    input  wire [7:0]  bram_rd_data,

    // Control signals (synchronize externally)
    input  wire        frame_ready,  // Pulse: new frame in process buffer
    output reg         cnn_busy,     // Level: CNN is processing
    output reg         cnn_done,     // Pulse: inference + scoring complete
    output reg  [7:0]  anomaly_score, // Latched score (stable after cnn_done)

    // Debug outputs (active in 100 MHz domain)
    output wire [7:0]  dbg_byte      // Packed diagnostic byte
);

    // ----------------------------------------------------------------
    // Internal wires
    // ----------------------------------------------------------------

    // Feeder ↔ BRAM
    wire [11:0] feeder_rd_addr;
    wire        feeder_feeding;
    wire        feeder_done;

    // Feeder ↔ CNN input
    wire [7:0]  feeder_tdata;
    wire        feeder_tvalid;
    wire        cnn_input_tready;

    // CNN output
    wire [7:0]  cnn_out_tdata;
    wire        cnn_out_tvalid;
    wire        scorer_out_tready;

    // CNN control
    wire        cnn_ap_done;
    wire        cnn_ap_ready;
    wire        cnn_ap_idle;

    // Scorer ↔ BRAM
    wire [11:0] scorer_rd_addr;
    wire        scorer_scoring;
    wire        scorer_valid;
    wire [7:0]  scorer_score;

    // ----------------------------------------------------------------
    // BRAM read port: feeder always owns it (scorer uses input cache)
    // ----------------------------------------------------------------
    assign bram_rd_addr = feeder_rd_addr;

    // ----------------------------------------------------------------
    // Control FSM
    // ----------------------------------------------------------------
    localparam [2:0] S_IDLE    = 3'd0,
                     S_START   = 3'd1,
                     S_FEED    = 3'd2,
                     S_PROCESS = 3'd3,
                     S_RESULT  = 3'd4;

    reg [2:0] state;
    reg       feeder_start;
    reg       scorer_start;
    reg       ap_start;
    reg       scorer_valid_latched;

    // ----------------------------------------------------------------
    // Input pixel cache: stores a copy of each pixel as the feeder
    // streams it to the CNN.  Scorer reads from this cache instead of
    // the shared BRAM, allowing feeder and scorer to run concurrently
    // and preventing the streaming-pipeline deadlock.
    // ----------------------------------------------------------------
    (* ram_style = "block" *) reg [7:0] input_cache [0:4095];
    reg [11:0] cache_wr_ptr;
    reg [7:0]  scorer_cache_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cache_wr_ptr <= 12'd0;
        else if (state == S_START)
            cache_wr_ptr <= 12'd0;
        else if (feeder_tvalid && cnn_input_tready)
            cache_wr_ptr <= cache_wr_ptr + 12'd1;
    end

    always @(posedge clk) begin
        if (feeder_tvalid && cnn_input_tready)
            input_cache[cache_wr_ptr] <= feeder_tdata;
    end

    always @(posedge clk) begin
        scorer_cache_data <= input_cache[scorer_rd_addr];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= S_IDLE;
            cnn_busy      <= 1'b0;
            cnn_done      <= 1'b0;
            anomaly_score <= 8'd0;
            feeder_start  <= 1'b0;
            scorer_start  <= 1'b0;
            ap_start      <= 1'b0;
            scorer_valid_latched <= 1'b0;
        end else begin
            feeder_start <= 1'b0;
            scorer_start <= 1'b0;
            cnn_done     <= 1'b0;
            ap_start     <= 1'b0;

            case (state)
                S_IDLE: begin
                    cnn_busy <= 1'b0;
                    if (frame_ready) begin
                        cnn_busy <= 1'b1;
                        state    <= S_START;
                    end
                end

                // Assert ap_start and begin feeding + scoring concurrently.
                // Scorer asserts out_tready immediately (in S_WAIT), which
                // prevents CNN output backpressure from deadlocking the
                // feeder's input stream.
                S_START: begin
                    ap_start     <= 1'b1;
                    feeder_start <= 1'b1;
                    scorer_start <= 1'b1;
                    scorer_valid_latched <= 1'b0;
                    state        <= S_FEED;
                end

                // Wait for feeder to finish streaming all 4096 pixels.
                // Scorer runs concurrently; latch its result if it
                // finishes before (or at the same time as) the feeder.
                S_FEED: begin
                    if (scorer_valid) begin
                        scorer_valid_latched <= 1'b1;
                        anomaly_score       <= scorer_score;
                    end
                    if (feeder_done) begin
                        if (scorer_valid || scorer_valid_latched)
                            state <= S_RESULT;
                        else
                            state <= S_PROCESS;
                    end
                end

                // Wait for scorer to finish (if it hasn't already)
                S_PROCESS: begin
                    if (scorer_valid) begin
                        anomaly_score <= scorer_score;
                        state         <= S_RESULT;
                    end
                end

                S_RESULT: begin
                    cnn_done <= 1'b1;
                    state    <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

    // ----------------------------------------------------------------
    // AXI-Stream feeder instance
    // ----------------------------------------------------------------

    // Debug: latch "ever seen" flags for key pipeline milestones
    reg dbg_frame_ready_ever;
    reg dbg_feeder_done_ever;
    reg dbg_tvalid_out_ever;    // CNN output TVALID ever seen

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dbg_frame_ready_ever <= 1'b0;
            dbg_feeder_done_ever <= 1'b0;
            dbg_tvalid_out_ever  <= 1'b0;
        end else begin
            if (frame_ready)     dbg_frame_ready_ever <= 1'b1;
            if (feeder_done)     dbg_feeder_done_ever <= 1'b1;
            if (cnn_out_tvalid)  dbg_tvalid_out_ever  <= 1'b1;
        end
    end

    // Pack debug byte:
    //   [2:0] = wrapper FSM state
    //   [3]   = scorer out_tready (live)
    //   [4]   = frame_ready ever seen
    //   [5]   = feeder_done ever seen
    //   [6]   = CNN output TVALID ever seen
    //   [7]   = CNN input TREADY (live snapshot)
    assign dbg_byte = {cnn_input_tready, dbg_tvalid_out_ever,
                       dbg_feeder_done_ever, dbg_frame_ready_ever,
                       scorer_out_tready, state};

    cnn_axi_feeder feeder_inst (
        .clk      (clk),
        .rst_n    (rst_n),
        .start    (feeder_start),
        .feeding  (feeder_feeding),
        .feed_done(feeder_done),
        .rd_addr  (feeder_rd_addr),
        .rd_data  (bram_rd_data),
        .tdata    (feeder_tdata),
        .tvalid   (feeder_tvalid),
        .tready   (cnn_input_tready)
    );

    // ----------------------------------------------------------------
    // CNN (myproject) instance
    // ----------------------------------------------------------------
    myproject cnn_inst (
        .ap_clk             (clk),
        .ap_rst_n           (rst_n),
        .ap_start           (ap_start),
        .ap_done            (cnn_ap_done),
        .ap_ready           (cnn_ap_ready),
        .ap_idle            (cnn_ap_idle),
        .input_4_TDATA      (feeder_tdata),
        .input_4_TVALID     (feeder_tvalid),
        .input_4_TREADY     (cnn_input_tready),
        .layer16_out_TDATA  (cnn_out_tdata),
        .layer16_out_TVALID (cnn_out_tvalid),
        .layer16_out_TREADY (scorer_out_tready)
    );

    // ----------------------------------------------------------------
    // Anomaly scorer instance
    // ----------------------------------------------------------------
    cnn_anomaly_scorer scorer_inst (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (scorer_start),
        .scoring       (scorer_scoring),
        .score_valid   (scorer_valid),
        .anomaly_score (scorer_score),
        .rd_addr       (scorer_rd_addr),
        .rd_data       (scorer_cache_data),
        .out_tdata     (cnn_out_tdata),
        .out_tvalid    (cnn_out_tvalid),
        .out_tready    (scorer_out_tready)
    );

endmodule
