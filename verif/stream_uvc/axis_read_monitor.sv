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

`define MON vif.ioReadMonitor
class axis_read_monitor extends uvm_monitor;
        
        `uvm_component_utils(axis_read_monitor);

        virtual axis_io vif;
        axis_transaction item;
        axis_transaction FIFO[$];

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
        if (!uvm_config_db#(virtual axis_io)::get(this, get_full_name(), "axis_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


task axis_read_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task axis_read_monitor::collect_transactions();
        
        // Create Transaction
        item = axis_transaction::type_id::create("item", this);

        forever begin

                vif.wait_clks(2);
                item.tdata      = `MON.m_axis_mm2s_tdata;
                item.tkeep      = `MON.m_axis_mm2s_tkeep;
                item.tvalid     = `MON.m_axis_mm2s_tvalid;
                item.tready     = `MON.m_axis_mm2s_tready;
                item.tlast      = `MON.m_axis_mm2s_tlast;

                // Print transaction
                `uvm_info(get_type_name(), $sformatf("Transaction Collected from AXI-Stream Read Master :\n%s",item.sprint()), UVM_LOW)
        end
endtask: collect_transactions

`endif