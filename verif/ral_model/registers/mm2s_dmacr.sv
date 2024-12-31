/*************************************************************************
   > File Name: mm2s_dmacr.sv
   > Description: MM2S_DMACR Register. This register provides control for 
   >              the Memory Map to Stream DMA Channel.
   > Author: Noman Rafiq
   > Modified: Dec 30, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef MM2S_DMACR
`define MM2S_DMACR

class mm2s_dmacr extends uvm_reg;
   rand uvm_reg_field RS;
   rand uvm_reg_field RSVD1;
   rand uvm_reg_field Reset;
   rand uvm_reg_field Keyhole;
   rand uvm_reg_field Cyclic_BD_Enable;
   rand uvm_reg_field RSVD2;
   rand uvm_reg_field IOC_IrqEN;
   rand uvm_reg_field Dly_IrqEN;
   rand uvm_reg_field ERR_IrqEN;
   rand uvm_reg_field RSVD3;
   rand uvm_reg_field IRQThreshold;
   rand uvm_reg_field IRQDelay;

   `uvm_object_utils(mm2s_dmacr)
   function new(string name = "mm2s_dmacr");
     super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
   endfunction
   
   virtual function void build();
      
      // Create
      RS                 = uvm_reg_field::type_id::create("RS");
      RSVD1              = uvm_reg_field::type_id::create("RSVD1");
      Reset              = uvm_reg_field::type_id::create("Reset");
      Keyhole            = uvm_reg_field::type_id::create("Keyhole");
      Cyclic_BD_Enable   = uvm_reg_field::type_id::create("Cyclic_BD_Enable");
      RSVD2              = uvm_reg_field::type_id::create("RSVD2");
      IOC_IrqEN          = uvm_reg_field::type_id::create("IOC_IrqEN");
      Dly_IrqEN          = uvm_reg_field::type_id::create("Dly_IrqEN");
      ERR_IrqEN          = uvm_reg_field::type_id::create("ERR_IrqEN");
      RSVD3              = uvm_reg_field::type_id::create("RSVD3");
      IRQThreshold       = uvm_reg_field::type_id::create("IRQThreshold");
      IRQDelay           = uvm_reg_field::type_id::create("IRQDelay");

      /* "uvm_reg_field.configure()"
      *  Configures the Register Fields
      *  ///////  Inputs   ///////     
      *   1.   uvm_reg 	parent,
      *   2.   int unsigned size,
      *   3.   int unsigned lsb_pos,
      *   4.   string access,
      *   5.   bit volatile,
      *   6.   uvm_reg_data_t reset,
      *   7.   bit has_reset,
      *   8.   bit is_rand,
      *   9.   bit individually_accessible
      */
      RS.configure               (this, 1, 0, "RW", 0, 1'b0, 1, 1, 0);
      RSVD1.configure            (this, 1, 1, "RO", 0, 1'b1, 1, 1, 0);
      Reset.configure            (this, 1, 2, "RW", 0, 1'b0, 1, 1, 0);
      Keyhole.configure          (this, 1, 3, "RW", 0, 1'b0, 1, 1, 0);
      Cyclic_BD_Enable.configure (this, 1, 4, "RW", 0, 1'b0, 1, 1, 0);
      RSVD2.configure            (this, 7, 5, "RO", 0, 1'b0, 1, 1, 0);
      IOC_IrqEN.configure        (this, 1, 12, "RW", 0, 1'b0, 1, 1, 0);
      Dly_IrqEN.configure        (this, 1, 13, "RW", 0, 1'b0, 1, 1, 0);
      ERR_IrqEN.configure        (this, 1, 14, "RW", 0, 1'b0, 1, 1, 0);
      RSVD3.configure            (this, 1, 15, "RO", 0, 1'b0, 1, 1, 0);
      IRQThreshold.configure     (this, 8, 16, "RW", 0, 8'h1, 1, 1, 0);
      IRQDelay.configure         (this, 8, 24, "RW", 0, 8'h0, 1, 1, 0);

   endfunction
 endclass   : mm2s_dmacr

`endif