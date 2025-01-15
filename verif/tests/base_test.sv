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
class reset_test extends base_test;
        `uvm_component_utils(reset_test)

        read_status_sequence default_rd;

        function new(string name = "reset_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new
 
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass : reset_test
 
function void reset_test::build_phase(uvm_phase phase);
        super.build_phase(phase);
        default_rd     = read_status_sequence::type_id::create("default_rd", this);
endfunction: build_phase
 
task reset_test::run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
        default_rd.RAL_Model = env.RAL_Model;
        default_rd.start(env.axi_lite_agt.sequencer);
        phase.drop_objection(this);
        `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 300ns);
endtask: run_phase

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
        
        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                mm2s_enable.RAL_Model = env.RAL_Model;
                mm2s_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 1500ns);
                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        endtask: run_phase

endclass : mm2s_enable_test


////////////////////////////////////////////////////////////////////////
//                              S2MM Enable Test                      //
////////////////////////////////////////////////////////////////////////
class s2mm_enable_test extends base_test;
        `uvm_component_utils(s2mm_enable_test)
        
        s2mm_enable_sequence s2mm_enable;
        axis_wr              axis_wr_seq;

        function new(string name = "s2mm_enable_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                s2mm_enable     = s2mm_enable_sequence::type_id::create("s2mm_enable", this);
                axis_wr_seq     = axis_wr::type_id::create("axis_wr_seq", this);
                axis_wr_seq.num_trans = 32;
        endfunction: build_phase
        
        task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
                s2mm_enable.RAL_Model = env.RAL_Model;
                s2mm_enable.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_wr_seq.set_starting_phase(phase);
                axis_wr_seq.start(env.axis_wr_agt.sequencer);

                phase.phase_done.set_drain_time(this, 300ns);

                `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
        endtask: run_phase

endclass : s2mm_enable_test


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
                axis_read_seq.num_trans = axis_env_cfg.num_trans;
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
                axis_read_seq.num_trans         = axis_env_cfg.num_trans+1;
                axis_write_seq.num_trans        = axis_env_cfg.num_trans+1;
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

////////////////////////////////////////////////////////////////////////
//                       Read Introut Test                            //
////////////////////////////////////////////////////////////////////////

class read_introut_test extends base_test;
        `uvm_component_utils(read_introut_test)
        
        mm2s_custom_sequence            mm2s_short;
        axis_read                       axis_read_seq;
        clear_mm2s_introut_sequence     clear_introut_seq;

        function new(string name = "read_introut_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mm2s_short                      = mm2s_custom_sequence::type_id::create("mm2s_short", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                clear_introut_seq               = clear_mm2s_introut_sequence::type_id::create("clear_introut_seq", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                mm2s_short.RAL_Model = env.RAL_Model;
                mm2s_short.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

                phase.raise_objection(this);
                clear_introut_seq.RAL_Model = env.RAL_Model;
                clear_introut_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 100ns);

        endtask: run_phase
        
endclass : read_introut_test


////////////////////////////////////////////////////////////////////////
//                       Read Introut Test                            //
////////////////////////////////////////////////////////////////////////

class write_introut_test extends base_test;
        `uvm_component_utils(write_introut_test)
        
        s2mm_custom_sequence            s2mm_short;
        axis_wr                         axis_write_seq;
        clear_s2mm_introut_sequence     clear_introut_seq;

        function new(string name = "write_introut_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                s2mm_short                      = s2mm_custom_sequence::type_id::create("s2mm_short", this);
                axis_write_seq                  = axis_wr::type_id::create("axis_write_seq", this);
                clear_introut_seq               = clear_s2mm_introut_sequence::type_id::create("clear_introut_seq", this);
                axis_write_seq.num_trans         = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                s2mm_short.RAL_Model = env.RAL_Model;
                s2mm_short.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_write_seq.set_starting_phase(phase);
                axis_write_seq.start(env.axis_wr_agt.sequencer);

                phase.raise_objection(this);
                #700ns;
                clear_introut_seq.RAL_Model = env.RAL_Model;
                clear_introut_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 100ns);

        endtask: run_phase
        
endclass : write_introut_test

////////////////////////////////////////////////////////////////////////
// Test Name:   RS Test                                               //
// Description: The test will stop the DMA core by setting Run/Stop   //
// bit while in the middle of the DMA Operation.                      //
// Dated: Jan 13, 2025                                                //
////////////////////////////////////////////////////////////////////////

