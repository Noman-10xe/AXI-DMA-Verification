/*************************************************************************
   > File Name: axis_write_monitor.sv
   > Description: Monitor Class for Sampling Write Streams.
   > Author: Noman Rafiq
   > Modified: Dec 21, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_WRITE_MONITOR
`define AXIS_WRITE_MONITOR

`define WRITE_MON vif.ioWriteMonitor
class axis_write_monitor extends uvm_monitor;
        
        `uvm_component_utils(axis_write_monitor);

        virtual axis_io vif;
        axis_transaction item;
        uvm_analysis_port #(axis_transaction) s2mm_write;

        //  Constructor
        function new(string name = "axis_write_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: axis_write_monitor


function void axis_write_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        s2mm_write = new("s2mm_write", this);
        if (!uvm_config_db#(virtual axis_io)::get(this, get_full_name(), "axis_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


task axis_write_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "AXIS Write Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task axis_write_monitor::collect_transactions();
        
        forever begin
                // Create Transaction
                item = axis_transaction::type_id::create("item", this);

                vif.wait_clks(1);
                item.tdata      = `WRITE_MON.s_axis_s2mm_tdata;
                item.tkeep      = `WRITE_MON.s_axis_s2mm_tkeep;
                item.tvalid     = `WRITE_MON.s_axis_s2mm_tvalid;
                item.tready     = `WRITE_MON.s_axis_s2mm_tready;
                item.tlast      = `WRITE_MON.s_axis_s2mm_tlast;
                        
                // Print transaction
                `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                `uvm_info("", $sformatf("//                      S2MM WRITE Monitor                            //"), UVM_LOW)
                `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("Transaction Collected from AXI-Stream Write Slave :\n%s",item.sprint()), UVM_HIGH)
                s2mm_write.write(item);
        end
endtask: collect_transactions

`endif