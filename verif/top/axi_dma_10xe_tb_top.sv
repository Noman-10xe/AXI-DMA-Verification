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
`ifndef TB_TOP
`define TB_TOP

`timescale 1ns / 1ps

// UVM Macros
`include "uvm_macros.svh"
import uvm_pkg::*;

`define UVM_VERSION_1_2

import params_pkg::*;

// Includes
`include "../interfaces/clk_rst_io.sv"
`include "../interfaces/s_axi_lite_io.sv"
`include "../interfaces/axis_io.sv"
////////////////////////////////////////////
`include "../register_uvc/reg_transaction.sv"
`include "../register_uvc/reg_sequence.sv"
`include "../register_uvc/axi_lite_driver.sv"
`include "../register_uvc/axi_lite_sequencer.sv"
`include "../register_uvc/axi_lite_monitor.sv"
`include "../register_uvc/axi_lite_agent.sv"
////////////////////////////////////////////
`include "../stream_uvc/axis_transaction.sv"
`include "../stream_uvc/axis_transaction.sv"
`include "../stream_uvc/axis_sequence.sv"
`include "../stream_uvc/axis_read_driver.sv"
`include "../stream_uvc/axis_read_monitor.sv"
`include "../stream_uvc/axis_read_agent.sv"
`include "../stream_uvc/axis_write_driver.sv"
`include "../stream_uvc/axis_write_monitor.sv"
`include "../stream_uvc/axis_write_agent.sv"
///////////////////////////////////////////
// `include "../mm2s_uvc/axi_transaction.sv"
// `include "../mm2s_uvc/axi_sequence.sv"
// `include "../mm2s_uvc/mm2s_driver.sv"
// `include "../mm2s_uvc/mm2s_monitor.sv"
// `include "../mm2s_uvc/axi_read_agent.sv"
///////////////////////////////////////////
`include "../environment/environment.sv"
`include "../tests/base_test.sv"

