/*************************************************************************
   > File `gfn:     axi_io.sv
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


  clocking ioWriteDriver @(posedge axi_aclk);
    default input #0ns output #2;

    input       awaddr;
    input       awlen;
    input       awsize;
    input       awburst;
    input       awprot;
    input       awcache;
    input       awvalid;
    output      awready;

    input       wdata;
    input       wstrb;
    input       wlast;
    input       wvalid;
    output      wready;

    input       bready;
    output      bresp;
    output      bvalid;

endclocking : ioWriteDriver

  clocking ioMon @(posedge axi_aclk);
      default input #0ns output #2;

      input     araddr;
      input     arlen;
      input     arsize;
      input     arburst;
      input     arprot;
      input     arcache;
      input     arvalid;
      input     arready;
      input     rdata;
      input     rresp;
      input     rlast;
      input     rvalid;
      input     rready;
      input     awaddr;
      input     awlen;
      input     awsize;
      input     awburst;
      input     awprot;
      input     awcache;
      input     awvalid;
      input     awready;
      input     wdata;
      input     wstrb;
      input     wlast;
      input     wvalid;
      input     wready;
      input     bvalid;
      input     bready;
      input     bresp;
      
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


// always @(negedge axi_aclk)
// begin

// // write address must not be X or Z during address write phase
// assertWriteAddrUnknown:assert property (
  
//     ($onehot(awvalid) && $onehot(awready) |-> !$isunknown(awaddr)))
// 		else
// 		  $error({$psprintf("err_awaddr %s went to X or Z during address write phase when awvalid=1", `gfn)});

// // write data must not be X or Z during data write phase
// assertWriteDataUnknown:assert property (
  
//     ($onehot(wvalid) && $onehot(wready) |-> !$isunknown(wdata)))
// 		else
// 		  $error({$psprintf("err_wdata %s went to X or Z during data write phase when wvalid=1", `gfn)});

// // write resp must not be X or Z during resp write phase
// assertWriteRespUnKnown:assert property (
  
//     ($onehot(bvalid) && $onehot(bready) |-> !$isunknown(bresp)))
//     else
//       $error({$psprintf("err_bresp %s went to X or Z during response write phase when bvalid=1", `gfn)});

// // read address must not be X or Z during address read phase
// assertReadAddrUnKnown:assert property (
  
//     ($onehot(arvalid) && $onehot(arready) |-> !$isunknown(araddr)))
//     else
//       $error({$psprintf("err_araddr %s went to X or Z during address read phase when arvalid=1", `gfn)});

// // read data must not be X or Z during read data phase
// assertReadDataUnKnown:assert property (
  
//     ($onehot(rvalid) && $onehot(rready) |-> !$isunknown(rdata)))
//     else
//       $error({$psprintf("err_ardata %s went to X or Z during data read phase when rvalid=1", `gfn)});

// // assert each pin has value not unknown

// end

endinterface : axi_io

`endif