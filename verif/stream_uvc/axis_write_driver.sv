/*************************************************************************
   > File Name: axis_write_driver.sv
   > Description: Driver Class For AXI-Stream Write Slave.
   > Author: Noman Rafiq
   > Modified: Dec 21, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_WRITE_DRIVER
`define AXIS_WRITE_DRIVER

`define WRITE_DRIV vif.ioWriteDriver
class axis_write_driver extends uvm_driver #(axis_transaction);
        
        `uvm_component_utils(axis_write_driver);

        virtual axis_io vif;
        axis_transaction item;

        function new(string name = "axis_write_driver", uvm_component parent);
                super.new(name, parent);
        endfunction: new

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axis_io)::get(this, get_full_name(), "axis_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        wait(!vif.axi_resetn);
        `WRITE_DRIV.s_axis_s2mm_tdata         <= 0;
        `WRITE_DRIV.s_axis_s2mm_tvalid        <= 0;
        wait(vif.axi_resetn);
        phase.drop_objection(this);
endtask: reset_phase 

task main_phase(uvm_phase phase);
        forever begin
                `uvm_info(get_full_name(), "Axis Write Driver Started", UVM_NONE)
                seq_item_port.get_next_item(item);
                
                @(posedge vif.axi_aclk);
                `WRITE_DRIV.s_axis_s2mm_tdata         <= item.tdata;
                `WRITE_DRIV.s_axis_s2mm_tvalid        <= item.tvalid;
                wait(`WRITE_DRIV.s_axis_s2mm_tready);

                @(posedge vif.axi_aclk);
                `WRITE_DRIV.s_axis_s2mm_tkeep         <= item.tkeep;
                `WRITE_DRIV.s_axis_s2mm_tlast         <= item.tlast;
                wait(!`WRITE_DRIV.s_axis_s2mm_tready);
                
                `WRITE_DRIV.s_axis_s2mm_tvalid         <= 1'b0;
                seq_item_port.item_done();
        end
endtask: main_phase

endclass: axis_write_driver

`endif