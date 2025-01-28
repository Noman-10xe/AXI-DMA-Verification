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
      output      rdata;
      output      rresp;
      output      rlast;
      output      rvalid;
      input       rready;
      output      mm2s_prmry_reset_out_n;

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

  /////////////////////////////////////////////////////////////
  //                        Assertions                       //
  /////////////////////////////////////////////////////////////

  // Property: Ensure AWADDR is not X or Z during address write phase
  property write_address_not_unknown;
    @(posedge axi_aclk) ($onehot(awvalid) && $onehot(awready) |-> !$isunknown(awaddr));
  endproperty
  
  // Property: Ensure WDATA is not X or Z during data write phase
  property write_data_not_unknown;
    @(posedge axi_aclk) ($onehot(wvalid) && $onehot(wready) |-> !$isunknown(wdata));
  endproperty
  
  // Property: Ensure BRESP is not X or Z during response write phase
  property write_response_not_unknown;
    @(posedge axi_aclk) ($onehot(bvalid) && $onehot(bready) |-> !$isunknown(bresp));
  endproperty
  
  // Property: Ensure ARADDR is not X or Z during address read phase
  property read_address_not_unknown;
    @(posedge axi_aclk) ($onehot(arvalid) && $onehot(arready) |-> !$isunknown(araddr));
  endproperty
  
  // Property: Ensure RDATA is not X or Z during read data phase
  property read_data_not_unknown;
    @(posedge axi_aclk) ($onehot(rvalid) && $onehot(rready) |-> !$isunknown(rdata));
  endproperty

  // Property: ARREADY should be asserted within 16 cycles when ARVALID is high
  property read_handshake;
    @(posedge axi_aclk) $onehot(arvalid) |-> ##[0:31] arready;
  endproperty

  // Property: AWREADY should be asserted within a few cycles when AWVALID is high
  property write_handshake;
    @(posedge axi_aclk) awvalid |-> ##[0:15] awready;
  endproperty
  
  // Property: Burst length for ARLEN and AWLEN should not exceed 15
  property burst_length_check;
    @(posedge axi_aclk) (arvalid | awvalid) |-> (arlen <= 8'hF && awlen <= 8'hF);
  endproperty
  
  // Property: RLAST should be asserted at the end of the read burst
  property read_last_check;
    @(posedge axi_aclk) (rvalid && rready) |-> ##[0:$] rlast;
  endproperty
  
  // Property: WLAST should be asserted at the end of the write burst
  property write_last_check;
    @(posedge axi_aclk) (wvalid && wready) |-> ##[0:$] wlast;
  endproperty
  
  // Property: All valid signals should be de-asserted during reset
  property reset_signal_check;
    @(posedge axi_aclk) !axi_resetn |-> 
    (arvalid == 0 && awvalid == 0 && wvalid == 0 && rvalid == 0 && bvalid == 0);
  endproperty  
  
  assert property (write_address_not_unknown)
  else `uvm_error("WRITE_ADDRESS_UNKNOWN", "AWADDR went to X or Z during address write phase when AWVALID=1");
  
  assert property (write_data_not_unknown)
  else `uvm_error("WRITE_DATA_UNKNOWN", "WDATA went to X or Z during data write phase when WVALID=1");
  
  assert property (write_response_not_unknown)
  else `uvm_error("WRITE_RESPONSE_UNKNOWN", "BRESP went to X or Z during response write phase when BVALID=1");
  
  assert property (read_address_not_unknown)
  else `uvm_error("READ_ADDRESS_UNKNOWN", "ARADDR went to X or Z during address read phase when ARVALID=1");
  
  assert property (read_data_not_unknown)
  else `uvm_error("READ_DATA_UNKNOWN", "RDATA went to X or Z during data read phase when RVALID=1");
  
  assert property (reset_signal_check)
  else `uvm_error("RESET_CHECK", "Signals not reset properly during reset phase.");
  
  assert property (read_handshake)
  else `uvm_error("READ_HANDSHAKE", "ARREADY should be asserted within 16 cycles when ARVALID is high.");
  
  assert property (write_handshake)
  else `uvm_error("WRITE_HANDSHAKE", "AWREADY should be asserted within 3 cycles when AWVALID is high.");
  
  assert property (burst_length_check)
  else `uvm_error("BURST_LENGTH", "Burst length out of bounds. ARLEN or AWLEN exceeds 15.");
  
  assert property (read_last_check)
  else `uvm_error("READ_LAST", "RLAST not asserted at the end of the read burst.");
  
  assert property (write_last_check)
  else `uvm_error("WRITE_LAST", "WLAST not asserted at the end of the write burst.");

endinterface : axi_io

`endif