/*************************************************************************
   > File Name:     axi_io.sv
   > Description:   Interface for Memory Mapped Reads & Writes
   > Author:        Noman Rafiq
   > Modified:      Dec 18, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_IO
`define AXI_IO

`timescale 1ns / 1ps

interface axi_io        #(      int ADDR_WIDTH = params_pkg::ADDR_WIDTH,
                                int DATA_WIDTH = params_pkg::DATA_WIDTH
                        )   (
                            input logic axi_aclk,
                            input logic axi_resetn
                        );

  
  ////////////////////////////////////////////////////////////////////////////////////////
  //                                     SIGNALS                                        //
  ////////////////////////////////////////////////////////////////////////////////////////
  // read address channel
  bit         [ ADDR_WIDTH-1  :       0 ]     araddr;
  bit         [ 7             :       0 ]     arlen;
  bit         [ 2             :       0 ]     arsize;
  bit         [ 1             :       0 ]     arburst;
  bit         [ 2             :       0 ]     arprot;
  bit         [ 3             :       0 ]     arcache;
  bit                                         arvalid;
  bit                                         arready;
  // read data channel
  bit         [ DATA_WIDTH-1  :       0 ]     rdata;
  bit         [ 1             :       0 ]     rresp;
  bit                                         rlast;
  bit                                         rvalid;
  bit                                         rready;
  bit                                         mm2s_prmry_reset_out_n;
  // write address channel
  bit         [ ADDR_WIDTH-1  :       0 ]     awaddr;
  bit         [ 7             :       0 ]     awlen;
  bit         [ 2             :       0 ]     awsize;
  bit         [ 1             :       0 ]     awburst;
  bit         [ 2             :       0 ]     awprot;
  bit         [ 3             :       0 ]     awcache;
  bit                                         awvalid;
  bit                                         awready;
  // write data channel
  bit         [ DATA_WIDTH-1  :       0 ]     wdata;
  bit         [ 3             :       0 ]     wstrb;
  bit                                         wlast;
  bit                                         wvalid;
  bit                                         wready;
  // write response channel
  bit         [ 1             :       0 ]     bresp;
  bit                                         bvalid;
  bit                                         bready;
  bit                                         s2mm_prmry_reset_out_n;
  
  
  clocking ioReadDriver @(posedge axi_aclk);
      default input #0ns output #2;

      input       arvalid;
      input       araddr;
      input       arlen;
      input       arsize;
      input       arburst;
      input       arprot;
      input       arcache;
      output      arready;

  endclocking : ioReadDriver

  clocking ioMon @(posedge axi_aclk);
      default input #0ns output #2;

      input bresp;
      input bvalid;
      input bready;
  endclocking : ioMon


  ///////////////////////////////////////////////////////////////
  //
  // Wait Clocks
  //
  task automatic wait_clks(input int num);
        repeat (num) @(posedge axi_aclk);
  endtask
  ///////////////////////////////////////////////////////////////
  task automatic wait_neg_clks(input int num);
        repeat (num) @(negedge axi_aclk);
  endtask

endinterface : axi_io

`endif