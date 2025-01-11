/*************************************************************************
   > File Name: axis_read_monitor.sv
   > Description: Monitor Class for Sampling Read Streams.
   > Author: Noman Rafiq
   > Modified: Dec 20, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_READ_MONITOR
`define AXIS_READ_MONITOR

`define READ_MON vif.ioReadMonitor
class axis_read_monitor extends uvm_monitor;
        
        `uvm_component_utils(axis_read_monitor);

        virtual axis_io vif;
        axis_transaction item;
        uvm_analysis_port #(axis_transaction) mm2s_read;

        //  Constructor
        function new(string name = "axis_read_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: axis_read_monitor


function void axis_read_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        mm2s_read = new("mm2s_read", this);
        if (!uvm_config_db#(virtual axis_io)::get(this, get_full_name(), "axis_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


task axis_read_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "AXIS Read Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task axis_read_monitor::collect_transactions();
        

        forever begin
                // Create Transaction
                item = axis_transaction::type_id::create("item", this);
                
                vif.wait_clks(1);
                if (`READ_MON.m_axis_mm2s_tvalid)   begin
                        if(`READ_MON.m_axis_mm2s_tready) begin
                                item.tdata      = `READ_MON.m_axis_mm2s_tdata;
                                item.tkeep      = `READ_MON.m_axis_mm2s_tkeep;
                                item.tvalid     = `READ_MON.m_axis_mm2s_tvalid;
                                item.tready     = `READ_MON.m_axis_mm2s_tready;
                                item.tlast      = `READ_MON.m_axis_mm2s_tlast;

                                // Print transaction
                                `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                                `uvm_info("", $sformatf("//                      MM2S READ Monitor                            //"), UVM_LOW)
                                `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                                `uvm_info(get_type_name(), $sformatf("Transaction Collected from AXI-Stream Read Master :\n%s",item.sprint()), UVM_LOW)
                                
                                // Boradcast to Scoreboard
                                mm2s_read.write(item);
                        end
                end
        end
endtask: collect_transactions

`endif