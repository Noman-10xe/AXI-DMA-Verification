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
  logic                                 mm2s_introut;
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
    input       mm2s_introut;

  endclocking : ioReadDriver

  clocking ioReadMonitor @(posedge axi_aclk);
    default input #0ns output #2;
    
    input       m_axis_mm2s_tdata;
    input       m_axis_mm2s_tkeep;
    input       m_axis_mm2s_tvalid;
    input       m_axis_mm2s_tready;
    input       m_axis_mm2s_tlast;
    input       mm2s_introut;

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
    ioReadDriver.m_axis_mm2s_tready   <= 1'b1;
  endtask : reset

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

  // MM2S HANDSHAKE Property
  property mm2s_handshake;
    @(posedge axi_aclk) m_axis_mm2s_tvalid |-> ##[0:$] m_axis_mm2s_tready;
    endproperty
  
    // S2MM HANDSHAKE Property
    property s2mm_handshake;
      @(posedge axi_aclk) s_axis_s2mm_tvalid |-> ##[0:6] s_axis_s2mm_tready;
    endproperty
  
    // Assert Properties
    assert property (mm2s_handshake) else
    `uvm_error("MM2S Handshake", "Assertion Failed");
    
    assert property (s2mm_handshake) else
    `uvm_error("S2MM Handshake", "Assertion Failed");

  
endinterface : axis_io

`endif