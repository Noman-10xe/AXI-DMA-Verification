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

class virtual_sequence extends uvm_sequence #(axis_transaction);
    
        `uvm_object_utils(virtual_sequence)
        
        // p_sequencer declaration
        `uvm_declare_p_sequencer(virtual_sequencer)

        axis_read               axis_read_seq;
        axis_wr                 axis_write_seq;
        environment_config      cfg;

        function new(string name = "virtual_sequence");
           super.new(name);
        endfunction : new
             
        task pre_body();
                uvm_config_db #(environment_config)::get(null, get_full_name(), "env_cfg", cfg);

                if(cfg.scoreboard_read) begin
                        axis_read_seq	= axis_read::type_id::create("axis_read_seq");
                end
        
                if (cfg.scoreboard_write) begin
                        axis_write_seq	= axis_wr::type_id::create("axis_write_seq");
                end
                
        endtask : pre_body
        
        // Sequence Body
        virtual task body();
                if(cfg.scoreboard_read) begin
                        axis_read_seq.start(p_sequencer.axis_read_sequencer);
                end
                
                if (cfg.scoreboard_write) begin
                        axis_write_seq.start(p_sequencer.axis_write_sequencer);
                end
        endtask
     
endclass : virtual_sequence

`endif