
/*************************************************************************
   > File Name: instantiation.sv
   > Description: This File contains intantiation of DUT and BRAM.
   > Author: Noman Rafiq
   > Modified: Jan 11, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef INSTANTIATION
`define INSTANTIATION

axi_dma_0 DUT (
  .s_axi_lite_aclk                (   axi_aclk                          ),
  .m_axi_mm2s_aclk                (   axi_aclk                          ),
  .m_axi_s2mm_aclk                (   axi_aclk                          ),
  .axi_resetn                     (   axi_resetn                        ),
  ///////////////////////        AXI4-LITE          // ///////////////////
  .s_axi_lite_awvalid             (   axi_lite_intf.s_axi_lite_awvalid  ),
  .s_axi_lite_awready             (   axi_lite_intf.s_axi_lite_awready  ),
  .s_axi_lite_awaddr              (   axi_lite_intf.s_axi_lite_awaddr   ),
  .s_axi_lite_wvalid              (   axi_lite_intf.s_axi_lite_wvalid   ),
  .s_axi_lite_wready              (   axi_lite_intf.s_axi_lite_wready   ),
  .s_axi_lite_wdata               (   axi_lite_intf.s_axi_lite_wdata    ),
  .s_axi_lite_bresp               (   axi_lite_intf.s_axi_lite_bresp    ),
  .s_axi_lite_bvalid              (   axi_lite_intf.s_axi_lite_bvalid   ),
  .s_axi_lite_bready              (   axi_lite_intf.s_axi_lite_bready   ),
  .s_axi_lite_arvalid             (   axi_lite_intf.s_axi_lite_arvalid  ),
  .s_axi_lite_arready             (   axi_lite_intf.s_axi_lite_arready  ),
  .s_axi_lite_araddr              (   axi_lite_intf.s_axi_lite_araddr   ),
  .s_axi_lite_rvalid              (   axi_lite_intf.s_axi_lite_rvalid   ),
  .s_axi_lite_rready              (   axi_lite_intf.s_axi_lite_rready   ),
  .s_axi_lite_rdata               (   axi_lite_intf.s_axi_lite_rdata    ),
  .s_axi_lite_rresp               (   axi_lite_intf.s_axi_lite_rresp    ),
  ///////////////////////        AXI4-Read Master   // ///////////////////
  // read address channel
  .m_axi_mm2s_araddr              (   axi_intf.araddr                   ),
  .m_axi_mm2s_arlen               (   axi_intf.arlen                    ),
  .m_axi_mm2s_arsize              (   axi_intf.arsize                   ),
  .m_axi_mm2s_arburst             (   axi_intf.arburst                  ),
  .m_axi_mm2s_arprot              (   axi_intf.arprot                   ),
  .m_axi_mm2s_arcache             (   axi_intf.arcache                  ),
  .m_axi_mm2s_arvalid             (   axi_intf.arvalid                  ),
  .m_axi_mm2s_arready             (   axi_intf.arready                  ),
  // read data channel
  .m_axi_mm2s_rdata               (   axi_intf.rdata                    ),
  .m_axi_mm2s_rresp               (   axi_intf.rresp                    ),
  .m_axi_mm2s_rlast               (   axi_intf.rlast                    ),
  .m_axi_mm2s_rvalid              (   axi_intf.rvalid                   ),
  .m_axi_mm2s_rready              (   axi_intf.rready                   ),
  .mm2s_prmry_reset_out_n         (   axi_intf.mm2s_prmry_reset_out_n   ),
  ///////////////////////       AXI4-Stream Master  // ///////////////////
  .m_axis_mm2s_tdata              (   axis_intf.m_axis_mm2s_tdata       ),
  .m_axis_mm2s_tkeep              (   axis_intf.m_axis_mm2s_tkeep       ),
  .m_axis_mm2s_tvalid             (   axis_intf.m_axis_mm2s_tvalid      ),
  .m_axis_mm2s_tready             (   axis_intf.m_axis_mm2s_tready      ),
  .m_axis_mm2s_tlast              (   axis_intf.m_axis_mm2s_tlast       ),
  ///////////////////////       AXI4-Write Master   // ///////////////////
  // write address channel
  .m_axi_s2mm_awaddr              (   axi_intf.awaddr                   ),
  .m_axi_s2mm_awlen               (   axi_intf.awlen                    ),
  .m_axi_s2mm_awsize              (   axi_intf.awsize                   ),
  .m_axi_s2mm_awburst             (   axi_intf.awburst                  ),
  .m_axi_s2mm_awprot              (   axi_intf.awprot                   ),
  .m_axi_s2mm_awcache             (   axi_intf.awcache                  ),
  .m_axi_s2mm_awvalid             (   axi_intf.awvalid                  ),
  .m_axi_s2mm_awready             (   axi_intf.awready                  ),
  // write data channel
  .m_axi_s2mm_wdata               (   axi_intf.wdata                    ),
  .m_axi_s2mm_wstrb               (   axi_intf.wstrb                    ),
  .m_axi_s2mm_wlast               (   axi_intf.wlast                    ),
  .m_axi_s2mm_wvalid              (   axi_intf.wvalid                   ),
  .m_axi_s2mm_wready              (   axi_intf.wready                   ),
  // write response channel
  .m_axi_s2mm_bresp               (   axi_intf.bresp                    ),
  .m_axi_s2mm_bvalid              (   axi_intf.bvalid                   ),
  .m_axi_s2mm_bready              (   axi_intf.bready                   ),
  .s2mm_prmry_reset_out_n         (   axi_intf.s2mm_prmry_reset_out_n   ),
  ///////////////////////       AXI4-Stream slave  // ///////////////////
  .s_axis_s2mm_tdata              (   axis_intf.s_axis_s2mm_tdata       ),
  .s_axis_s2mm_tkeep              (   axis_intf.s_axis_s2mm_tkeep       ),
  .s_axis_s2mm_tvalid             (   axis_intf.s_axis_s2mm_tvalid      ),
  .s_axis_s2mm_tready             (   axis_intf.s_axis_s2mm_tready      ),
  .s_axis_s2mm_tlast              (   axis_intf.s_axis_s2mm_tlast       ),
  ///////////////////////       Interrupts          // ///////////////////
  .mm2s_introut                   (   axis_intf.mm2s_introut            ),
  .s2mm_introut                   (   axi_intf.s2mm_introut             ),
  .axi_dma_tstvec                 (                                     )
  );


  ////////////////////////////////////////////////////////////////////////
  //                          AXI4 Memory Module                        //
  ////////////////////////////////////////////////////////////////////////
  `ifndef ERROR_RESPONSE_TEST
  blk_mem_gen_0 memory (
  .rsta_busy                      (                                     ),
  .rstb_busy                      (                                     ),
  .s_aclk                         (   axi_aclk                          ),
  .s_aresetn                      (   axi_resetn                        ),
  .s_axi_awid                     (                                     ),
  .s_axi_awaddr                   (   axi_intf.awaddr                   ),
  .s_axi_awlen                    (   axi_intf.awlen                    ),
  .s_axi_awsize                   (   axi_intf.awsize                   ),
  .s_axi_awburst                  (   axi_intf.awburst                  ),
  .s_axi_awvalid                  (   axi_intf.awvalid                  ),
  .s_axi_awready                  (   axi_intf.awready                  ),
  .s_axi_wdata                    (   axi_intf.wdata                    ),
  .s_axi_wstrb                    (   axi_intf.wstrb                    ),
  .s_axi_wlast                    (   axi_intf.wlast                    ),
  .s_axi_wvalid                   (   axi_intf.wvalid                   ),
  .s_axi_wready                   (   axi_intf.wready                   ),
  .s_axi_bid                      (                                     ),
  .s_axi_bresp                    (   axi_intf.bresp                    ),
  .s_axi_bvalid                   (   axi_intf.bvalid                   ),
  .s_axi_bready                   (   axi_intf.bready                   ),
  .s_axi_arid                     (                                     ),
  .s_axi_araddr                   (   axi_intf.araddr                   ),
  .s_axi_arlen                    (   axi_intf.arlen                    ),
  .s_axi_arsize                   (   axi_intf.arsize                   ),
  .s_axi_arburst                  (   axi_intf.arburst                  ),
  .s_axi_arvalid                  (   axi_intf.arvalid                  ),
  .s_axi_arready                  (   axi_intf.arready                  ),
  .s_axi_rid                      (                                     ),
  .s_axi_rdata                    (   axi_intf.rdata                    ),
  .s_axi_rresp                    (   axi_intf.rresp                    ),
  .s_axi_rlast                    (   axi_intf.rlast                    ),
  .s_axi_rvalid                   (   axi_intf.rvalid                   ),
  .s_axi_rready                   (   axi_intf.rready                   )
);
`endif
`endif