class rs_test extends base_test;
        `uvm_component_utils(rs_test)
        
        mm2s_custom_sequence            mm2s_seq;
        axis_read                       axis_read_seq;
        stop_mm2s_sequence              stop_mm2s_seq;
        mm2s_length_sequence            write_length_seq;

        function new(string name = "rs_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mm2s_seq                        = mm2s_custom_sequence::type_id::create("mm2s_seq", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                stop_mm2s_seq                   = stop_mm2s_sequence::type_id::create("stop_mm2s_seq", this);
                write_length_seq                = mm2s_length_sequence::type_id::create("write_length_seq", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                mm2s_seq.RAL_Model = env.RAL_Model;
                mm2s_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                fork
                        begin
                                axis_read_seq.set_starting_phase(phase);
                                axis_read_seq.start(env.axis_r_agt.sequencer);
                        end
                        begin
                                // Comment This block in order to check if the subsequest transfer happens when the R/S bit is not set to 0.
                                #400ns;
                                phase.raise_objection(this);
                                stop_mm2s_seq.RAL_Model = env.RAL_Model;
                                stop_mm2s_seq.start(env.axi_lite_agt.sequencer);
                                phase.drop_objection(this);
                                phase.phase_done.set_drain_time(this, 100ns);
                        end
                join

                // Write to Length Register
                phase.raise_objection(this);
                write_length_seq.RAL_Model = env.RAL_Model;
                write_length_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.num_trans = 3;
                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

        endtask: run_phase
        
endclass : rs_test


////////////////////////////////////////////////////////////////////////
// Test Name:   Soft Reset Test                                       //
// Description: The test will reset the DMA core by setting Reset bit //
// in any of the Control Registers (MM2S_DMACR/S2MM_DMACR).           //
// Dated: Jan 13, 2025                                                //
////////////////////////////////////////////////////////////////////////

class soft_reset_test extends base_test;
        `uvm_component_utils(soft_reset_test)
        
        mm2s_custom_sequence            mm2s_seq;
        axis_read                       axis_read_seq;
        reset_sequence                  soft_reset_seq;
        read_registers_sequence         read_regs;

        function new(string name = "soft_reset_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                mm2s_seq                        = mm2s_custom_sequence::type_id::create("mm2s_seq", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                soft_reset_seq                  = reset_sequence::type_id::create("soft_reset_seq", this);
                read_regs                       = read_registers_sequence::type_id::create("read_regs", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                mm2s_seq.RAL_Model = env.RAL_Model;
                mm2s_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                fork
                        begin
                                axis_read_seq.set_starting_phase(phase);
                                axis_read_seq.start(env.axis_r_agt.sequencer);
                        end
                        begin
                                #40ns;
                                phase.raise_objection(this);
                                soft_reset_seq.RAL_Model = env.RAL_Model;
                                soft_reset_seq.start(env.axi_lite_agt.sequencer);
                                phase.drop_objection(this);
                        end
                join

                phase.raise_objection(this);
                read_regs.RAL_Model = env.RAL_Model;
                read_regs.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 100ns);                

        endtask: run_phase
        
endclass : soft_reset_test


////////////////////////////////////////////////////////////////////////
// Test Name:   Halted Write Test                                     //
// Description: The test will try to write the Length Register while  //
// DMA Channels are halted.                                           //
// Dated: Jan 13, 2025                                                //
////////////////////////////////////////////////////////////////////////

class halted_write_test extends base_test;
        `uvm_component_utils(halted_write_test)
        
        read_registers_sequence         read_regs;
        mm2s_length_sequence            write_length_seq;

        function new(string name = "halted_write_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                read_regs                       = read_registers_sequence::type_id::create("read_regs", this);
                write_length_seq                = mm2s_length_sequence::type_id::create("write_length_seq", this);
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                read_regs.RAL_Model = env.RAL_Model;
                read_regs.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                phase.raise_objection(this);
                write_length_seq.RAL_Model = env.RAL_Model;
                write_length_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);
                phase.phase_done.set_drain_time(this, 100ns);

                phase.raise_objection(this);
                read_regs.RAL_Model = env.RAL_Model;
                read_regs.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

        endtask: run_phase
        
endclass : halted_write_test

////////////////////////////////////////////////////////////////////////
// Test Name:   Idle State Test                                       //
// Description: The test will read the state of the DMA while transfer//
// is running and also after the transfer has completed.              //
// Dated: Jan 13, 2025                                                //
////////////////////////////////////////////////////////////////////////

class idle_state_test extends base_test;
        `uvm_component_utils(idle_state_test)
        
        read_status_sequence    read_status;
        mm2s_custom_sequence    mm2s_custom_seq;
        axis_read               axis_read_seq;

        function new(string name = "idle_state_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                read_status             = read_status_sequence::type_id::create("read_status", this);
                mm2s_custom_seq         = mm2s_custom_sequence::type_id::create("mm2s_custom_seq", this);
                axis_read_seq           = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                mm2s_custom_seq.RAL_Model = env.RAL_Model;
                mm2s_custom_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                fork
                        begin
                                axis_read_seq.set_starting_phase(phase);
                                axis_read_seq.start(env.axis_r_agt.sequencer);
                        end
                        begin
                                #300ns;
                                phase.raise_objection(this);
                                read_status.RAL_Model = env.RAL_Model;
                                read_status.start(env.axi_lite_agt.sequencer);
                                phase.drop_objection(this);
                                phase.phase_done.set_drain_time(this, 100ns);
                        end
                join

                // Read again After the Transfer has Completed
                phase.raise_objection(this);
                read_status.RAL_Model = env.RAL_Model;
                read_status.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

        endtask: run_phase
        
endclass : idle_state_test

////////////////////////////////////////////////////////////////////////
// Test Name:   Slave Error Test                                      //
// Description: The test will read the state of the DMA while transfer//
// is running and also after the transfer has completed.              //
// Dated: Jan 13, 2025                                                //
////////////////////////////////////////////////////////////////////////

class slave_error_test extends base_test;
        `uvm_component_utils(slave_error_test)
        
        read_status_sequence    read_status;
        mm2s_SlvErr_sequence    SlvErr_seq;
        axis_read               axis_read_seq;

        function new(string name = "slave_error_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                read_status             = read_status_sequence::type_id::create("read_status", this);
                SlvErr_seq              = mm2s_SlvErr_sequence::type_id::create("SlvErr_seq", this);
                axis_read_seq           = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                SlvErr_seq.RAL_Model = env.RAL_Model;
                SlvErr_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

                // Read After the Transfer to check if the Error Interrupt was Generated
                phase.raise_objection(this);
                read_status.RAL_Model = env.RAL_Model;
                read_status.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

        endtask: run_phase
        
endclass : slave_error_test



////////////////////////////////////////////////////////////////////////
// Test Name:   Decode Error Test                                     //
// Description: The test will configure the MM2S Channel with an      //
// invalid address. When Err_IrqEn is enabled, it should generate an  //
// mm2s_introut signal.                                               //
// Dated: Jan 14, 2025                                                //
////////////////////////////////////////////////////////////////////////

class decode_error_test extends base_test;
        `uvm_component_utils(decode_error_test)
        
        read_status_sequence    read_status;
        mm2s_DecErr_sequence    DecErr_seq;
        axis_read               axis_read_seq;

        function new(string name = "decode_error_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                read_status             = read_status_sequence::type_id::create("read_status", this);
                DecErr_seq              = mm2s_DecErr_sequence::type_id::create("DecErr_seq", this);
                axis_read_seq           = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans = axis_env_cfg.num_trans;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                DecErr_seq.RAL_Model = env.RAL_Model;
                DecErr_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

                // Read After the Transfer to check if the Error Interrupt was Generated
                phase.raise_objection(this);
                #200ns;
                read_status.RAL_Model = env.RAL_Model;
                read_status.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

        endtask: run_phase
        
endclass : decode_error_test

////////////////////////////////////////////////////////////////////////
// Test Name:   4 KB Boundary Test                                    //
// Description: The test will configure the MM2S Channel with         //
// a starting address and length such that the read operation crosses //
// 4 KB boundary.                                                     //
// Dated: Jan 14, 2025                                                //
////////////////////////////////////////////////////////////////////////

class boundary_test extends base_test;
        `uvm_component_utils(boundary_test)
        
        mm2s_boundary_sequence  boundary_test_seq;
        axis_read               axis_read_seq;

        function new(string name = "boundary_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                boundary_test_seq               = mm2s_boundary_sequence::type_id::create("boundary_test_seq", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
                axis_env_cfg.SRC_ADDR           = 'hFFC;
                axis_env_cfg.DATA_LENGTH        = 128;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                boundary_test_seq.RAL_Model = env.RAL_Model;
                boundary_test_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

        endtask: run_phase
        
endclass : boundary_test


////////////////////////////////////////////////////////////////////////
// Test Name:   Data Re-Alignment Test                                //
// Description: The test will configure the MM2S Channel with         //
// a starting address that is not word-aligned.                       //
// Dated: Jan 14, 2025                                                //
////////////////////////////////////////////////////////////////////////

class data_realignment_test extends base_test;
        `uvm_component_utils(data_realignment_test)
        
        mm2s_custom_sequence    realignment_seq;
        axis_read               axis_read_seq;

        function new(string name = "data_realignment_test", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                realignment_seq                 = mm2s_custom_sequence::type_id::create("realignment_seq", this);
                axis_read_seq                   = axis_read::type_id::create("axis_read_seq", this);
                axis_read_seq.num_trans         = axis_env_cfg.num_trans;
                axis_env_cfg.scoreboard_write   = 0;
                axis_env_cfg.DATA_LENGTH        = 128;
                axis_env_cfg.SRC_ADDR           = 'h39;
        endfunction: build_phase
                
        task run_phase(uvm_phase phase);
                
                phase.raise_objection(this);
                realignment_seq.RAL_Model = env.RAL_Model;
                realignment_seq.start(env.axi_lite_agt.sequencer);
                phase.drop_objection(this);

                axis_read_seq.set_starting_phase(phase);
                axis_read_seq.start(env.axis_r_agt.sequencer);

        endtask: run_phase
        
endclass : data_realignment_test

`endif