module axi_dma_10xe_tb_top;
  
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
  
  // axis_intf
  axis_io axis_intf ( .axi_aclk(axi_aclk),
                      .axi_resetn(axi_resetn)
                    );

  axi_io  axi_intf ( .axi_aclk(axi_aclk),
                     .axi_resetn(axi_resetn) 
                   );

  initial begin
    fork
    run_test("base_test");
    clk_rst_if.gen_clock(20);
    clk_rst_if.gen_reset(16);
    join
  end

  initial begin
    uvm_config_db #(virtual s_axi_lite_io)::set(null, "*", "axi_lite_intf", axi_lite_intf);
    uvm_config_db #(virtual axis_io)::set(null, "*", "axis_intf", axis_intf);
    uvm_config_db #(virtual axi_io)::set(null, "*", "axi_intf", axi_intf);
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
  .m_axi_mm2s_araddr(axi_intf.araddr),            // output wire [31 : 0] m_axi_mm2s_araddr
  .m_axi_mm2s_arlen(axi_intf.arlen),              // output wire [7 : 0] m_axi_mm2s_arlen
  .m_axi_mm2s_arsize(axi_intf.arsize),            // output wire [2 : 0] m_axi_mm2s_arsize
  .m_axi_mm2s_arburst(axi_intf.arburst),          // output wire [1 : 0] m_axi_mm2s_arburst
  .m_axi_mm2s_arprot(axi_intf.arprot),            // output wire [2 : 0] m_axi_mm2s_arprot
  .m_axi_mm2s_arcache(axi_intf.arcache),          // output wire [3 : 0] m_axi_mm2s_arcache
  .m_axi_mm2s_arvalid(axi_intf.arvalid),          // output wire m_axi_mm2s_arvalid
  .m_axi_mm2s_arready(axi_intf.arready),          // input wire m_axi_mm2s_arready
  // read data channel
  .m_axi_mm2s_rdata(axi_intf.rdata),              // input wire [31 : 0] m_axi_mm2s_rdata
  .m_axi_mm2s_rresp(axi_intf.rresp),              // input wire [1 : 0] m_axi_mm2s_rresp
  .m_axi_mm2s_rlast(axi_intf.rlast),              // input wire m_axi_mm2s_rlast
  .m_axi_mm2s_rvalid(axi_intf.rvalid),            // input wire m_axi_mm2s_rvalid
  .m_axi_mm2s_rready(axi_intf.rready),            // output wire m_axi_mm2s_rready
  .mm2s_prmry_reset_out_n(axi_intf.mm2s_prmry_reset_out_n),  // output wire mm2s_prmry_reset_out_n
  ///////////////////////       AXI4-Stream Master  // /////////////////////
  .m_axis_mm2s_tdata(axis_intf.m_axis_mm2s_tdata),            // output wire [31 : 0] m_axis_mm2s_tdata
  .m_axis_mm2s_tkeep(axis_intf.m_axis_mm2s_tkeep),            // output wire [3 : 0] m_axis_mm2s_tkeep
  .m_axis_mm2s_tvalid(axis_intf.m_axis_mm2s_tvalid),          // output wire m_axis_mm2s_tvalid
  .m_axis_mm2s_tready(axis_intf.m_axis_mm2s_tready),          // input wire m_axis_mm2s_tready
  .m_axis_mm2s_tlast(axis_intf.m_axis_mm2s_tlast),            // output wire m_axis_mm2s_tlast
  ///////////////////////       AXI4-Write Master   // /////////////////////
  // write address channel
  .m_axi_s2mm_awaddr(axi_intf.awaddr),            // output wire [31 : 0] m_axi_s2mm_awaddr
  .m_axi_s2mm_awlen(axi_intf.awlen),              // output wire [7 : 0] m_axi_s2mm_awlen
  .m_axi_s2mm_awsize(axi_intf.awsize),            // output wire [2 : 0] m_axi_s2mm_awsize
  .m_axi_s2mm_awburst(axi_intf.awburst),          // output wire [1 : 0] m_axi_s2mm_awburst
  .m_axi_s2mm_awprot(axi_intf.awprot),            // output wire [2 : 0] m_axi_s2mm_awprot
  .m_axi_s2mm_awcache(axi_intf.awcache),          // output wire [3 : 0] m_axi_s2mm_awcache
  .m_axi_s2mm_awvalid(axi_intf.awvalid),          // output wire m_axi_s2mm_awvalid
  .m_axi_s2mm_awready(axi_intf.awready),          // input wire m_axi_s2mm_awready
  // write data channel
  .m_axi_s2mm_wdata(axi_intf.wdata),              // output wire [31 : 0] m_axi_s2mm_wdata
  .m_axi_s2mm_wstrb(axi_intf.wstrb),              // output wire [3 : 0] m_axi_s2mm_wstrb
  .m_axi_s2mm_wlast(axi_intf.wlast),              // output wire m_axi_s2mm_wlast
  .m_axi_s2mm_wvalid(axi_intf.wvalid),            // output wire m_axi_s2mm_wvalid
  .m_axi_s2mm_wready(axi_intf.wready),            // input wire m_axi_s2mm_wready
  // write response channel
  .m_axi_s2mm_bresp(axi_intf.bresp),              // input wire [1 : 0] m_axi_s2mm_bresp
  .m_axi_s2mm_bvalid(axi_intf.bvalid),            // input wire m_axi_s2mm_bvalid
  .m_axi_s2mm_bready(axi_intf.bready),            // output wire m_axi_s2mm_bready
  .s2mm_prmry_reset_out_n(axi_intf.s2mm_prmry_reset_out_n),  // output wire s2mm_prmry_reset_out_n
  ///////////////////////       AXI4-Stream slave  // /////////////////////
  .s_axis_s2mm_tdata(axis_intf.s_axis_s2mm_tdata),            // input wire [31 : 0] s_axis_s2mm_tdata
  .s_axis_s2mm_tkeep(axis_intf.s_axis_s2mm_tkeep),            // input wire [3 : 0] s_axis_s2mm_tkeep
  .s_axis_s2mm_tvalid(axis_intf.s_axis_s2mm_tvalid),          // input wire s_axis_s2mm_tvalid
  .s_axis_s2mm_tready(axis_intf.s_axis_s2mm_tready),          // output wire s_axis_s2mm_tready
  .s_axis_s2mm_tlast(axis_intf.s_axis_s2mm_tlast),            // input wire s_axis_s2mm_tlast
  ///////////////////////       Interrupts          // /////////////////////
  .mm2s_introut(mm2s_introut),                      // output wire mm2s_introut
  .s2mm_introut(s2mm_introut),                      // output wire s2mm_introut
  .axi_dma_tstvec(axi_dma_tstvec)                   // output wire [31 : 0] axi_dma_tstvec
  );
  

  //////////////////////////////////////////////////////////////////////////////////////////////////
  //                                      AXI4 Memory Module                                      //
  //////////////////////////////////////////////////////////////////////////////////////////////////
  blk_mem_gen_0 memory (
  .rsta_busy( ),          // output wire rsta_busy
  .rstb_busy( ),          // output wire rstb_busy
  .s_aclk(axi_aclk),                // input wire s_aclk
  .s_aresetn(axi_resetn),          // input wire s_aresetn
  .s_axi_awid(          ),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr(axi_intf.awaddr),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen(axi_intf.awlen),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(axi_intf.awsize),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(axi_intf.awburst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid(axi_intf.awvalid),  // input wire s_axi_awvalid
  .s_axi_awready(axi_intf.awready),  // output wire s_axi_awready
  .s_axi_wdata(axi_intf.wdata),      // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb(axi_intf.wstrb),      // input wire [3 : 0] s_axi_wstrb
  .s_axi_wlast(axi_intf.wlast),      // input wire s_axi_wlast
  .s_axi_wvalid(axi_intf.wvalid),    // input wire s_axi_wvalid
  .s_axi_wready(axi_intf.wready),    // output wire s_axi_wready
  .s_axi_bid(             ),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp(axi_intf.bresp),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(axi_intf.bvalid),    // output wire s_axi_bvalid
  .s_axi_bready(axi_intf.bready),    // input wire s_axi_bready
  .s_axi_arid(                    ),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr(axi_intf.araddr),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen(axi_intf.arlen),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(axi_intf.arsize),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(axi_intf.arburst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid(axi_intf.arvalid),  // input wire s_axi_arvalid
  .s_axi_arready(axi_intf.arready),  // output wire s_axi_arready
  .s_axi_rid( ),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata(axi_intf.rdata),      // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp(axi_intf.rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(axi_intf.rlast),      // output wire s_axi_rlast
  .s_axi_rvalid(axi_intf.rvalid),    // output wire s_axi_rvalid
  .s_axi_rready(axi_intf.rready)    // input wire s_axi_rready
);
     
endmodule : axi_dma_10xe_tb_top

`endif