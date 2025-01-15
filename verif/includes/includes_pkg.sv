/*************************************************************************
   > File Name:     includes_pkg.sv
   > Description:   This Package File contains all the include files that
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

package includes_pkg;
        `include "uvm_macros.svh"
        import uvm_pkg::*;
        
        // Axi-Lite UVC
        `include "../register_uvc/reg_transaction.sv"
        `include "../register_uvc/reg_sequence.sv"
        `include "../register_uvc/axi_lite_driver.sv"
        `include "../register_uvc/axi_lite_sequencer.sv"
        `include "../register_uvc/axi_lite_monitor.sv"
        `include "../register_uvc/axi_lite_agent.sv"
        // AXI-Stream UVC
        `include "../stream_uvc/axis_transaction.sv"
        `include "../stream_uvc/axis_transaction.sv"
        `include "../stream_uvc/axis_sequence.sv"
        `include "../stream_uvc/axis_read_driver.sv"
        `include "../stream_uvc/axis_read_monitor.sv"
        `include "../stream_uvc/axis_read_agent.sv"
        `include "../stream_uvc/axis_write_driver.sv"
        `include "../stream_uvc/axis_write_monitor.sv"
        `include "../stream_uvc/axis_write_agent.sv"
        `include "../stream_uvc/virtual_sequencer.sv"
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
        // Write Response Agent
        `include "../mm2s_uvc/axi_transaction.sv"
        `include "../s2mm_uvc/s2mm_monitor.sv"
        `include "../s2mm_uvc/s2mm_agent.sv"
        // Memory Model Package
        import mem_model_pkg::*;
        // Scoreboard
        `include "../environment/scoreboard.sv"
        // Configurations
        `include "../configurations/axis_read_agent_config.sv"
        `include "../configurations/axis_write_agent_config.sv"
        `include "../configurations/environment_config.sv"
        `include "../configurations/sequence_config.sv"
        // Environment and Test Library
        `include "../environment/environment.sv"
        `include "../tests/virtual_sequence.sv"
        `include "../tests/base_test.sv"

endpackage : includes_pkg

`endif