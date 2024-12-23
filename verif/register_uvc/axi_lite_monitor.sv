/*************************************************************************
   > File Name: axi_lite_monitor.sv
   > Description: Monitor Class for Sampling Sequences from AXI4-LITE Interface.
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_LITE_MONITOR
`define AXI_LITE_MONITOR

`define MON vif.ioMon
class axi_lite_monitor extends uvm_monitor;
        
        `uvm_component_utils(axi_lite_monitor);

        // Get Interface
        virtual s_axi_lite_io vif;

        reg_transaction item;

        //  Constructor
        function new(string name = "axi_lite_monitor", uvm_component parent);
                super.new(name, parent);
        endfunction: new

        extern function void build_phase(uvm_phase phase);
        
        extern task run_phase(uvm_phase phase);

        extern task collect_transactions();

endclass: axi_lite_monitor


function void axi_lite_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual s_axi_lite_io)::get(this, get_full_name(), "axi_lite_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase


task axi_lite_monitor::run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "Monitor Started", UVM_NONE)
        collect_transactions();
endtask: run_phase

task axi_lite_monitor::collect_transactions();
        
        // Create Transaction
        item = reg_transaction::type_id::create("item", this);

        forever begin
                vif.wait_clks(3);
                item.s_axi_lite_awvalid         <= `MON.s_axi_lite_awvalid;
                item.s_axi_lite_awaddr          <= `MON.s_axi_lite_awaddr;
                item.s_axi_lite_awready         <= `MON.s_axi_lite_awready;
                item.s_axi_lite_wvalid          <= `MON.s_axi_lite_wvalid;
                item.s_axi_lite_wdata           <= `MON.s_axi_lite_wdata;
                item.s_axi_lite_wready          <= `MON.s_axi_lite_wready;
                item.s_axi_lite_bready          <= `MON.s_axi_lite_bready;
                item.s_axi_lite_bresp           <= `MON.s_axi_lite_bresp;
                item.s_axi_lite_bvalid          <= `MON.s_axi_lite_bvalid;
                item.s_axi_lite_arvalid         <= `MON.s_axi_lite_arvalid;
                item.s_axi_lite_araddr          <= `MON.s_axi_lite_araddr;
                item.s_axi_lite_arready         <= `MON.s_axi_lite_arready;
                item.s_axi_lite_rready          <= `MON.s_axi_lite_rready;   
                item.s_axi_lite_rvalid          <= `MON.s_axi_lite_rvalid;
                item.s_axi_lite_rdata           <= `MON.s_axi_lite_rdata;
                item.s_axi_lite_rresp           <= `MON.s_axi_lite_rresp;
                
                // Print transaction
                `uvm_info(get_type_name(), $sformatf("Transaction Collected :\n%s",item.sprint()), UVM_LOW)
        end
endtask: collect_transactions

`endif