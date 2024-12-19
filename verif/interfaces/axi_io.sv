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
  logic         [ ADDR_WIDTH-1  :       0 ]     m_axi_mm2s_araddr;
  logic         [ 7             :       0 ]     m_axi_mm2s_arlen;
  logic         [ 2             :       0 ]     m_axi_mm2s_arsize;
  logic         [ 1             :       0 ]     m_axi_mm2s_arburst;
  logic         [ 2             :       0 ]     m_axi_mm2s_arprot;
  logic         [ 3             :       0 ]     m_axi_mm2s_arcache;
  logic                                         m_axi_mm2s_arvalid;
  logic                                         m_axi_mm2s_arready;
  // read data channel
  logic         [ DATA_WIDTH-1  :       0 ]     m_axi_mm2s_rdata;
  logic         [ 1             :       0 ]     m_axi_mm2s_rresp;
  logic                                         m_axi_mm2s_rlast;
  logic                                         m_axi_mm2s_rvalid;
  logic                                         m_axi_mm2s_rready;
  logic                                         mm2s_prmry_reset_out_n;
  // write address channel
  logic         [ ADDR_WIDTH-1  :       0 ]     m_axi_s2mm_awaddr;
  logic         [ 7             :       0 ]     m_axi_s2mm_awlen;
  logic         [ 2             :       0 ]     m_axi_s2mm_awsize;
  logic         [ 1             :       0 ]     m_axi_s2mm_awburst;
  logic         [ 2             :       0 ]     m_axi_s2mm_awprot;
  logic         [ 3             :       0 ]     m_axi_s2mm_awcache;
  logic                                         m_axi_s2mm_awvalid;
  logic                                         m_axi_s2mm_awready;
  // write data channel
  logic         [ DATA_WIDTH-1  :       0 ]     m_axi_s2mm_wdata;
  logic         [ 3             :       0 ]     m_axi_s2mm_wstrb;
  logic                                         m_axi_s2mm_wlast;
  logic                                         m_axi_s2mm_wvalid;
  logic                                         m_axi_s2mm_wready;
  // write response channel
  logic         [ 1             :       0 ]     m_axi_s2mm_bresp;
  logic                                         m_axi_s2mm_bvalid;
  logic                                         m_axi_s2mm_bready;
  logic                                         s2mm_prmry_reset_out_n;

  ////////////////////////////////////////////////////////////////////////////////////////
  //                             Clocking Blocks                                        //
  ////////////////////////////////////////////////////////////////////////////////////////

  // 1. Read Address Channel
  clocking ioDriv @(posedge axi_aclk);
        default input #0ns output #2;
        // Read Address Channel
        input           m_axi_mm2s_araddr; 
        input           m_axi_mm2s_arlen;
        input           m_axi_mm2s_arsize;
        input           m_axi_mm2s_arburst;
        input           m_axi_mm2s_arprot;
        input           m_axi_mm2s_arcache;
        input           m_axi_mm2s_arvalid;
        output          m_axi_mm2s_arready;

        // Read Data Channel
        output          m_axi_mm2s_rdata;
        output          m_axi_mm2s_rresp;
        output          m_axi_mm2s_rlast;
        output          m_axi_mm2s_rvalid;
        input           m_axi_mm2s_rready;
        input           mm2s_prmry_reset_out_n;

        // Write Address Channel
        input           m_axi_s2mm_awaddr;
        input           m_axi_s2mm_awlen;
        input           m_axi_s2mm_awsize;
        input           m_axi_s2mm_awburst;
        input           m_axi_s2mm_awprot;
        input           m_axi_s2mm_awcache;
        input           m_axi_s2mm_awvalid;
        output          m_axi_s2mm_awready;

        // Write Data Channel
        input           m_axi_s2mm_wdata;
        input           m_axi_s2mm_wstrb;
        input           m_axi_s2mm_wlast;
        input           m_axi_s2mm_wvalid;
        output          m_axi_s2mm_wready;

        // Write Response Channel
        output          m_axi_s2mm_bresp;
        output          m_axi_s2mm_bvalid;
        output          m_axi_s2mm_bready;
        input           s2mm_prmry_reset_out_n;
  endclocking : ioDriv

  // Monitor Clocking Block
  clocking ioMon @(posedge axi_aclk);
    default input #0ns output #2;
    
    // Address channel
    input         s_axi_lite_awvalid;
    input         s_axi_lite_awaddr;
    input         s_axi_lite_awready;
    // Write Data Channel
    input         s_axi_lite_wvalid;
    input         s_axi_lite_wdata;
    input         s_axi_lite_wready;
    // Write Response Channel
    input         s_axi_lite_bready;
    input         s_axi_lite_bresp;
    input         s_axi_lite_bvalid;
    // Read Address Channel
    input         s_axi_lite_arvalid;
    input         s_axi_lite_araddr;
    input         s_axi_lite_arready;
    // Read Data Channel
    input         s_axi_lite_rready;    
    input         s_axi_lite_rvalid;
    input         s_axi_lite_rdata;
    input         s_axi_lite_rresp;
  endclocking : ioMon


  /* write_reg()
   * Writes a Specified Value to a Register
   * Inputs: Data and Addr
   */
  task write_reg (input logic [DATA_WIDTH-1:0] data, input logic [9:0] addr);
    // Address Phase
    ioDriv.s_axi_lite_awvalid <= 1'b1;
    ioDriv.s_axi_lite_awaddr  <= addr;
    wait (ioDriv.s_axi_lite_awready);     // Wait for handshake
    ioDriv.s_axi_lite_awvalid <= 1'b0;    // Deassert valid
  
    // Write Data Phase
    ioDriv.s_axi_lite_wvalid <= 1'b1;
    ioDriv.s_axi_lite_wdata  <= data;
    wait (ioDriv.s_axi_lite_wready);      // Wait for handshake
    ioDriv.s_axi_lite_wvalid <= 1'b0;     // Deassert valid
  
    // Write Response Phase
    wait (ioMon.s_axi_lite_bvalid);       // Wait for valid response
    ioDriv.s_axi_lite_bready <= 1'b1;     // Assert ready for response
    wait (!ioMon.s_axi_lite_bvalid);      // Wait for response to complete
    ioDriv.s_axi_lite_bready <= 1'b0;     // Deassert ready
  endtask : write_reg
  
  /* read_reg()
   * Reads the Value from a Register
   * Inputs: Data and Addr
   */
  task read_reg(input logic [9:0] addr);
    // Address Phase
    ioDriv.s_axi_lite_arvalid <= 1'b1;
    ioDriv.s_axi_lite_araddr  <= addr;
    wait (ioDriv.s_axi_lite_arready);     // Wait for handshake
    ioDriv.s_axi_lite_arvalid <= 1'b0;    // Deassert valid
  
    // Data Phase
    wait (ioMon.s_axi_lite_rvalid);       // Wait for valid read data
    ioDriv.s_axi_lite_rready <= 1'b1;     // Assert ready for response
    wait (!ioMon.s_axi_lite_rvalid);      // Wait for transaction to complete
    ioDriv.s_axi_lite_rready <= 1'b0;     // Deassert ready
  endtask : read_reg

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