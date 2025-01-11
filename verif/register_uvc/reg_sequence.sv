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
  endfunction : new

endclass : base_sequence

//////////////////////////////////////////////////////////////////////
//                       RAL Model Sanity Sequence                  //
//////////////////////////////////////////////////////////////////////

class mm2s_dmacr_sequence extends base_sequence;
  `uvm_object_utils(mm2s_dmacr_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_dmacr_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e   status;
    bit [31:0] data;
    bit [31:0] dv, mv;     // Desired Value & Mirrored Values
  
      RAL_Model.MM2S_DMACR.read(status, data);  
      
      // Check 'dv' and 'mv' Values
      dv = RAL_Model.MM2S_DMACR.get();                      // Get Desired Value
      mv = RAL_Model.MM2S_DMACR.get_mirrored_value();
      `uvm_info("READ", $sformatf(" Desired Value = %0h, Mirrored Value = %0h ", dv, mv), UVM_NONE)

      data = 32'h11003;
      
      RAL_Model.MM2S_DMACR.write(status, data);
      
      dv = RAL_Model.MM2S_DMACR.get();
      mv = RAL_Model.MM2S_DMACR.get_mirrored_value();
      `uvm_info("WRITE(11003)", $sformatf(" Desired Value = %0h, Mirrored Value = %0h ", dv, mv), UVM_NONE)

      RAL_Model.MM2S_DMACR.read(status, data);  
      
      // Check 'dv' and 'mv' Values
      dv = RAL_Model.MM2S_DMACR.get();                      // Get Desired Value
      mv = RAL_Model.MM2S_DMACR.get_mirrored_value();
      `uvm_info("READ", $sformatf(" Desired Value = %0h, Mirrored Value = %0h ", dv, mv), UVM_NONE)

   endtask
endclass : mm2s_dmacr_sequence

//////////////////////////////////////////////////////////////////////
//                     MM2S Enable Sequence                         //
//////////////////////////////////////////////////////////////////////

class mm2s_enable_sequence extends base_sequence;
  `uvm_object_utils(mm2s_enable_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_enable_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    dv, mv;     // Desired Value & Mirrored Values (For Debugging Only)
  
    data = 32'h11003;
    RAL_Model.MM2S_DMACR.write(status, data);

    data = `SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);

    data = 128;
    RAL_Model.MM2S_LENGTH.write(status, data);

   endtask
endclass : mm2s_enable_sequence


//////////////////////////////////////////////////////////////////////
//                     S2MM Enable Sequence                         //
//////////////////////////////////////////////////////////////////////

class s2mm_enable_sequence extends base_sequence;
  `uvm_object_utils(s2mm_enable_sequence)
  
   reg_block RAL_Model;
  function new (string name = "s2mm_enable_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    dv, mv;     // Desired Value & Mirrored Values  (For Debugging Only)
  
    data = 32'h11003;
    RAL_Model.S2MM_DMACR.write(status, data);

    data = `DST_ADDR;
    RAL_Model.S2MM_DA.write(status, data);

    data = 128;
    RAL_Model.S2MM_LENGTH.write(status, data);

   endtask
endclass : s2mm_enable_sequence

//////////////////////////////////////////////////////////////////////
//                        Reset Sequence                            //
//////////////////////////////////////////////////////////////////////

class reset_sequence extends base_sequence;
  `uvm_object_utils(reset_sequence)
  
   reg_block RAL_Model;
  function new (string name = "reset_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    dv, mv;     // Desired Value & Mirrored Values
  
      RAL_Model.MM2S_DMACR.read(status, data);  
      
      data = 32'h4;
      
      RAL_Model.MM2S_DMACR.write(status, data);

   endtask
endclass : reset_sequence

//////////////////////////////////////////////////////////////////////
//                    Read Status Sequence                          //
//////////////////////////////////////////////////////////////////////

class read_status_sequence extends base_sequence;
  `uvm_object_utils(read_status_sequence)
  
   reg_block RAL_Model;
  function new (string name = "read_status_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;

      RAL_Model.MM2S_DMASR.read(status, data);
      RAL_Model.S2MM_DMASR.read(status, data);
      
      data = 32'h1000; // Clears Interrupt (IOC)

      // RAL_Model.MM2S_DMASR.write(status, data);
      RAL_Model.S2MM_DMASR.write(status, data);

   endtask
endclass : read_status_sequence
`endif