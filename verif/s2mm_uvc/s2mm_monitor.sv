/*************************************************************************
   > File Name: s2mm_monitor.sv
   > Description: Monitor Class for Sampling Sequences from AXI4 Interface.
   > Author: Noman Rafiq
   > Modified: Dec 26, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef S2MM_MONITOR
`define S2MM_MONITOR

`define S2MM_MON vif.ioMon
class s2mm_monitor extends uvm_monitor;
        
        `uvm_component_utils(s2mm_monitor);

        // Get Interface
        virtual axi_io vif;

        axi_transaction item;
        uvm_analysis_port #(axi_transaction) response_port;

        //  Constructor
        function new(string name = "s2mm_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: s2mm_monitor


function void s2mm_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_io)::get(this, get_full_name(), "axi_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
        response_port = new("response_port", this);
endfunction: build_phase


task s2mm_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "S2MM Write Response Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task s2mm_monitor::collect_transactions();

        forever begin

                // Create Transaction
                item = axi_transaction::type_id::create("item", this);
                
                vif.wait_clks(1);
                if (`S2MM_MON.bvalid)   begin
                        if(`S2MM_MON.bready) begin
                        item.bresp      = `S2MM_MON.bresp;
                        item.bvalid     = `S2MM_MON.bvalid;
                        item.bready     = `S2MM_MON.bready;
                                
                        // Print transaction
                        `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                        `uvm_info("", $sformatf("//                      S2MM Response Monitor                        //"), UVM_LOW)
                        `uvm_info("", $sformatf("///////////////////////////////////////////////////////////////////////"), UVM_LOW)
                        `uvm_info(get_type_name(), $sformatf("Transaction Collected from AXI-Stream Write Slave :\n%s",item.sprint()), UVM_HIGH)
                        response_port.write(item);
                        end
                end
        end
endtask: collect_transactions

`endif