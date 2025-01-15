/*************************************************************************
   > File Name: environment_config.sv
   > Description: Environment Configuration Class
   > Author: Noman Rafiq
   > Modified: Jan 10, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef ENVIRONMENT_CONFIG
`define ENVIRONMENT_CONFIG

class environment_config extends uvm_object;
        `uvm_object_utils(environment_config)
      
        bit has_axis_read_agent  = 1; // switch to instantiate Stream Read Agent
        bit has_axis_write_agent = 1; // switch to instantiate Stream Write Agent
        bit has_scoreboard       = 1; // switch to instantiate Scoreboard
        bit scoreboard_read      = 1;
        bit scoreboard_write     = 1;

        // Source Address for Read
        bit [ 31:0 ] SRC_ADDR = 32'h1E;

        // Destination Address for Write Operation
        bit [ 31:0 ] DST_ADDR = 32'h0;
        
        // Bytes to Read/Write
        int DATA_LENGTH = 128;

        axis_read_agent_config  read_agt_cfg;
        axis_write_agent_config write_agt_cfg;
        
        int num_trans = DATA_LENGTH/params_pkg::Byte_Lanes;

        function new( string name = "" );
           super.new( name );
        endfunction: new

endclass: environment_config     

`endif