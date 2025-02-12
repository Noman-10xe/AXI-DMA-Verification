/*************************************************************************
   > File Name:     includes.sv
   > Description:   This File contains all the include files that
   >                need to be compiled before tb_top.
   > Author:        Noman Rafiq
   > Modified:      Dec 31, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef INCLUDES
`define INCLUDES

`include "uvm_macros.svh"
import uvm_pkg::*;

// Memory Model Package
import mem_model_pkg::*;

// Configurations
`include "../configurations/axis_read_agent_config.sv"
`include "../configurations/axis_write_agent_config.sv"
`include "../configurations/environment_config.sv"

// Axi-Lite UVC
`include "../../sim/reg_transaction.sv"
`include "../../sim/reg_sequence.sv"
`include "../register_uvc/axi_lite_driver.sv"
`include "../register_uvc/axi_lite_sequencer.sv"
`include "../register_uvc/axi_lite_monitor.sv"
`include "../register_uvc/axi_lite_agent.sv"

// AXI-Stream UVC
`include "../../sim/axis_transaction.sv"
`include "../../sim/axis_sequence.sv"
`include "../stream_uvc/axis_read_driver.sv"
`include "../stream_uvc/axis_read_monitor.sv"
`include "../stream_uvc/axis_read_agent.sv"
`include "../stream_uvc/axis_write_driver.sv"
`include "../stream_uvc/axis_write_monitor.sv"
`include "../stream_uvc/axis_write_agent.sv"

// Registration Abstraction Layer (RAL Model)
`include "../ral_model/registers/mm2s_dmacr.sv"
`include "../ral_model/registers/mm2s_dmasr.sv"
`include "../ral_model/registers/mm2s_sa.sv"
`include "../ral_model/registers/mm2s_sa_msb.sv"
`include "../ral_model/registers/mm2s_length.sv"
`include "../ral_model/registers/s2mm_dmacr.sv"
`include "../ral_model/registers/s2mm_dmasr.sv"
`include "../ral_model/registers/s2mm_da.sv"
`include "../ral_model/registers/s2mm_da_msb.sv"
`include "../ral_model/registers/s2mm_length.sv"
`include "../ral_model/reg_block.sv"
`include "../ral_model/axi_lite_adapter.sv"

// AXI Components
`include "../../sim/axi_transaction.sv"
`include "../../sim/axi_sequence.sv"
`include "../mm2s_uvc/mm2s_driver.sv"
`include "../mm2s_uvc/mm2s_monitor.sv"
`include "../mm2s_uvc/axi_read_agent.sv"
`include "../axi_coverage_monitor/axi_monitor.sv"

// Coverage Model
`include "../environment/coverage_model.sv"

// Scoreboard
`include "../environment/scoreboard.sv"

// Environment and Test Library
`include "../environment/environment.sv"
`include "../test_top/testlib.sv"

`endif