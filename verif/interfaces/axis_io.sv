/*************************************************************************
   > File Name:     axis_io.sv
   > Description:   Interface for AXI4-Stream Channels
   > Author:        Noman Rafiq
   > Modified:      Dec 19, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_IO
`define AXIS_IO

`timescale 1ns / 1ps

interface axis_io      #(       int DATA_WIDTH = params_pkg::DATA_WIDTH
                        ) (
                                input logic axi_aclk,
                                input logic axi_resetn
                        );
  
  ////////////////////////////////////////////////////////////////////////////////////////
  //                                     SIGNALS                                        //
  ////////////////////////////////////////////////////////////////////////////////////////
  //    AXI4-Stream Master
  logic [ DATA_WIDTH-1  :       0 ]     m_axis_mm2s_tdata;
  logic [ 3             :       0 ]     m_axis_mm2s_tkeep;
  logic                                 m_axis_mm2s_tvalid;
  logic                                 m_axis_mm2s_tready;
  logic                                 m_axis_mm2s_tlast;
  //    AXI4-Stream slave
  logic [ DATA_WIDTH-1  :       0 ]     s_axis_s2mm_tdata;
  logic [ 3             :       0 ]     s_axis_s2mm_tkeep;
  logic                                 s_axis_s2mm_tvalid;
  logic                                 s_axis_s2mm_tready;
  logic                                 s_axis_s2mm_tlast;

  ////////////////////////////////////////////////////////////////////////////////////////
  //                             Clocking Blocks                                        //
  ////////////////////////////////////////////////////////////////////////////////////////
  
  //    Master Clocking Block
  clocking ioReadDriver @(posedge axi_aclk);
    default input #0ns output #2;
    
    input       m_axis_mm2s_tdata;
    input       m_axis_mm2s_tkeep;
    input       m_axis_mm2s_tvalid;
    output      m_axis_mm2s_tready;
    input       m_axis_mm2s_tlast;

  endclocking : ioReadDriver

  clocking ioReadMonitor @(posedge axi_aclk);
    default input #0ns output #2;
    
    input       m_axis_mm2s_tdata;
    input       m_axis_mm2s_tkeep;
    input       m_axis_mm2s_tvalid;
    input       m_axis_mm2s_tready;
    input       m_axis_mm2s_tlast;

  endclocking : ioReadMonitor


  //    Slave Clocking Block
  clocking ioWriteDriver @(posedge axi_aclk);
    default input #0ns output #2;
    
    output      s_axis_s2mm_tdata;
    output      s_axis_s2mm_tkeep;
    output      s_axis_s2mm_tvalid;
    input       s_axis_s2mm_tready;
    output      s_axis_s2mm_tlast;

  endclocking : ioWriteDriver

  clocking ioWriteMonitor @(posedge axi_aclk);
    default input #0ns output #2;
    
    input       s_axis_s2mm_tdata;
    input       s_axis_s2mm_tkeep;
    input       s_axis_s2mm_tvalid;
    input       s_axis_s2mm_tready;
    input       s_axis_s2mm_tlast;

  endclocking : ioWriteMonitor

  task reset ();
    wait(!axi_resetn);
    @(posedge axi_aclk);
    ioWriteDriver.s_axis_s2mm_tvalid  <= 1'b0;
    ioReadDriver.m_axis_mm2s_tready   <= 1'b0;
    ioWriteDriver.s_axis_s2mm_tdata   <= 0;
    wait(axi_resetn);
  endtask : reset


//   /* write_reg()
//    * Writes a Specified Value to a Register
//    * Inputs: Data and Addr
//    */
//   task write_reg (input logic [DATA_WIDTH-1:0] data, input logic [9:0] addr);
//     // Address Phase
//     ioDriv.s_axi_lite_awvalid <= 1'b1;
//     ioDriv.s_axi_lite_awaddr  <= addr;
//     wait (ioDriv.s_axi_lite_awready);     // Wait for handshake
//     ioDriv.s_axi_lite_awvalid <= 1'b0;    // Deassert valid
  
//     // Write Data Phase
//     ioDriv.s_axi_lite_wvalid <= 1'b1;
//     ioDriv.s_axi_lite_wdata  <= data;
//     wait (ioDriv.s_axi_lite_wready);      // Wait for handshake
//     ioDriv.s_axi_lite_wvalid <= 1'b0;     // Deassert valid
  
//     // Write Response Phase
//     wait (ioMon.s_axi_lite_bvalid);       // Wait for valid response
//     ioDriv.s_axi_lite_bready <= 1'b1;     // Assert ready for response
//     wait (!ioMon.s_axi_lite_bvalid);      // Wait for response to complete
//     ioDriv.s_axi_lite_bready <= 1'b0;     // Deassert ready
//   endtask : write_reg
  
  /* read_stream()
   * Reads the Value from Memory and streams it
   * Inputs: Data and Addr
   */
  // task read_stream(axis_transaction item);
  //   // Address Phase
  //   ioDriv.s_axi_lite_arvalid <= 1'b1;
  //   ioDriv.s_axi_lite_araddr  <= addr;
  //   wait (ioDriv.s_axi_lite_arready);     // Wait for handshake
  //   ioDriv.s_axi_lite_arvalid <= 1'b0;    // Deassert valid
  
  //   // Data Phase
  //   wait (ioMon.s_axi_lite_rvalid);       // Wait for valid read data
  //   ioDriv.s_axi_lite_rready <= 1'b1;     // Assert ready for response
  //   wait (!ioMon.s_axi_lite_rvalid);      // Wait for transaction to complete
  //   ioDriv.s_axi_lite_rready <= 1'b0;     // Deassert ready
  // endtask : read_stream

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

endinterface : axis_io

`endif