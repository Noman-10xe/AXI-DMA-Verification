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

        axi_lite_agent  axi_lite_agt;
        axis_read_agent axis_r_agt;

        `uvm_component_utils(environment)
        
        function new(string name = "environment", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

endclass : environment

function void environment::build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_lite_agt	= axi_lite_agent::type_id::create("axi_lite_agt", this);
        axis_r_agt	= axis_read_agent::type_id::create("axis_r_agt", this);
endfunction: build_phase

`endif