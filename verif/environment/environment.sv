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
        s2mm_agent              resp_agt;
        scoreboard              sco;
        environment_config      env_cfg;

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
        resp_agt        = s2mm_agent::type_id::create("resp_agt", this);
        
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
        sco             = scoreboard::type_id::create("sco", this);
        end
endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
        
        super.connect_phase(phase);

        RAL_Model.default_map.set_sequencer(axi_lite_agt.sequencer, adapter);
        RAL_Model.default_map.set_base_addr(0);

        resp_agt.monitor.response_port.connect(sco.resp_export);

        // Connect Analysis Ports
        if (env_cfg.has_axis_read_agent && env_cfg.has_scoreboard) begin
        axis_r_agt.monitor.mm2s_read.connect(sco.read_export);
        end

        if (env_cfg.has_axis_write_agent && env_cfg.has_scoreboard) begin
        axis_wr_agt.monitor.s2mm_write.connect(sco.write_export);
        end
endfunction: connect_phase

`endif