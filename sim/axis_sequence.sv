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

  environment_config cfg;

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

    uvm_config_db #(environment_config)::get(null, get_full_name(), "env_cfg", cfg);
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
    `uvm_info(get_type_name(), "Executing AXIS Read Sequence", UVM_HIGH)
    
    item  =axis_transaction::type_id::create("item");

    repeat(cfg.num_trans)  begin
    start_item(item);
    if(!item.randomize())
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end
  endtask : body



endclass : axis_read


//////////////////////////////////////////////////////////////////////
//                     Ready Low Sequence                           //
//////////////////////////////////////////////////////////////////////

class ready_low_sequence extends axis_base_sequence;
  `uvm_object_utils(ready_low_sequence)

  axis_transaction item;

  function new(string name="ready_low_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Ready Low Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");
    item.c_tready.constraint_mode(0);

    repeat(cfg.num_trans-4)  begin
      start_item(item);
        if(!item.randomize() with { item.tready == 0; }) begin
          `uvm_error(get_type_name(), "Randomization failed");
        end
      finish_item(item);
    end

    repeat(4) begin
      start_item(item);
        if(!item.randomize() with { item.tready == 1; }) begin
          `uvm_error(get_type_name(), "Randomization failed");
        end
      finish_item(item);
    end
  endtask : body

endclass : ready_low_sequence

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
    `uvm_info(get_type_name(), "Executing AXIS Write Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");
    
    repeat (cfg.num_trans-1) begin
    start_item(item);
    
    if(!item.randomize())
    `uvm_error(get_type_name(), "Randomization failed");
    
    finish_item(item);
  end

  item.c_tlast.constraint_mode(0);

  start_item(item);
    
  if(!item.randomize() with { item.tlast == 1;} )
  `uvm_error(get_type_name(), "Randomization failed");
  finish_item(item);
  
  endtask : body

  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 700ns);
    end
  endtask : post_body

endclass : axis_wr

//////////////////////////////////////////////////////////////////////
//                       Random Read Sequence                       //
//////////////////////////////////////////////////////////////////////

class random_axis_read extends axis_base_sequence;
  `uvm_object_utils(random_axis_read)

  axis_transaction item;

  function new(string name="random_axis_read");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing Random AXIS Read Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tready.constraint_mode(0);
    repeat(cfg.num_trans)  begin
    start_item(item);
    if(!item.randomize())
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end
  endtask : body

endclass : random_axis_read


//////////////////////////////////////////////////////////////////////
//                      Random Write Sequence                       //
//////////////////////////////////////////////////////////////////////

class random_axis_write extends axis_base_sequence;
  `uvm_object_utils(random_axis_write)

  axis_transaction item;

  function new(string name="random_axis_write");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing Random AXIS Write Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tkeep.constraint_mode(0);

    repeat(cfg.num_trans-1)  begin
    start_item(item);
    if(!item.randomize() with { item.tkeep inside {'h1, 'h7, 'h3, 'hf }; })
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

    item.c_tlast.constraint_mode(0);
    start_item(item);
    
    if(!item.randomize() with { item.tlast == 1;} )
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);

  endtask : body

endclass : random_axis_write


//////////////////////////////////////////////////////////////////////
//                  AXIS Write Coverage Sequence                    //
//////////////////////////////////////////////////////////////////////

class axis_write_cov_sequence extends axis_base_sequence;
  `uvm_object_utils(axis_write_cov_sequence)

  axis_transaction item;

  function new(string name="axis_write_cov_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Write Coverage Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tkeep.constraint_mode(0);
    item.c_tdata.constraint_mode(0);

    repeat(cfg.num_trans-1)  begin
    start_item(item);
    if(!item.randomize() with { item.tkeep inside {'h1, 'h7, 'h3 };
                                item.tdata inside {'h00000000, 'hFFFFFFFF, 'hCAFE, 'hBAD, 'hBABACA }; })
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

    item.c_tlast.constraint_mode(0);
    start_item(item);
    
    if(!item.randomize() with { item.tlast == 1;} )
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);

  endtask : body

endclass : axis_write_cov_sequence


//////////////////////////////////////////////////////////////////////
//         AXIS Write Sequence for Stream Read's Coverage           //
//////////////////////////////////////////////////////////////////////

class axis_write_sequence extends axis_base_sequence;
  `uvm_object_utils(axis_write_sequence)

  axis_transaction item;

  function new(string name="axis_write_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Write Coverage Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tdata.constraint_mode(0);
    repeat(cfg.num_trans-1)  begin
    start_item(item);
    if(!item.randomize() with { item.tdata inside {'h00000000, 'hFFFFFFFF, 'hCAFE, 'hBAD, 'hBABACA }; })
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

    item.c_tlast.constraint_mode(0);
    start_item(item);
    
    if(!item.randomize() with { item.tlast == 1;} )
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);

  endtask : body

  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 700ns);
    end
  endtask : post_body

endclass : axis_write_sequence


//////////////////////////////////////////////////////////////////////
//         AXIS Write Sequence no. 2 for Stream Read's Coverage     //
//////////////////////////////////////////////////////////////////////

class axis_write_all_zeros_sequence extends axis_base_sequence;
  `uvm_object_utils(axis_write_all_zeros_sequence)

  axis_transaction item;

  function new(string name="axis_write_all_zeros_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Write Coverage Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tdata.constraint_mode(0);
    repeat(cfg.num_trans-1)  begin
    start_item(item);
    if(!item.randomize() with { item.tdata == 'h0; })
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

    item.c_tlast.constraint_mode(0);
    start_item(item);
    
    if(!item.randomize() with { item.tlast == 1;} )
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);

  endtask : body

  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 700ns);
    end
  endtask : post_body

endclass : axis_write_all_zeros_sequence


//////////////////////////////////////////////////////////////////////
//         AXIS Write Sequence no. 3 for Stream Read's Coverage     //
//////////////////////////////////////////////////////////////////////

class axis_write_mid_values_sequence extends axis_base_sequence;
  `uvm_object_utils(axis_write_mid_values_sequence)

  axis_transaction item;

  function new(string name="axis_write_mid_values_sequence");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing AXIS Write Coverage Sequence", UVM_HIGH)
    
    item  = axis_transaction::type_id::create("item");

    item.c_tdata.constraint_mode(0);
    repeat(cfg.num_trans-1)  begin
    start_item(item);
    if(!item.randomize() with { item.tdata == 'hb0b0; })
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);
    end

    item.c_tlast.constraint_mode(0);
    start_item(item);
    
    if(!item.randomize() with { item.tlast == 1;} )
    `uvm_error(get_type_name(), "Randomization failed");
    finish_item(item);

  endtask : body

  task post_body();
    uvm_phase phase;
    phase = get_starting_phase();
 
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
      phase.phase_done.set_drain_time(this, 700ns);
    end
  endtask : post_body

endclass : axis_write_mid_values_sequence

`endif