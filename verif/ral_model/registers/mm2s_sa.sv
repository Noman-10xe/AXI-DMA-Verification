/*************************************************************************
   > File Name: mm2s_sa.sv
   > Description: MM2S_SA Register. This register provides the Source 
   >             Address for reading system memory for the Memory Map 
   >             to Stream DMA transfer.
   > Author: Noman Rafiq
   > Modified: Dec 30, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef MM2S_SA
`define MM2S_SA

class mm2s_sa extends uvm_reg;
   
   // Fields
   rand uvm_reg_field Source_Address;
   
   `uvm_object_utils(mm2s_sa)

   function new(string name = "mm2s_sa");
     super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
   endfunction
   
   virtual function void build();
      
      // Create
      Source_Address   = uvm_reg_field::type_id::create("Source_Address");
      
      // Configure
      Source_Address.configure   (this, 32, 0, "RW", 0, 32'h0, 1, 1, 0);

   endfunction
 endclass   : mm2s_sa

`endif