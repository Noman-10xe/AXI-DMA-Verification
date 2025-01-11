/*************************************************************************
   > File Name: virtual_sequencer.sv
   > Description: Virtual Sequencer Class for managing all the sequencers.
   > Author: Noman Rafiq
   > Modified: Jan 09, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef VIRTUAL_SEQUENCER
`define VIRTUAL_SEQUENCER

class virtual_sequencer extends uvm_sequencer #(axis_transaction);
        `uvm_component_utils(virtual_sequencer)
        
        // Sequencer Handles
        uvm_sequencer #(axis_transaction) axis_read_sequencer;
        uvm_sequencer #(axis_transaction) axis_write_sequencer;
        
        function new(string name = "virtual_sequencer", uvm_component parent);
        super.new(name, parent);
        endfunction : new

endclass : virtual_sequencer

`endif