/*************************************************************************
   > File Name: sequence_config.sv
   > Description: Axis Stream Sequence Configuration Class
   > Author: Noman Rafiq
   > Modified: Jan 10, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef SEQUENCE_CONFIG
`define SEQUENCE_CONFIG

class sequence_config extends uvm_object;
        `uvm_object_utils(sequence_config)
      
        int num_trans                   = 33;
        bit has_axis_read_sequence      = 1;
        bit has_axis_write_sequence     = 1;

        function new( string name = "" );
           super.new( name );
        endfunction: new

endclass: sequence_config
`endif