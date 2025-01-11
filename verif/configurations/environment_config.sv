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
      
        axis_read_agent_config  read_agt_cfg;
        axis_write_agent_config write_agt_cfg;

        function new( string name = "" );
           super.new( name );
        endfunction: new

endclass: environment_config     

`endif