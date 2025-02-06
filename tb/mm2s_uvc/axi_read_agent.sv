/*************************************************************************
   > File Name: mm2s_agent.sv
   > Description: Agent Class for AXI MM2S Read Channel
   > Author: Noman Rafiq
   > Modified: Dec 26, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef MM2S_AGENT
`define MM2S_AGENT

class mm2s_agent extends uvm_agent;

        uvm_sequencer  sequencer;
        mm2s_driver     driver;
        mm2s_monitor    monitor;
      
        `uvm_component_utils(mm2s_agent)
        
        function new(string name = "mm2s_agent", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void connect_phase(uvm_phase phase);
      
endclass : mm2s_agent

function void mm2s_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver		= mm2s_driver::type_id::create("driver", this);
	monitor 	= mm2s_monitor::type_id::create("monitor", this);
	sequencer	= uvm_sequencer::type_id::create("sequencer", this);
endfunction: build_phase

function void mm2s_agent::connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase

`endif