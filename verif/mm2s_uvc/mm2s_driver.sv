/*************************************************************************
   > File Name: mm2s_driver.sv
   > Description: Driver Class for Driving Sequences on MM2S AXI4 Interface.
   > Author: Noman Rafiq
   > Modified: Dec 25, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_MM2S_DRIVER
`define AXI_MM2S_DRIVER

`define MM2S_DRIV vif.ioReadDriver
class mm2s_driver extends uvm_driver #(axi_transaction);
        
        `uvm_component_utils(mm2s_driver);

        // Get Interface
        virtual axi_io vif;

        axi_transaction item;

        //  Constructor
        function new(string name = "mm2s_driver", uvm_component parent);
                super.new(name, parent);
        endfunction: new

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_io)::get(this, get_full_name(), "axi_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task run_phase(uvm_phase phase);
        forever begin
                `uvm_info(get_full_name(), "MM2S Read Driver Started", UVM_NONE)
                seq_item_port.get_next_item(item);
                read();
                seq_item_port.item_done();
        end
endtask: run_phase

task read();
                wait(`MM2S_DRIV.arvalid);
                @(posedge vif.axi_aclk);
                `MM2S_DRIV.arready      <= 1;

                // Read Address Phase
                @(posedge vif.axi_aclk);
                `MM2S_DRIV.rdata        <= item.rdata;
                `MM2S_DRIV.rvalid       <= item.rvalid;
                `MM2S_DRIV.rlast        <= item.rlast;
                
                wait(`MM2S_DRIV.rready);
                @(posedge vif.axi_aclk);
                `MM2S_DRIV.rresp        <= item.rresp;
                `MM2S_DRIV.rvalid       <= 0;
                `MM2S_DRIV.arready      <= 0;

endtask : read

endclass: mm2s_driver

`endif