// ------------------------------------
// gtx_eth_clks.v
//
// Low-level wrapper for clock management module and clock buffers for GbE
// ------------------------------------

module gtx_eth_clks (
   input  gtx_out_clk,
   output gtx_usr_clk,
   output gmii_clk,
   output pll_lock
);
   wire gtx_out_clk_buf;
   wire gtx_usr_clk_l, gmii_clk_l;

   // Buffer for input clock (required for Kintex7, not required for Virtex7)
   BUFG i_gtx_out_clk_buf (
      .I (gtx_out_clk)
      .O (gtx_out_clk_buf),
   );

   // Instantiate wizard-generated clock management module
   // Configured by gtx_ethernet_clk.tcl
   gtx_eth_mmcm i_gtx_eth_mmcm (
      .clk_in   (gtx_out_clk_buf),
      .reset    (1'b0),
      .gtx_clk  (gtx_usr_clk_l),
      .gmii_clk (gmii_clk_l),
      .locked   (pll_lock)
   );

   // Buffer clock management outputs
   BUFG i_gtx_usr_clk_buf (
      .I (gtx_usr_clk_l)
      .O (gtx_usr_clk),
   );

   BUFG i_gmii_clk_buf (
      .I (gmii_clk_l)
      .O (gmii_clk),
   );

endmodule
