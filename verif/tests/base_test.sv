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

        environment             env;
        default_rd_sequence     default_rd;
        random_sequence         rand_seq;
        axis_read               axis_read_seq;
        axis_wr                 axis_write_seq;
        mm2s_enable_sequence    mm2s_enable;


        `uvm_component_utils(base_test)
        
        function new(string name = "base_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void end_of_elaboration_phase(uvm_phase phase);

        extern task configure_phase(uvm_phase phase);

        extern task main_phase(uvm_phase phase);

endclass : base_test

function void base_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        env	        = environment::type_id::create("env", this);
        default_rd      = default_rd_sequence::type_id::create("default_rd", this);
        // default_rd.set_report_verbosity_level(500);
        axis_read_seq   = axis_read::type_id::create("axis_read_seq", this);
        axis_write_seq  = axis_wr::type_id::create("axis_write_seq", this);
        mm2s_enable     = mm2s_enable_sequence::type_id::create("mm2s_enable", this);
        rand_seq       = random_sequence::type_id::create("rand_seq", this);
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction: end_of_elaboration_phase

task base_test::configure_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
        // default_rd.start(env.axi_lite_agt.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
endtask: configure_phase


task base_test::main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
        mm2s_enable.start(env.axi_lite_agt.sequencer);
        default_rd.start(env.axi_lite_agt.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
endtask: main_phase

`endif