/*************************************************************************
   > File Name: virtual_sequence.sv
   > Description: Virtual Sequencer Class for managing all the sequences.
   > Author: Noman Rafiq
   > Modified: Jan 09, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef VIRTUAL_SEQUENCE
`define VIRTUAL_SEQUENCE

class virtual_sequence extends uvm_sequence;
    
        `uvm_object_utils(virtual_sequence)
        
        // p_sequencer declaration
        `uvm_declare_p_sequencer(virtual_sequencer)
        uvm_sequencer #(axis_transaction) read_seqr;
        uvm_sequencer #(axis_transaction) write_seqr;
        
        function new(string name = "virtual_sequence");
           super.new(name);
        endfunction : new
             
        // Sequence Body
        virtual task body();
                read_seqr = p_sequencer.axis_read_sequencer;
                write_seqr = p_sequencer.axis_write_sequencer;
        endtask
     
endclass : virtual_sequence

`endif