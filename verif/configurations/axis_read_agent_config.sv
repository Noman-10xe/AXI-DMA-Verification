/*************************************************************************
   > File Name: axis_read_agent_config.sv
   > Description: Configuration Class for AXI-Stream Read Agent
   > Author: Noman Rafiq
   > Modified: Jan 10, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef READ_AGENT_CONFIG
`define READ_AGENT_CONFIG

class axis_read_agent_config extends uvm_object;
        `uvm_object_utils(axis_read_agent_config)
        
        uvm_active_passive_enum active = UVM_ACTIVE;
 
        function new( string name = "" );
           super.new( name );
        endfunction: new

endclass: axis_read_agent_config     

`endif