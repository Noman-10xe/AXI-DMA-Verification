/*************************************************************************
   > File Name: s2mm_da.sv
   > Description: S2MM_DA Register. This register provides the Destination 
   >              Address for writing to system memory for the Stream to
   >              Memory Map to DMA transfer.
   > Author: Noman Rafiq
   > Modified: Dec 30, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef S2MM_DA
`define S2MM_DA

class s2mm_da extends uvm_reg;
   
   // Fields
   rand uvm_reg_field Destination_Address;
   
   `uvm_object_utils(s2mm_da)

   function new(string name = "s2mm_da");
     super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
   endfunction
   
   virtual function void build();
      
      // Create
      Destination_Address   = uvm_reg_field::type_id::create("Destination_Address");
      
      // Configure
      Destination_Address.configure   (this, 32, 0, "RW", 0, 32'h0, 1, 1, 0);

   endfunction
 endclass   : s2mm_da

`endif