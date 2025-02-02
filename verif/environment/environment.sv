/*************************************************************************
   > File Name: environment.sv
   > Description: Environment Class
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef ENVIRONMENT
`define ENVIRONMENT

class environment extends uvm_env;

        axi_lite_agent          axi_lite_agt;
        reg_block               RAL_Model;
        axi_lite_adapter        adapter;
        axis_read_agent         axis_r_agt;
        axis_write_agent        axis_wr_agt;
        
        `ifdef ERROR_RESPONSE_TEST
        mm2s_agent              axi_r_agt;
        `endif

        axi_monitor             axi_mon;
        scoreboard              sco;
        environment_config      env_cfg;

        // Coverage 
        axi_lite_coverage       axi_lite_cov;
        axis_read_coverage      axis_read_cov;
        axis_write_coverage     axis_write_cov;
        s2mm_introut_coverage   s2mm_introut_cov;
        
        `uvm_component_utils(environment) 
        
        function new(string name = "environment", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass : environment

function void environment::build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_lite_agt	= axi_lite_agent::type_id::create("axi_lite_agt", this); 
        RAL_Model	= reg_block::type_id::create("RAL_Model", this);
        RAL_Model.build();
        adapter         = axi_lite_adapter::type_id::create("adapter", this);
        axi_mon	        = axi_monitor::type_id::create("axi_mon", this);

        `ifdef ERROR_RESPONSE_TEST
        axi_r_agt       = mm2s_agent::type_id::create("axi_r_agt", this);
        `endif
          
        // Environment Configuration
        if (!uvm_config_db#(environment_config)::get(this, get_full_name(), "env_cfg", env_cfg))
        `uvm_fatal("NOCONFIG",{"Environment Configurations must be set for: ",get_full_name()});

        if (env_cfg.has_axis_read_agent) begin
                
                // Set Configuration Object for Read Agent
                uvm_config_db#(axis_read_agent_config)::set(this, "axis_r_agt*", "agt_cfg", env_cfg.read_agt_cfg);
                axis_r_agt	= axis_read_agent::type_id::create("axis_r_agt", this);
        
        end

        if (env_cfg.has_axis_write_agent) begin

                // Set Configuration Object for Writete Agent
                uvm_config_db#(axis_write_agent_config)::set(this, "axis_wr_agt*", "agt_cfg", env_cfg.write_agt_cfg);
                axis_wr_agt	= axis_write_agent::type_id::create("axis_wr_agt", this);
        end

        if (env_cfg.has_scoreboard) begin
                sco     = scoreboard::type_id::create("sco", this);
        end

        if (env_cfg.has_functional_cov) begin
                axi_lite_cov            = axi_lite_coverage::type_id::create("axi_lite_cov", this);
                axis_read_cov           = axis_read_coverage::type_id::create("axis_read_cov", this);
                axis_write_cov          = axis_write_coverage::type_id::create("axis_write_cov", this);
                s2mm_introut_cov        = s2mm_introut_coverage::type_id::create("s2mm_introut_cov", this);
        end

endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
        
        super.connect_phase(phase);

        RAL_Model.default_map.set_sequencer(axi_lite_agt.sequencer, adapter);
        RAL_Model.default_map.set_base_addr(0);

        ///////////////////////////////////////////////////////////////
        //              Connect Analysis Ports to Scoreboard         //
        ///////////////////////////////////////////////////////////////

        if (env_cfg.has_scoreboard) begin
                
                if (env_cfg.has_axis_read_agent) begin
                axis_r_agt.monitor.mm2s_read.connect(sco.read_export);
                end
        
                if (env_cfg.has_axis_write_agent) begin
                axis_wr_agt.monitor.s2mm_write.connect(sco.write_export);
                end

                // AXI Monitor
                axi_mon.ap.connect(sco.axi_export);
        end

        ///////////////////////////////////////////////////////////////
        //             Connect Monitors to Coverage Model            //
        ///////////////////////////////////////////////////////////////

        if (env_cfg.has_functional_cov) begin
                
                // // Stream Write Agent
                if (env_cfg.has_axis_write_agent) begin
                        axis_wr_agt.monitor.s2mm_write.connect(axis_write_cov.analysis_export);
                end

                // Stream Read Agent
                if (env_cfg.has_axis_read_agent) begin
                        axis_r_agt.monitor.mm2s_read.connect(axis_read_cov.analysis_export);
                end

                // Axi Lite Agent
                axi_lite_agt.monitor.ap.connect(axi_lite_cov.analysis_export);

                // Axi Monitor
                axi_mon.ap.connect(s2mm_introut_cov.analysis_export);
        end

endfunction: connect_phase

`endif