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

class base_test extends uvm_test;

        environment             env;
        
        // Environment Configurations
        environment_config      axis_env_cfg;
        axis_read_agent_config  read_agt_cfg;
        axis_write_agent_config write_agt_cfg;

        `uvm_component_utils(base_test)
        
        function new(string name = "base_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : base_test

function void base_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        env	        = environment::type_id::create("env", this);
        
        // Configuraton Object
        axis_env_cfg                    = environment_config::type_id::create("axis_env_cfg");
        read_agt_cfg                    = axis_read_agent_config::type_id::create("read_agt_cfg");
        write_agt_cfg                   = axis_write_agent_config::type_id::create("write_agt_cfg");
        axis_env_cfg.read_agt_cfg       = read_agt_cfg;
        axis_env_cfg.write_agt_cfg      = write_agt_cfg;
        
        // Set Configuration
        uvm_config_db #(environment_config)::set(this, "*", "env_cfg", axis_env_cfg);
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
endfunction: end_of_elaboration_phase


////////////////////////////////////////////////////////////////////////
//                            Reset Test                              //
////////////////////////////////////////////////////////////////////////
// class reset_test extends base_test;
//         `uvm_component_utils(reset_test)
        
//         default_rd_sequence     default_rd;

//         function new(string name = "reset_test", uvm_component parent);
//                 super.new(name, parent);
//         endfunction : new

//         extern function void build_phase(uvm_phase phase);
//         extern task main_phase(uvm_phase phase);
// endclass : reset_test

// function void reset_test::build_phase(uvm_phase phase);
//         super.build_phase(phase);
//         default_rd     = default_rd_sequence::type_id::create("default_rd", this);
// endfunction: build_phase

// task reset_test::main_phase(uvm_phase phase);
//         phase.raise_objection(this);
//         `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
//         default_rd.start(env.axi_lite_agt.sequencer);
//         #1000ns;
//         phase.drop_objection(this);
//         `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
// endtask: main_phase

////////////////////////////////////////////////////////////////////////
//                              MM2S Enable Test                      //
////////////////////////////////////////////////////////////////////////
class mm2s_enable_test extends base_test;
        `uvm_component_utils(mm2s_enable_test)
        
        mm2s_enable_sequence mm2s_enable;

        function new(string name = "mm2s_enable_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mm2s_enable     = mm2s_enable_sequence::type_id::create("mm2s_enable", this);
        endfunction: build_phase
        
        task configure_phase(uvm_phase phase);
                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                mm2s_enable.RAL_Model = env.RAL_Model;
                mm2s_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 1500ns);
                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        endtask: configure_phase

endclass : mm2s_enable_test

////////////////////////////////////////////////////////////////////////
//                            MM2S_DMACR Read                         //
////////////////////////////////////////////////////////////////////////
class mm2s_dmacr_test extends base_test;
        `uvm_component_utils(mm2s_dmacr_test)
        
        mm2s_dmacr_sequence  MM2S_DMACR_rd;

        function new(string name = "mm2s_dmacr_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);
        extern task main_phase(uvm_phase phase);
endclass : mm2s_dmacr_test

function void mm2s_dmacr_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        MM2S_DMACR_rd     = mm2s_dmacr_sequence::type_id::create("MM2S_DMACR_rd", this);
endfunction: build_phase

task mm2s_dmacr_test::main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
        MM2S_DMACR_rd.RAL_Model = env.RAL_Model;
        MM2S_DMACR_rd.start(env.axi_lite_agt.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
endtask: main_phase

////////////////////////////////////////////////////////////////////////
//                      AXI4 to AXI-Stream Read Test                  //
////////////////////////////////////////////////////////////////////////
class read_test extends base_test;
        `uvm_component_utils(read_test)
        
        mm2s_enable_sequence  mm2s_enable;
        axis_read             axis_read_seq;

        function new(string name = "read_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mm2s_enable     = mm2s_enable_sequence::type_id::create("mm2s_enable", this);
                axis_read_seq   = axis_read::type_id::create("axis_read_seq", this);
        endfunction: build_phase
        
        task run_phase(uvm_phase phase);

                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                mm2s_enable.RAL_Model = env.RAL_Model;
                mm2s_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)

                axis_read_seq.set_starting_phase(phase); 
                axis_read_seq.start(env.axis_r_agt.sequencer);
        endtask: run_phase

endclass : read_test

////////////////////////////////////////////////////////////////////////
//                  AXI-Stream to AXI4 to Write Test                  //
////////////////////////////////////////////////////////////////////////

class write_test extends base_test;
        `uvm_component_utils(write_test)
        
        s2mm_enable_sequence    s2mm_enable;
        axis_wr                 axis_write_seq;

        function new(string name = "write_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                s2mm_enable     = s2mm_enable_sequence::type_id::create("s2mm_enable", this);
                axis_write_seq   = axis_wr::type_id::create("axis_write_seq", this);
        endfunction: build_phase
        
        task configure_phase(uvm_phase phase);
                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                s2mm_enable.RAL_Model = env.RAL_Model;
                s2mm_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        endtask: configure_phase
        
        task main_phase(uvm_phase phase);
                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                axis_write_seq.start(env.axis_wr_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 700ns);
                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        endtask: main_phase

endclass : write_test


////////////////////////////////////////////////////////////////////////
//                      Read After Write (RAW) Test                   //
////////////////////////////////////////////////////////////////////////

class raw_test extends base_test;
        `uvm_component_utils(raw_test)
        
        s2mm_enable_sequence    s2mm_enable;
        axis_wr                 axis_write_seq;
        mm2s_enable_sequence    mm2s_enable;
        axis_read               axis_read_seq;

        function new(string name = "raw_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                s2mm_enable                     = s2mm_enable_sequence::type_id::create("s2mm_enable", this);
                axis_write_seq                  = axis_wr::type_id::create("axis_write_seq", this);
                mm2s_enable                     = mm2s_enable_sequence::type_id::create("mm2s_enable", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
                axis_write_seq.num_trans        = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);

                phase.raise_objection(this);
                s2mm_enable.RAL_Model = env.RAL_Model;
                s2mm_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_write_seq.set_starting_phase(phase);
                axis_write_seq.start(env.axis_wr_agt.sequencer);
                
                phase.raise_objection(this);
                mm2s_enable.RAL_Model = env.RAL_Model;
                mm2s_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

        endtask: run_phase

endclass : raw_test

`endif