/*************************************************************************
   > File Name: axi_monitor.sv
   > Description: Monitor Class for Sampling Signals from AXI4 Interface.
   > Author: Noman Rafiq
   > Modified: Dec 26, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_MONITOR
`define AXI_MONITOR

`define AXI_MON vif.ioMon
class axi_monitor extends uvm_monitor;
        
        `uvm_component_utils(axi_monitor);

        // Get Interface
        virtual axi_io vif;

        axi_transaction item;

        uvm_analysis_port #(axi_transaction) ap;

        //  Constructor
        function new(string name = "axi_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: axi_monitor


function void axi_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_io)::get(this, get_full_name(), "axi_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
        ap = new("ap", this);
endfunction: build_phase


task axi_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "AXI Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task axi_monitor::collect_transactions();
        
        // Create Transaction
        item = axi_transaction::type_id::create("item", this);

        forever begin

                vif.wait_clks(1);
                item.araddr             = `AXI_MON.araddr; 
                item.arlen              = `AXI_MON.arlen;
                item.arsize             = `AXI_MON.arsize;
                item.arburst            = `AXI_MON.arburst;
                item.arprot             = `AXI_MON.arprot;
                item.arcache            = `AXI_MON.arcache;
                item.arvalid            = `AXI_MON.arvalid;
                item.arready            = `AXI_MON.arready;
                item.rdata              = `AXI_MON.rdata;
                item.rresp              = `AXI_MON.rresp;
                item.rlast              = `AXI_MON.rlast;
                item.rvalid             = `AXI_MON.rvalid;
                item.rready             = `AXI_MON.rready;
                item.awaddr             = `AXI_MON.awaddr;
                item.awlen              = `AXI_MON.awlen;
                item.awsize             = `AXI_MON.awsize;
                item.awburst            = `AXI_MON.awburst;
                item.awprot             = `AXI_MON.awprot;
                item.awcache            = `AXI_MON.awcache;
                item.awvalid            = `AXI_MON.awvalid;
                item.awready            = `AXI_MON.awready;
                item.wdata              = `AXI_MON.wdata;
                item.wstrb              = `AXI_MON.wstrb;
                item.wlast              = `AXI_MON.wlast;
                item.wvalid             = `AXI_MON.wvalid;
                item.wready             = `AXI_MON.wready;
                item.bvalid             = `AXI_MON.bvalid;
                item.bready             = `AXI_MON.bready;
                item.bresp              = `AXI_MON.bresp;
                item.s2mm_introut       = `AXI_MON.s2mm_introut;

                ap.write(item);

                // Print transaction
                `uvm_info(get_type_name(), $sformatf("Transaction Collected :\n%s",item.sprint()), UVM_HIGH)
        end
endtask: collect_transactions

`endif