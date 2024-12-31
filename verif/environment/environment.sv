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
        axis_r_agt	= axis_read_agent::type_id::create("axis_r_agt", this);
        axis_wr_agt	= axis_write_agent::type_id::create("axis_wr_agt", this);
endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
        super.build_phase(phase);
        RAL_Model.default_map.set_sequencer(axi_lite_agt.sequencer, adapter);
        RAL_Model.default_map.set_base_addr(0);
endfunction: connect_phase

`endif