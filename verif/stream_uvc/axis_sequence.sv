/*************************************************************************
   > File Name: axis_sequence.sv
   > Description: Sequence Class for AXI-Stream Interface
   > Author: Noman Rafiq
   > Modified: Dec 20, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_SEQUENCES
`define AXIS_SEQUENCES

class axis_base_sequence extends uvm_sequence #(axis_transaction);
  
  // Required macro for sequences automation
  `uvm_object_utils(axis_base_sequence)
      
  // Constructor
  function new(string name="axis_base_sequence");
    super.new(name);
  endfunction        

  task pre_body();
    uvm_phase phase;
 
    phase = get_starting_phase();
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
    end
  endtask : pre_body
 
  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 600ns);
    end
  endtask : post_body

endclass : axis_base_sequence

//////////////////////////////////////////////////////////////////////
//                          Read Sequence                           //
//////////////////////////////////////////////////////////////////////

class axis_read extends axis_base_sequence;
  `uvm_object_utils(axis_read)

  axis_transaction item;

  function new(string name="axis_read");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Read Sequence", UVM_LOW)
    
    item  =axis_transaction::type_id::create("item");

    repeat(77)  begin
    start_item(item);
    if(!item.randomize())
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

  endtask : body

endclass : axis_read

//////////////////////////////////////////////////////////////////////
//                         Write Sequence                           //
//////////////////////////////////////////////////////////////////////

class axis_wr extends axis_base_sequence;
  `uvm_object_utils(axis_wr)
  
  axis_transaction item;

  function new(string name="axis_wr");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Write Sequence", UVM_LOW)
    
    item  = axis_transaction::type_id::create("item");
    
    repeat (50) begin
    start_item(item);
    
    if(!item.randomize())
    `uvm_error(get_type_name(), "Randomization failed");
    
    finish_item(item);
    
  end
  endtask : body

endclass : axis_wr

`endif