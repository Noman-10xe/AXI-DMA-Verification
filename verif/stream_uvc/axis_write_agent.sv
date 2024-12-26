/*************************************************************************
   > File Name: axis_write_agent.sv
   > Description: Agent Class for AXI-Stream Write Slave
   > Author: Noman Rafiq
   > Modified: Dec 21, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_WRITE_AGENT
`define AXI_WRITE_AGENT

class axis_write_agent extends uvm_agent;

        uvm_sequencer #(axis_transaction)       sequencer;
        axis_write_driver                       driver;
        axis_write_monitor                      monitor;
      
        `uvm_component_utils(axis_write_agent)
        
        function new(string name = "axis_write_agent", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void connect_phase(uvm_phase phase);
      
endclass : axis_write_agent

function void axis_write_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver		= axis_write_driver::type_id::create("driver", this);
	monitor 	= axis_write_monitor::type_id::create("monitor", this);
	sequencer	= uvm_sequencer#(axis_transaction)::type_id::create("sequencer", this);
endfunction: build_phase

function void axis_write_agent::connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase

`endif