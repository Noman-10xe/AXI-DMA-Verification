/*************************************************************************
   > File Name: axi_dma_tb_top.sv
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

import params_pkg::*;
// Memory Model Package
import mem_model_pkg::*;
`include "../includes/includes.sv"

// Interfaces
`include "../interfaces/clk_rst_io.sv"
`include "../interfaces/s_axi_lite_io.sv"
`include "../interfaces/axis_io.sv"

module axi_dma_tb_top;
    
  // global clock & reset signals 
  wire axi_aclk;
  wire axi_resetn;
  
  //////////////////////////////////////////
  //      Clock and Reset Interface       //
  //////////////////////////////////////////
  clk_rst_io  clk_rst_if( .axi_aclk   (axi_aclk), 
                          .axi_resetn (axi_resetn)
                        );

  ////////////////////////////////////////////////////////////
  //      Axi-Lite Interface for Register Read/Writes       //
  ////////////////////////////////////////////////////////////
  s_axi_lite_io axi_lite_intf ( .axi_aclk(axi_aclk),
                                .axi_resetn(axi_resetn) 
                              );

  ////////////////////////////////////////////////////////////
  //      Axi-Stream Interface for MM2S/S2MM Transfers      //
  ////////////////////////////////////////////////////////////
  axis_io axis_intf ( .axi_aclk(axi_aclk),
                      .axi_resetn(axi_resetn)
                    );

  ////////////////////////////////////////////////////////////
  //  Axi interface for Memory Mapped Read/Write Operations //
  ////////////////////////////////////////////////////////////
  axi_io  axi_intf ( .axi_aclk(axi_aclk),
                     .axi_resetn(axi_resetn) 
                   );

  initial begin
    fork
    run_test("slave_error_test");
    clk_rst_if.gen_clock(20);
    clk_rst_if.gen_reset(16);
    join
  end

  initial begin
    uvm_config_db #(virtual s_axi_lite_io)::set(null, "*", "axi_lite_intf", axi_lite_intf);
    uvm_config_db #(virtual axis_io)::set(null, "*", "axis_intf", axis_intf);
    uvm_config_db #(virtual axi_io)::set(null, "*", "axi_intf", axi_intf);
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

  /////////////////////////////////////
  //         DUT Instantiation       //
  /////////////////////////////////////
  `include "instantiation.sv"

endmodule : axi_dma_tb_top

`endif