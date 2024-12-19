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

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Raised objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "Dropped objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : base_sequence

//////////////////////////////////////////////////////////////////////
//                          Read Sequence                           //
//////////////////////////////////////////////////////////////////////

class read_sequence extends base_sequence;
  `uvm_object_utils(read_sequence)
  
  reg_transaction item;

  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction : new

  task body();
    `uvm_info(get_type_name(), "Executing Read Sequence", UVM_LOW)
    
    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h00;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
                        }
                 );
    
    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h04;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
                       }
                );
     
    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h18;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
                        }
                );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h1C;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h28;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h30;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h34;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h48;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h4C;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

    `uvm_do_with(item, {  item.s_axi_lite_araddr == 10'h58;
                          item.s_axi_lite_arvalid == 1;
                          item.s_axi_lite_rready == 1;
           }
    );

  endtask : body

endclass : read_sequence

`endif