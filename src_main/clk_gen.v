// MMCM clock generator: 12 MHz → 100 MHz
// Uses Xilinx MMCME2_BASE primitive on xc7a35t
//
// MMCM configuration:
//   VCO = 12 MHz × (CLKFBOUT_MULT_F=50) / (DIVCLK_DIVIDE=1) = 600 MHz
//   CLKOUT0 = 600 MHz / (CLKOUT0_DIVIDE_F=6.0) = 100 MHz
module clk_gen (
    input  wire clk_in,      // 12 MHz board clock
    output wire clk_100m,    // 100 MHz for CNN
    output wire locked       // MMCM locked indicator
);

    wire clk_fb;
    wire clk_100m_unbuf;

    MMCME2_BASE #(
        .BANDWIDTH          ("OPTIMIZED"),
        .CLKFBOUT_MULT_F    (50.0),       // VCO = 12 × 50 = 600 MHz
        .CLKFBOUT_PHASE     (0.0),
        .CLKIN1_PERIOD       (83.333),     // 12 MHz = 83.333 ns
        .CLKOUT0_DIVIDE_F   (6.0),        // 600 / 6 = 100 MHz
        .CLKOUT0_DUTY_CYCLE (0.5),
        .CLKOUT0_PHASE      (0.0),
        .DIVCLK_DIVIDE      (1),
        .REF_JITTER1        (0.010),
        .STARTUP_WAIT       ("FALSE")
    ) mmcm_inst (
        .CLKOUT0  (clk_100m_unbuf),
        .CLKOUT0B (),
        .CLKOUT1  (),
        .CLKOUT1B (),
        .CLKOUT2  (),
        .CLKOUT2B (),
        .CLKOUT3  (),
        .CLKOUT3B (),
        .CLKOUT4  (),
        .CLKOUT5  (),
        .CLKOUT6  (),
        .CLKFBOUT (clk_fb),
        .CLKFBOUTB(),
        .LOCKED   (locked),
        .CLKIN1   (clk_in),
        .PWRDWN   (1'b0),
        .RST      (1'b0),
        .CLKFBIN  (clk_fb)
    );

    BUFG bufg_100m (
        .I (clk_100m_unbuf),
        .O (clk_100m)
    );

endmodule
