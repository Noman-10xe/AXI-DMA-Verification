/*************************************************************************
   > File Name: base_test.sv
   > Description: Base Test Class
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef BASE_TEST
`define BASE_TEST

class base_test extends uvm_agent;

        environment env;
        read_sequence seq;

        `uvm_component_utils(base_test)
        
        function new(string name = "base_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void end_of_elaboration_phase(uvm_phase phase);

        extern task run_phase(uvm_phase phase);

endclass : base_test

function void base_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        env	= environment::type_id::create("env", this);
        seq	= read_sequence::type_id::create("seq", this);
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction: end_of_elaboration_phase

task base_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
        seq.start(env.axi_lite_agt.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
endtask: run_phase

`endif