/*************************************************************************
   > File Name: s2mm_length.sv
   > Description: S2MM_LENGTH Register. It specifies the number of Bytes
   >              that the S2MM Channel will write to the memory.
   > Author: Noman Rafiq
   > Modified: Dec 30, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef S2MM_LENGTH
`define S2MM_LENGTH

class s2mm_length extends uvm_reg;
   
   // Fields
   rand uvm_reg_field Length;
   rand uvm_reg_field RSVD;
   
   `uvm_object_utils(s2mm_length)

   function new(string name = "s2mm_length");
     super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
   endfunction
   
   virtual function void build();
      
      // Create
      Length   = uvm_reg_field::type_id::create("Length");
      RSVD     = uvm_reg_field::type_id::create("RSVD");

      // Configure
      Length.configure           (this, 26, 0, "RW", 0, 26'h0, 1, 1, 0);
      RSVD.configure             (this, 6, 26, "RO", 0, 6'h0, 1, 1, 0);

   endfunction
 endclass   : s2mm_length

`endif