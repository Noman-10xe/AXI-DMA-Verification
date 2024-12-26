/*************************************************************************
   > File Name: axi_sequence.sv
   > Description: Sequence Class for AXI Transactions
   > Author: Noman Rafiq
   > Modified: Dec 26, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_SEQUENCES
`define AXI_SEQUENCES

class axi_base_sequence extends uvm_sequence #(axi_transaction);
  
  // Required macro for sequences automation
  `uvm_object_utils(axi_base_sequence)
      
  // Constructor
  function new(string name="axi_base_sequence");
    super.new(name);
  endfunction        

endclass : axi_base_sequence

//////////////////////////////////////////////////////////////////////
//                          Random Sequence                         //
//////////////////////////////////////////////////////////////////////

class axi_random_sequence extends axi_base_sequence;
  `uvm_object_utils(axi_random_sequence)
  
  reg_transaction item;

  function new(string name="axi_random_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXI Random Sequence", UVM_LOW)
    
    repeat (20) begin
    `uvm_do(item);
    end
  endtask : body

endclass : axi_random_sequence

`endif