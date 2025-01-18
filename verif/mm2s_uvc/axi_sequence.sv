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
  environment_config  cfg;
  real count; 
  int ceil_val;
      
  // Constructor
  function new(string name="axi_base_sequence");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_phase phase;
 
    phase = get_starting_phase();
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
    end

    uvm_config_db #(environment_config)::get(null, get_full_name(), "env_cfg", cfg);
    count = real'(cfg.num_trans) / 16;
    ceil_val = (count == $floor(count)) ? count : $floor(count) + 1;

  endtask : pre_body
 
  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 350ns);
    end
  endtask : post_body

endclass : axi_base_sequence

//////////////////////////////////////////////////////////////////////
//                          Random Sequence                         //
//////////////////////////////////////////////////////////////////////

class axi_random_sequence extends axi_base_sequence;
  `uvm_object_utils(axi_random_sequence)
  
  axi_transaction item;

  function new(string name="axi_random_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXI Random Sequence", UVM_LOW)
    item  = axi_transaction::type_id::create("item");

    `uvm_info(get_name(), $sformatf("Ceiling Value = %0d, num_trans = %0d, DATA_LENGTH = %0d, count = %0f", ceil_val, cfg.num_trans, cfg.DATA_LENGTH, count), UVM_DEBUG)
    
    repeat (ceil_val) begin
      start_item(item);
      if(!item.randomize())
      `uvm_error(get_type_name(), "Randomization failed");
      finish_item(item);
    end
  endtask : body

endclass : axi_random_sequence

`endif