/*************************************************************************
   > File Name: s2mm_agent.sv
   > Description: Agent Class for AXI S2MM Write Channel
   > Author: Noman Rafiq
   > Modified: Jan 15, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef S2MM_AGENT
`define S2MM_AGENT

class s2mm_agent extends uvm_agent;

        s2mm_driver                             driver;
        s2mm_monitor                            monitor;
        uvm_sequencer #(axi_transaction)        sequencer;
      
        `uvm_component_utils(s2mm_agent)
        
        function new(string name = "s2mm_agent", uvm_component parent);
                super.new(name, parent);
        endfunction : new

        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

      
endclass : s2mm_agent

function void s2mm_agent::build_phase(uvm_phase phase);
        super.build_phase(phase);
        driver = s2mm_driver::type_id::create("driver", this);
        sequencer = uvm_sequencer#(axi_transaction)::type_id::create("sequencer", this);
	monitor   = s2mm_monitor::type_id::create("monitor", this);
endfunction: build_phase

function void s2mm_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
endfunction: connect_phase



`endif