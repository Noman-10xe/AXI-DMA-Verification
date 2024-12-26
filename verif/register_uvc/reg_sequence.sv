/*************************************************************************
   > File Name: reg_sequence.sv
   > Description: Sequence Class for AXI-lite Transactions
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef REG_SEQUENCES
`define REG_SEQUENCES

class base_sequence extends uvm_sequence #(reg_transaction);
  
  // Required macro for sequences automation
  `uvm_object_utils(base_sequence)
      
  // Constructor
  function new(string name="base_sequence");
    super.new(name);
  endfunction        

  // task pre_body();
  //   uvm_phase phase;
  //   `ifdef UVM_VERSION_1_2
  //     // in UVM1.2, get starting phase from method
  //     phase = get_starting_phase();
  //   `else
  //     phase = starting_phase;
  //   `endif
  //   if (phase != null) begin
  //     phase.raise_objection(this, get_type_name());
  //     `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
  //   end
  // endtask : pre_body

  // task post_body();
  //   uvm_phase phase;
  //   `ifdef UVM_VERSION_1_2
  //     // in UVM1.2, get starting phase from method
  //     phase = get_starting_phase();
  //   `else
  //     phase = starting_phase;
  //   `endif
  //   if (phase != null) begin
  //     phase.drop_objection(this, get_type_name());
  //     `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
  //   end
  // endtask : post_body

endclass : base_sequence

//////////////////////////////////////////////////////////////////////
//                          Random Sequence                         //
//////////////////////////////////////////////////////////////////////

class random_sequence extends base_sequence;
  `uvm_object_utils(random_sequence)
  
  reg_transaction item;

  function new(string name="random_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing Random Sequence", UVM_LOW)
    
    repeat (20) begin
    `uvm_do(item);
    end
  endtask : body

endclass : random_sequence


class default_rd_sequence extends base_sequence;
  `uvm_object_utils(default_rd_sequence)
  
  reg_transaction item;

  function new(string name="default_rd_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing Default Read Sequence", UVM_LOW)
    
    item  = reg_transaction::type_id::create("item");
    item.c_write_transaction.constraint_mode(0);
    item.c_addr.constraint_mode(0);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h0;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h0;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h04;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h18;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h1C;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h28;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h30;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h34;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h48;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h4C;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_araddr == 10'h58;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

  endtask : body

endclass : default_rd_sequence

class mm2s_enable_sequence extends base_sequence;
  `uvm_object_utils(mm2s_enable_sequence)
  
  reg_transaction item;

  function new(string name="mm2s_enable_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing MM2S Enable Sequence", UVM_LOW)
    
    item  = reg_transaction::type_id::create("item");

    item.c_read_transaction.constraint_mode(0);
    item.c_addr.constraint_mode(0);

    // WRITE Control Register -> MM2S_DMACR == 32'h11003
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h00;
                                item.s_axi_lite_wdata == 32'h11003;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    // // WRITE Source Address Register -> MM2S_SA == 32'h00000000
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h18;
                                item.s_axi_lite_wdata == 32'h0;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    // WRITE LENGTH Register -> MM2S_LENGTH == 32'h14 (20 Bytes)
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h28;
                                item.s_axi_lite_wdata == 32'h80;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

  endtask : body

endclass : mm2s_enable_sequence

class s2mm_enable_sequence extends base_sequence;
  `uvm_object_utils(s2mm_enable_sequence)
  
  reg_transaction item;

  function new(string name="s2mm_enable_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing S2MM Enable Sequence", UVM_LOW)
    
    item  = reg_transaction::type_id::create("item");

    item.c_read_transaction.constraint_mode(0);
    item.c_addr.constraint_mode(0);

    // WRITE Control Register -> S2MM_DMACR == 32'h11003
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h30;
                                item.s_axi_lite_wdata == 32'h11003;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    // // WRITE Source Address Register -> S2MM_DA == 32'h10
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h48;
                                item.s_axi_lite_wdata == 32'h10;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

    // WRITE LENGTH Register -> S2MM_LENGTH == 32'h80 (128 Bytes)
    start_item(item);
    if (!item.randomize() with {item.s_axi_lite_awaddr == 10'h58;
                                item.s_axi_lite_wdata == 32'h80;})
    `uvm_error(get_type_name(), "Randomization failed")
    finish_item(item);

  endtask : body

endclass : s2mm_enable_sequence


`endif