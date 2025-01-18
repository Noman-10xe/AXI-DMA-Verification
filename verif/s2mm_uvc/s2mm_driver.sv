/*************************************************************************
   > File Name: s2mm_driver.sv
   > Description: Driver Class for Driving Sequences on S2MM AXI4 Interface.
   > Author: Noman Rafiq
   > Modified: Jan 15, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_S2MM_DRIVER
`define AXI_S2MM_DRIVER

`define S2MM_DRIV vif.ioWriteDriver
class s2mm_driver extends uvm_driver #(axi_transaction);
        
        `uvm_component_utils(s2mm_driver);

        // Get Interface
        virtual axi_io vif;

        axi_transaction item;

        //  Constructor
        function new(string name = "s2mm_driver", uvm_component parent);
                super.new(name, parent);
        endfunction: new

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_io)::get(this, get_full_name(), "axi_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task run_phase(uvm_phase phase);
        forever begin
                `uvm_info(get_full_name(), "S2MM Write Driver Started", UVM_NONE)
                
                seq_item_port.get_next_item(item);
                write();
                seq_item_port.item_done();
        end
endtask: run_phase

task write();
                // Address and Data Phase
                @(posedge vif.axi_aclk);
                `S2MM_DRIV.awready      <= 0;
                wait(`S2MM_DRIV.wvalid);
                `S2MM_DRIV.wready       <= 0;

                wait(`S2MM_DRIV.wlast);
                
                // Response Phase
                `S2MM_DRIV.bvalid       <= 1;
                `S2MM_DRIV.bresp        <= 2'b00;
                wait(`S2MM_DRIV.bready);

                @(posedge vif.axi_aclk);
                `S2MM_DRIV.bvalid       <= 0;
                `S2MM_DRIV.awready      <= 0;
endtask : write

endclass: s2mm_driver

`endif