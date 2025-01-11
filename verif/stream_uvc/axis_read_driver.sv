/*************************************************************************
   > File Name: axis_read_driver.sv
   > Description: Driver Class For AXI-Stream Read Master.
   > Author: Noman Rafiq
   > Modified: Dec 20, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_READ_DRIVER
`define AXIS_READ_DRIVER

`define READ_DRIV vif.ioReadDriver
class axis_read_driver extends uvm_driver #(axis_transaction);
        
        `uvm_component_utils(axis_read_driver);

        virtual axis_io vif;
        axis_transaction item;

        function new(string name = "axis_read_driver", uvm_component parent);
                super.new(name, parent);
        endfunction: new

function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axis_io)::get(this, get_full_name(), "axis_intf", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
endfunction: build_phase

task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        vif.reset();
        phase.drop_objection(this);
endtask: reset_phase

task main_phase(uvm_phase phase);
        forever begin
                seq_item_port.get_next_item(item);
                `uvm_info(get_full_name(), "Axis READ Driver Started", UVM_NONE)
                // wait(`READ_DRIV.m_axis_mm2s_tvalid);
                @(`READ_DRIV iff `READ_DRIV.m_axis_mm2s_tvalid == 1);
                // @(posedge vif.axi_aclk);
                `READ_DRIV.m_axis_mm2s_tready        <= item.tready;
                seq_item_port.item_done();
        end
endtask: main_phase

endclass: axis_read_driver

`endif