/*************************************************************************
   > File Name: axi_lite_driver.sv
   > Description: Driver Class for Driving Sequences on AXI4-LITE Interface.
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_LITE_DRIVER
`define AXI_LITE_DRIVER

`define DRIV vif.ioDriv
class axi_lite_driver extends uvm_driver #(reg_transaction);
        
        `uvm_component_utils(axi_lite_driver);

        // Get Interface
        virtual s_axi_lite_io vif;

        reg_transaction item;

        //  Constructor
        function new(string name = "axi_lite_driver", uvm_component parent);
                super.new(name, parent);
        endfunction: new

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual s_axi_lite_io)::get(this, get_full_name(), "axi_lite_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        vif.reset();
        phase.drop_objection(this);
endtask: reset_phase 

task main_phase(uvm_phase phase);
        forever begin
                `uvm_info(get_full_name(), "Driver Started", UVM_NONE)
                seq_item_port.get_next_item(item);
                fork
                        read();
                        write();
                join
                seq_item_port.item_done();
        end
endtask: main_phase

task read();

        @(posedge vif.axi_aclk);
        `DRIV.s_axi_lite_arvalid        <= item.s_axi_lite_arvalid;
        `DRIV.s_axi_lite_araddr         <= item.s_axi_lite_araddr;
        
        // Read Address Phase
        if (item.s_axi_lite_arvalid) begin
                
                wait(`DRIV.s_axi_lite_arready);
                `DRIV.s_axi_lite_arvalid        <= 1'b0;

                `DRIV.s_axi_lite_rready <= 1'b1;
                if (item.s_axi_lite_rready) `DRIV.s_axi_lite_rready <= 1'b0;
                wait(`DRIV.s_axi_lite_rvalid);
                @(posedge vif.axi_aclk);
                `DRIV.s_axi_lite_rready <= item.s_axi_lite_rready;

                item.s_axi_lite_rdata   <= `DRIV.s_axi_lite_rdata;
                item.s_axi_lite_rresp   <= `DRIV.s_axi_lite_rresp;
                @(posedge vif.axi_aclk);
                `DRIV.s_axi_lite_rready <= 1'b0;
        end
endtask : read

task write();
        
        // Write Address Phase
        @(posedge vif.axi_aclk);
        `DRIV.s_axi_lite_awvalid        <= item.s_axi_lite_awvalid;
        `DRIV.s_axi_lite_awaddr         <= item.s_axi_lite_awaddr;

        if (item.s_axi_lite_awvalid) begin

                // Write Data Phase
                @(posedge vif.axi_aclk);
                `DRIV.s_axi_lite_wvalid         <= item.s_axi_lite_wvalid;
                `DRIV.s_axi_lite_wdata          <= item.s_axi_lite_wdata;
                
                
                if (item.s_axi_lite_wvalid) begin
                        wait(`DRIV.s_axi_lite_wready);
                        `DRIV.s_axi_lite_wvalid         <= 1'b0;
                        `DRIV.s_axi_lite_awvalid         <= 1'b0;

                        // Response Phase
                        @(posedge vif.axi_aclk);
                        `DRIV.s_axi_lite_bready         <= 1'b0;
                        wait(`DRIV.s_axi_lite_bvalid);
                        `DRIV.s_axi_lite_bready         <= 1'b1;
                end
        end

endtask : write


endclass: axi_lite_driver

`endif