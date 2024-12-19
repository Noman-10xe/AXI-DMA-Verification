/*************************************************************************
   > File Name: axi_dma_10xe_tb_top.sv
   > Description: Top Level module for Verification.
   > Author: Noman Rafiq
   > Modified: Dec 18, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`timescale 1ns / 1ps

`ifndef TB_TOP
`define TB_TOP

module axi_dma_10xe_tb_top;
    
  // include files here
  // `include "axi_dma_clk_rst_io.sv"
  import params_pkg::*;
  `include "s_axi_lite_io.sv"
   
  // global clock & reset signals 
  wire axi_aclk;
  wire axi_resetn;

  //////////////////////////////////////////////////////////////////////////////
  //                        Interface Instantiations                          //
  //////////////////////////////////////////////////////////////////////////////
  //
  // clk_rst_if
  //
  clk_rst_io  clk_rst_if( .axi_aclk   (axi_aclk), 
                          .axi_resetn (axi_resetn)
                        );
  
  // axi_lite_intf
  s_axi_lite_io axi_lite_intf ( .axi_aclk(axi_aclk),
                                .axi_resetn(axi_resetn)
                              );

  initial begin
    fork
    clk_rst_if.gen_clock(20);
    clk_rst_if.gen_reset(16);
    join
    #700;
    $finish;
  end

  // DUT instantiation
  axi_dma_0 DUT (
  .s_axi_lite_aclk(axi_aclk),                // input wire s_axi_lite_aclk
  .m_axi_mm2s_aclk(axi_aclk),                // input wire m_axi_mm2s_aclk
  .m_axi_s2mm_aclk(axi_aclk),                // input wire m_axi_s2mm_aclk
  .axi_resetn(axi_resetn),                          // input wire axi_resetn
  ///////////////////////        AXI4-LITE          // /////////////////////
  .s_axi_lite_awvalid(axi_lite_intf.s_axi_lite_awvalid),          // input wire s_axi_lite_awvalid
  .s_axi_lite_awready(axi_lite_intf.s_axi_lite_awready),          // output wire s_axi_lite_awready
  .s_axi_lite_awaddr(axi_lite_intf.s_axi_lite_awaddr),            // input wire [9 : 0] s_axi_lite_awaddr
  .s_axi_lite_wvalid(axi_lite_intf.s_axi_lite_wvalid),            // input wire s_axi_lite_wvalid
  .s_axi_lite_wready(axi_lite_intf.s_axi_lite_wready),            // output wire s_axi_lite_wready
  .s_axi_lite_wdata(axi_lite_intf.s_axi_lite_wdata),              // input wire [31 : 0] s_axi_lite_wdata
  .s_axi_lite_bresp(axi_lite_intf.s_axi_lite_bresp),              // output wire [1 : 0] s_axi_lite_bresp
  .s_axi_lite_bvalid(axi_lite_intf.s_axi_lite_bvalid),            // output wire s_axi_lite_bvalid
  .s_axi_lite_bready(axi_lite_intf.s_axi_lite_bready),            // input wire s_axi_lite_bready
  .s_axi_lite_arvalid(axi_lite_intf.s_axi_lite_arvalid),          // input wire s_axi_lite_arvalid
  .s_axi_lite_arready(axi_lite_intf.s_axi_lite_arready),          // output wire s_axi_lite_arready
  .s_axi_lite_araddr(axi_lite_intf.s_axi_lite_araddr),            // input wire [9 : 0] s_axi_lite_araddr
  .s_axi_lite_rvalid(axi_lite_intf.s_axi_lite_rvalid),            // output wire s_axi_lite_rvalid
  .s_axi_lite_rready(axi_lite_intf.s_axi_lite_rready),            // input wire s_axi_lite_rready
  .s_axi_lite_rdata(axi_lite_intf.s_axi_lite_rdata),              // output wire [31 : 0] s_axi_lite_rdata
  .s_axi_lite_rresp(axi_lite_intf.s_axi_lite_rresp),              // output wire [1 : 0] s_axi_lite_rresp
  ///////////////////////        AXI4-Read Master   // /////////////////////
  // read address channel
  .m_axi_mm2s_araddr(m_axi_mm2s_araddr),            // output wire [31 : 0] m_axi_mm2s_araddr
  .m_axi_mm2s_arlen(m_axi_mm2s_arlen),              // output wire [7 : 0] m_axi_mm2s_arlen
  .m_axi_mm2s_arsize(m_axi_mm2s_arsize),            // output wire [2 : 0] m_axi_mm2s_arsize
  .m_axi_mm2s_arburst(m_axi_mm2s_arburst),          // output wire [1 : 0] m_axi_mm2s_arburst
  .m_axi_mm2s_arprot(m_axi_mm2s_arprot),            // output wire [2 : 0] m_axi_mm2s_arprot
  .m_axi_mm2s_arcache(m_axi_mm2s_arcache),          // output wire [3 : 0] m_axi_mm2s_arcache
  .m_axi_mm2s_arvalid(m_axi_mm2s_arvalid),          // output wire m_axi_mm2s_arvalid
  .m_axi_mm2s_arready(m_axi_mm2s_arready),          // input wire m_axi_mm2s_arready
  // read data channel
  .m_axi_mm2s_rdata(m_axi_mm2s_rdata),              // input wire [31 : 0] m_axi_mm2s_rdata
  .m_axi_mm2s_rresp(m_axi_mm2s_rresp),              // input wire [1 : 0] m_axi_mm2s_rresp
  .m_axi_mm2s_rlast(m_axi_mm2s_rlast),              // input wire m_axi_mm2s_rlast
  .m_axi_mm2s_rvalid(m_axi_mm2s_rvalid),            // input wire m_axi_mm2s_rvalid
  .m_axi_mm2s_rready(m_axi_mm2s_rready),            // output wire m_axi_mm2s_rready
  .mm2s_prmry_reset_out_n(mm2s_prmry_reset_out_n),  // output wire mm2s_prmry_reset_out_n
  ///////////////////////       AXI4-Stream Master  // /////////////////////
  .m_axis_mm2s_tdata(m_axis_mm2s_tdata),            // output wire [31 : 0] m_axis_mm2s_tdata
  .m_axis_mm2s_tkeep(m_axis_mm2s_tkeep),            // output wire [3 : 0] m_axis_mm2s_tkeep
  .m_axis_mm2s_tvalid(m_axis_mm2s_tvalid),          // output wire m_axis_mm2s_tvalid
  .m_axis_mm2s_tready(m_axis_mm2s_tready),          // input wire m_axis_mm2s_tready
  .m_axis_mm2s_tlast(m_axis_mm2s_tlast),            // output wire m_axis_mm2s_tlast
  ///////////////////////       AXI4-Write Master   // /////////////////////
  // write address channel
  .m_axi_s2mm_awaddr(m_axi_s2mm_awaddr),            // output wire [31 : 0] m_axi_s2mm_awaddr
  .m_axi_s2mm_awlen(m_axi_s2mm_awlen),              // output wire [7 : 0] m_axi_s2mm_awlen
  .m_axi_s2mm_awsize(m_axi_s2mm_awsize),            // output wire [2 : 0] m_axi_s2mm_awsize
  .m_axi_s2mm_awburst(m_axi_s2mm_awburst),          // output wire [1 : 0] m_axi_s2mm_awburst
  .m_axi_s2mm_awprot(m_axi_s2mm_awprot),            // output wire [2 : 0] m_axi_s2mm_awprot
  .m_axi_s2mm_awcache(m_axi_s2mm_awcache),          // output wire [3 : 0] m_axi_s2mm_awcache
  .m_axi_s2mm_awvalid(m_axi_s2mm_awvalid),          // output wire m_axi_s2mm_awvalid
  .m_axi_s2mm_awready(m_axi_s2mm_awready),          // input wire m_axi_s2mm_awready
  // write data channel
  .m_axi_s2mm_wdata(m_axi_s2mm_wdata),              // output wire [31 : 0] m_axi_s2mm_wdata
  .m_axi_s2mm_wstrb(m_axi_s2mm_wstrb),              // output wire [3 : 0] m_axi_s2mm_wstrb
  .m_axi_s2mm_wlast(m_axi_s2mm_wlast),              // output wire m_axi_s2mm_wlast
  .m_axi_s2mm_wvalid(m_axi_s2mm_wvalid),            // output wire m_axi_s2mm_wvalid
  .m_axi_s2mm_wready(m_axi_s2mm_wready),            // input wire m_axi_s2mm_wready
  // write response channel
  .m_axi_s2mm_bresp(m_axi_s2mm_bresp),              // input wire [1 : 0] m_axi_s2mm_bresp
  .m_axi_s2mm_bvalid(m_axi_s2mm_bvalid),            // input wire m_axi_s2mm_bvalid
  .m_axi_s2mm_bready(m_axi_s2mm_bready),            // output wire m_axi_s2mm_bready
  .s2mm_prmry_reset_out_n(s2mm_prmry_reset_out_n),  // output wire s2mm_prmry_reset_out_n
  ///////////////////////       AXI4-Stream slave  // /////////////////////
  .s_axis_s2mm_tdata(s_axis_s2mm_tdata),            // input wire [31 : 0] s_axis_s2mm_tdata
  .s_axis_s2mm_tkeep(s_axis_s2mm_tkeep),            // input wire [3 : 0] s_axis_s2mm_tkeep
  .s_axis_s2mm_tvalid(s_axis_s2mm_tvalid),          // input wire s_axis_s2mm_tvalid
  .s_axis_s2mm_tready(s_axis_s2mm_tready),          // output wire s_axis_s2mm_tready
  .s_axis_s2mm_tlast(s_axis_s2mm_tlast),            // input wire s_axis_s2mm_tlast
  ///////////////////////       Interrupts          // /////////////////////
  .mm2s_introut(mm2s_introut),                      // output wire mm2s_introut
  .s2mm_introut(s2mm_introut),                      // output wire s2mm_introut
  .axi_dma_tstvec(axi_dma_tstvec)                   // output wire [31 : 0] axi_dma_tstvec
  );
  
    
endmodule : axi_dma_10xe_tb_top

`endif