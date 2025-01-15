/*************************************************************************
   > File Name: axi_lite_agent.sv
   > Description: Agent Class for AXI-lite Interface
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_LITE_AGENT
`define AXI_LITE_AGENT

class axi_lite_agent extends uvm_agent;

        axi_lite_sequencer  sequencer;
        axi_lite_driver     driver;
        axi_lite_monitor    monitor;
      
        `uvm_component_utils(axi_lite_agent)
        
        function new(string name = "axi_lite_agent", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);

        extern function void connect_phase(uvm_phase phase);
      
endclass : axi_lite_agent

function void axi_lite_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver		= axi_lite_driver::type_id::create("driver", this);
	monitor 	= axi_lite_monitor::type_id::create("monitor", this);
	sequencer	= axi_lite_sequencer::type_id::create("sequencer", this);
endfunction: build_phase

function void axi_lite_agent::connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase

`endif