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
    `uvm_info(get_type_name(), "Executing AXI Random Sequence", UVM_HIGH)
    
    repeat (ceil_val) begin
      start_item(item);
      if(!item.randomize())
      `uvm_error(get_type_name(), "Randomization failed");
      finish_item(item);
    end
  endtask : body

endclass : axi_random_sequence


//////////////////////////////////////////////////////////////////////
//                 Axi Slave Error Sequence                         //
//////////////////////////////////////////////////////////////////////

class axi_slave_error_sequence extends axi_base_sequence;
  `uvm_object_utils(axi_slave_error_sequence)
  
  axi_transaction req;
  axi_transaction rsp;
  int i = 0;

  function new(string name="axi_slave_error_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXI Slave Error Sequence", UVM_LOW)
    req = axi_transaction::type_id::create("req");
    rsp = axi_transaction::type_id::create("rsp");
  
    repeat (ceil_val) begin
      start_item(req);
      finish_item(req);

      repeat (req.arlen + 1) begin
        // Create and randomize the response item
        start_item(rsp);
        rsp.rdata   = 'hdeadbeef;   // Provide valid data
        rsp.rvalid  = 1'b1;         // Mark the data as valid
        rsp.rresp   = 2'b10;        // Slave Error response
        // Finish the response item (hand over to the driver)
        finish_item(rsp);
      end

    end  

  endtask : body

endclass : axi_slave_error_sequence

//////////////////////////////////////////////////////////////////////
//                 Axi Decode Error Sequence                        //
//////////////////////////////////////////////////////////////////////

class axi_decode_error_sequence extends axi_base_sequence;
  `uvm_object_utils(axi_decode_error_sequence)
  
  axi_transaction req;
  axi_transaction rsp;
  int i = 0;

  function new(string name="axi_decode_error_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXI Decode Error Sequence", UVM_LOW)
    req = axi_transaction::type_id::create("req");
    rsp = axi_transaction::type_id::create("rsp");
  
    repeat (ceil_val) begin
      start_item(req);
      finish_item(req);

      repeat (req.arlen + 1) begin
        // Create and randomize the response item
        start_item(rsp);
        rsp.rdata   = 'hdeadbeef;   // Provide valid data
        rsp.rvalid  = 1'b1;         // Mark the data as valid
        rsp.rresp   = 2'b11;        // Decode Error response
        // Finish the response item (hand over to the driver)
        finish_item(rsp);
      end

    end  

  endtask : body

endclass : axi_decode_error_sequence

`endif