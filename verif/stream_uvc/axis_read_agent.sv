/*************************************************************************
   > File Name: axis_read_agent.sv
   > Description: Agent Class for AXI-Stream Read Master
   > Author: Noman Rafiq
   > Modified: Dec 20, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_READ_AGENT
`define AXI_READ_AGENT

class axis_read_agent extends uvm_agent;

        uvm_sequencer           sequencer;
        axis_read_driver        driver;
        axis_read_monitor       monitor;
      
        `uvm_component_utils(axis_read_agent)
        
        function new(string name = "axis_read_agent", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void connect_phase(uvm_phase phase);
      
endclass : axis_read_agent

function void axis_read_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver		= axis_read_driver::type_id::create("driver", this);
	monitor 	= axis_read_monitor::type_id::create("monitor", this);
	sequencer	= uvm_sequencer::type_id::create("sequencer", this);
endfunction: build_phase

function void axis_read_agent::connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase

`endif