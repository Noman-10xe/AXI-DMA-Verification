/*************************************************************************
   > File Name: mm2s_dmasr.sv
   > Description: MM2S DMA Status Register. It provides the status
   >              for the Memory Map to Stream DMA Channel.
   > Author: Noman Rafiq
   > Modified: Dec 30, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef MM2S_DMASR
`define MM2S_DMASR

class mm2s_dmasr extends uvm_reg;
   
   // Fields
   rand uvm_reg_field Halted;
   rand uvm_reg_field Idle;
   rand uvm_reg_field RSVD1;
   rand uvm_reg_field SGIncld;
   rand uvm_reg_field DMAIntErr;
   rand uvm_reg_field DMASlvErr;
   rand uvm_reg_field DMADecErr;
   rand uvm_reg_field RSVD2;
   rand uvm_reg_field SGIntErr;
   rand uvm_reg_field SGSlvErr;
   rand uvm_reg_field SGDecErr;
   rand uvm_reg_field RSVD3;
   rand uvm_reg_field IOC_Irq;
   rand uvm_reg_field Dly_Irq;
   rand uvm_reg_field Err_Irq;
   rand uvm_reg_field RSVD4;
   rand uvm_reg_field IRQThresholdSts;
   rand uvm_reg_field IRQDelaySts;
   
   `uvm_object_utils(mm2s_dmasr)

   function new(string name = "mm2s_dmasr");
     super.new(name, 32, build_coverage(UVM_NO_COVERAGE));
   endfunction
   
   virtual function void build();
      
      // Create
      Halted            = uvm_reg_field::type_id::create("Halted");
      Idle              = uvm_reg_field::type_id::create("Idle");
      RSVD1             = uvm_reg_field::type_id::create("RSVD1");
      SGIncld           = uvm_reg_field::type_id::create("SGIncld");
      DMAIntErr         = uvm_reg_field::type_id::create("DMAIntErr");
      DMASlvErr         = uvm_reg_field::type_id::create("DMASlvErr");
      DMADecErr         = uvm_reg_field::type_id::create("DMADecErr");
      RSVD2             = uvm_reg_field::type_id::create("RSVD2");
      SGIntErr          = uvm_reg_field::type_id::create("SGIntErr");
      SGSlvErr          = uvm_reg_field::type_id::create("SGSlvErr");
      SGDecErr          = uvm_reg_field::type_id::create("SGDecErr");
      RSVD3             = uvm_reg_field::type_id::create("RSVD3");
      IOC_Irq           = uvm_reg_field::type_id::create("IOC_Irq");
      Dly_Irq           = uvm_reg_field::type_id::create("Dly_Irq");
      Err_Irq           = uvm_reg_field::type_id::create("Err_Irq");
      RSVD4             = uvm_reg_field::type_id::create("RSVD4");
      IRQThresholdSts   = uvm_reg_field::type_id::create("IRQThresholdSts");
      IRQDelaySts       = uvm_reg_field::type_id::create("IRQDelaySts");

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
      Halted.configure           (this, 1, 0, "RO", 0, 1'b1, 1, 1, 0);
      Idle.configure             (this, 1, 1, "RO", 0, 1'b0, 1, 1, 0);
      RSVD1.configure            (this, 1, 2, "RO", 0, 1'b0, 1, 1, 0);
      SGIncld.configure          (this, 1, 3, "RO", 0, 1'b0, 1, 1, 0);
      DMAIntErr.configure        (this, 1, 4, "RO", 0, 1'b0, 1, 1, 0);
      DMASlvErr.configure        (this, 1, 5, "RO", 0, 1'b0, 1, 1, 0);
      DMADecErr.configure        (this, 1, 6, "RO", 0, 1'b0, 1, 1, 0);
      RSVD2.configure            (this, 1, 7, "RO", 0, 1'b0, 1, 1, 0);
      SGIntErr.configure         (this, 1, 8, "RO", 0, 1'b0, 1, 1, 0);
      SGSlvErr.configure         (this, 1, 9, "RO", 0, 1'b0, 1, 1, 0);
      SGDecErr.configure         (this, 1, 10, "RO", 0, 1'b0, 1, 1, 0);
      RSVD3.configure            (this, 1, 11, "RO", 0, 1'b0, 1, 1, 0);
      IOC_Irq.configure          (this, 1, 12, "WC", 0, 1'b0, 1, 1, 0);
      Dly_Irq.configure          (this, 1, 13, "WC", 0, 1'b0, 1, 1, 0);
      Err_Irq.configure          (this, 1, 14, "WC", 0, 1'b0, 1, 1, 0);
      RSVD4.configure            (this, 1, 15, "RO", 0, 1'b0, 1, 1, 0);
      IRQThresholdSts.configure  (this, 8, 16, "RO", 0, 8'h1, 1, 1, 0);
      IRQDelaySts.configure      (this, 8, 24, "RO", 0, 8'h0, 1, 1, 0);

   endfunction
 endclass   : mm2s_dmasr

`endif