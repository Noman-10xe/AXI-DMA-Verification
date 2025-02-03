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

        axi_transaction req;
        axi_transaction rsp;

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
                seq_item_port.get_next_item(req);
                req_phase();
                seq_item_port.item_done();

                rsp_phase();
        end
endtask: run_phase

task req_phase();
                `uvm_info("DEBUG", "Waiting for arvalid in request Phase", UVM_HIGH);
                wait(`MM2S_DRIV.arvalid);
                `MM2S_DRIV.arready      <= 1;

                req.araddr      <= `MM2S_DRIV.araddr;
                req.arlen       <= `MM2S_DRIV.arlen;
                req.arsize      <= `MM2S_DRIV.arsize;
                req.arburst     <= `MM2S_DRIV.arburst;
                req.arprot      <= `MM2S_DRIV.arprot;
                req.arcache     <= `MM2S_DRIV.arcache;
                req.arvalid     <= `MM2S_DRIV.arvalid;
                
                @(posedge vif.axi_aclk);
                `MM2S_DRIV.arready      <= 1'b0;
endtask : req_phase


task rsp_phase();
            for (int beat = 0; beat <= req.arlen; beat++) begin
                
                seq_item_port.get_next_item(rsp);
                @(posedge vif.axi_aclk);

                // Drive response signals
                `MM2S_DRIV.rvalid <= rsp.rvalid;                        // Assert RVALID
                `MM2S_DRIV.rdata  <= rsp.rdata;                         // Provide the data
                `MM2S_DRIV.rresp  <= rsp.rresp;                         // Provide response
                `MM2S_DRIV.rlast  <= (beat==req.arlen);                 // Assert RLAST for the last beat
        
                // Wait for RREADY handshake
                `uvm_info("DEBUG", "Waiting for rready in response Phase", UVM_DEBUG);
                wait(`MM2S_DRIV.rready);
        
                // Deassert RLAST in the next cycle if it was asserted
                @(posedge vif.axi_aclk);
                `MM2S_DRIV.rlast        <= 1'b0;
                `MM2S_DRIV.rvalid       <= 1'b0;
        
                seq_item_port.item_done();
            end
        
endtask : rsp_phase

endclass: mm2s_driver

`endif