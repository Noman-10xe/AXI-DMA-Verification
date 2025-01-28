/*************************************************************************
   > File Name: mm2s_monitor.sv
   > Description: Monitor Class for Sampling Sequences from AXI4 Interface.
   > Author: Noman Rafiq
   > Modified: Dec 26, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef MM2S_MONITOR
`define MM2S_MONITOR

`define MM2S_MON vif.ioMon
class mm2s_monitor extends uvm_monitor;
        
        `uvm_component_utils(mm2s_monitor);

        // Get Interface
        virtual axi_io vif;

        axi_transaction item;

        //  Constructor
        function new(string name = "mm2s_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: mm2s_monitor


function void mm2s_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_io)::get(this, get_full_name(), "axi_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


task mm2s_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "MM2S Read Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task mm2s_monitor::collect_transactions();
        
        // Create Transaction
        item = axi_transaction::type_id::create("item", this);

        forever begin
                vif.wait_clks(1);
                item.araddr                     = `MM2S_MON.araddr; 
                item.arlen                      = `MM2S_MON.arlen;
                item.arsize                     = `MM2S_MON.arsize;
                item.arburst                    = `MM2S_MON.arburst;
                item.arprot                     = `MM2S_MON.arprot;
                item.arcache                    = `MM2S_MON.arcache;
                item.arvalid                    = `MM2S_MON.arvalid;
                item.arready                    = `MM2S_MON.arready;
                item.rdata                      = `MM2S_MON.rdata;
                item.rresp                      = `MM2S_MON.rresp;
                item.rlast                      = `MM2S_MON.rlast;
                item.rvalid                     = `MM2S_MON.rvalid;
                item.rready                     = `MM2S_MON.rready;
                item.awaddr                     = `MM2S_MON.awaddr;
                item.awlen                      = `MM2S_MON.awlen;
                item.awsize                     = `MM2S_MON.awsize;
                item.awburst                    = `MM2S_MON.awburst;
                item.awprot                     = `MM2S_MON.awprot;
                item.awcache                    = `MM2S_MON.awcache;
                item.awvalid                    = `MM2S_MON.awvalid;
                item.awready                    = `MM2S_MON.awready;
                item.wdata                      = `MM2S_MON.wdata;
                item.wstrb                      = `MM2S_MON.wstrb;
                item.wlast                      = `MM2S_MON.wlast;
                item.wvalid                     = `MM2S_MON.wvalid;                
                item.wready                     = `MM2S_MON.wready;
                item.bvalid                     = `MM2S_MON.bvalid;
                item.bready                     = `MM2S_MON.bready;
                item.bresp                      = `MM2S_MON.bresp;
                
                // Print transaction
                `uvm_info(get_type_name(), $sformatf("Transaction Collected :\n%s",item.sprint()), UVM_HIGH)
        end
endtask: collect_transactions

`endif