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
  environment_config cfg;
  reg_transaction item;
      
  // Constructor
  function new(string name="base_sequence");
    super.new(name);
  endfunction : new

  task pre_body();
    uvm_config_db #(environment_config)::get(null, get_full_name(), "env_cfg", cfg);
  endtask

endclass : base_sequence

//////////////////////////////////////////////////////////////////////
//                        RAL Model Reset Sequence                  //
//////////////////////////////////////////////////////////////////////

class ral_reset_sequence extends base_sequence;
  `uvm_object_utils(ral_reset_sequence)
  
   reg_block RAL_Model;
  function new (string name = "ral_reset_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e   status;
    bit [31:0] data;
    bit [31:0] expected;     // Expected Value
  
    // MM2S Control Register
    RAL_Model.MM2S_DMACR.read(status, data);
    expected = RAL_Model.MM2S_DMACR.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // MM2S Status Register
    RAL_Model.MM2S_DMASR.read(status, data);
    expected = RAL_Model.MM2S_DMASR.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // MM2S Source Address Register
    RAL_Model.MM2S_SA.read(status, data);
    expected = RAL_Model.MM2S_SA.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_SA Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // MM2S Source Address Register (MSB)
    RAL_Model.MM2S_SA_MSB.read(status, data);
    expected = RAL_Model.MM2S_SA_MSB.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_SA_MSB Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // MM2S Length Register
    RAL_Model.MM2S_LENGTH.read(status, data);
    expected = RAL_Model.MM2S_LENGTH.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));


    ////////////////////////////////////////////////
    //                S2MM Register               //
    ////////////////////////////////////////////////
    // S2MM Control Register
    RAL_Model.S2MM_DMACR.read(status, data);
    expected = RAL_Model.S2MM_DMACR.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // S2MM Status Register
    RAL_Model.S2MM_DMASR.read(status, data);
    expected = RAL_Model.S2MM_DMASR.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // S2MM Destination Address Register
    RAL_Model.S2MM_DA.read(status, data);
    expected = RAL_Model.S2MM_DA.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DA Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // S2MM Destination Address Register (MSB)
    RAL_Model.S2MM_DA_MSB.read(status, data);
    expected = RAL_Model.S2MM_DA_MSB.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DA_MSB Mismatch:: Act = %0h, Exp = %0h", data, expected));

    // S2MM Length Register
    RAL_Model.S2MM_LENGTH.read(status, data);
    expected = RAL_Model.S2MM_LENGTH.get_reset();
    
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : ral_reset_sequence

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
    bit [31:0]    mv;     // Mirrored value
  
    if (cfg.irq_EN) begin
    data = 32'h11001;
    end
    else begin
    data = 32'h10001;
    end

    RAL_Model.MM2S_DMACR.write(status, data);
    mv = RAL_Model.MM2S_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, mv, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, mv));

    data = cfg.SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);
    mv = RAL_Model.MM2S_SA.get_mirrored_value();
    `DV_CHECK_EQ(data, mv, $sformatf("MM2S_SA Mismatch:: Act = %0h, Exp = %0h", data, mv));


    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);
    mv = RAL_Model.MM2S_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, mv, $sformatf("MM2S_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, mv));

   endtask
endclass : mm2s_enable_sequence


//////////////////////////////////////////////////////////////////////
//                     MM2S Custom Sequence                         //
//////////////////////////////////////////////////////////////////////

class mm2s_custom_sequence extends base_sequence;
  `uvm_object_utils(mm2s_custom_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_custom_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
  
    /* To Enable Err_IrqEn: data = 32'h14003;
     */
    if (cfg.irq_EN) begin
      data = 32'h11001;
    end
    else begin
      data = 32'h10001;
    end

    RAL_Model.MM2S_DMACR.write(status, data);

    data = cfg.SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);

    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);

   endtask
endclass : mm2s_custom_sequence


//////////////////////////////////////////////////////////////////////
//                 MM2S Boundary Test Sequence                      //
//////////////////////////////////////////////////////////////////////

class mm2s_boundary_sequence extends base_sequence;
  `uvm_object_utils(mm2s_boundary_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_boundary_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;

    if (cfg.irq_EN) begin
      data = 32'h11001;
    end
    else begin
      data = 32'h10001;
    end

    RAL_Model.MM2S_DMACR.write(status, data);
    expected = RAL_Model.MM2S_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = cfg.SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);
    expected = RAL_Model.MM2S_SA.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_SA Mismatch:: Act = %0h, Exp = %0h", data, expected));


    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);
    expected = RAL_Model.MM2S_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : mm2s_boundary_sequence


//////////////////////////////////////////////////////////////////////
//                  MM2S slave Error Sequence                       //
//////////////////////////////////////////////////////////////////////

class mm2s_SlvErr_sequence extends base_sequence;
  `uvm_object_utils(mm2s_SlvErr_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_SlvErr_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
    
    /* To Enable Err_IrqEn: data = 32'h14001;
     */

    if (cfg.irq_EN) begin
      data = 32'h14001;
    end
    else begin
      data = 32'h10001;
    end

    RAL_Model.MM2S_DMACR.write(status, data);
    expected = RAL_Model.MM2S_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));


    data = cfg.SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);
    expected = RAL_Model.MM2S_SA.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_SA Mismatch:: Act = %0h, Exp = %0h", data, expected));


    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);
    expected = RAL_Model.MM2S_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : mm2s_SlvErr_sequence


//////////////////////////////////////////////////////////////////////
//                  MM2S Decode Error Sequence                      //
//////////////////////////////////////////////////////////////////////

class mm2s_DecErr_sequence extends base_sequence;
  `uvm_object_utils(mm2s_DecErr_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_DecErr_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;

    /* To Enable Err_IrqEn: data = 32'h14001;
     */
    if (cfg.irq_EN) begin
      data = 32'h14001;
    end
    else begin
      data = 32'h10001;
    end

    RAL_Model.MM2S_DMACR.write(status, data);
    expected = RAL_Model.MM2S_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));


    // Write an Invalid Address to generate a Decode Error
    data = cfg.SRC_ADDR;
    RAL_Model.MM2S_SA.write(status, data);
    expected = RAL_Model.MM2S_SA.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_SA Mismatch:: Act = %0h, Exp = %0h", data, expected));


    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);
    expected = RAL_Model.MM2S_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : mm2s_DecErr_sequence


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
    bit [31:0]    expected;     // Expected
  
    if (cfg.irq_EN) begin
      data = 32'h11001;
    end
    else begin
      data = 32'h10001;
    end

    RAL_Model.S2MM_DMACR.write(status, data);
    expected = RAL_Model.S2MM_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = cfg.DST_ADDR;
    RAL_Model.S2MM_DA.write(status, data);
    expected = RAL_Model.S2MM_DA.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DA Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = cfg.DATA_LENGTH;
    RAL_Model.S2MM_LENGTH.write(status, data);
    expected = RAL_Model.S2MM_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : s2mm_enable_sequence


//////////////////////////////////////////////////////////////////////
//                      S2MM Custom Sequence                         //
//////////////////////////////////////////////////////////////////////

class s2mm_custom_sequence extends base_sequence;
  `uvm_object_utils(s2mm_custom_sequence)
  
   reg_block RAL_Model;
  function new (string name = "s2mm_custom_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
 
    if (cfg.irq_EN) begin
      data = 32'h11001;
    end
    else begin
      data = 32'h10001;
    end
    
    RAL_Model.S2MM_DMACR.write(status, data);
    RAL_Model.S2MM_DMACR.read(status, data);
    expected = RAL_Model.S2MM_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = cfg.DST_ADDR;
    RAL_Model.S2MM_DA.write(status, data);
    expected = RAL_Model.S2MM_DA.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DA Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = cfg.DATA_LENGTH;
    RAL_Model.S2MM_LENGTH.write(status, data);
    expected = RAL_Model.S2MM_LENGTH.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_LENGTH Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : s2mm_custom_sequence

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
    bit [31:0]    expected;     // Desired Value & Mirrored Values
  
      RAL_Model.MM2S_DMACR.read(status, data);  
      
      data = 32'h4;
      RAL_Model.MM2S_DMACR.write(status, data);

      RAL_Model.MM2S_DMACR.read(status, data);

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
    bit [31:0]    expected;
    
      RAL_Model.MM2S_DMASR.read(status, data);
      expected = RAL_Model.MM2S_DMASR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

      RAL_Model.S2MM_DMASR.read(status, data);
      expected = RAL_Model.S2MM_DMASR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));  
    
   endtask
endclass : read_status_sequence


//////////////////////////////////////////////////////////////////////
//                    Clear MM2S Introut Sequence                   //
//////////////////////////////////////////////////////////////////////

class clear_mm2s_introut_sequence extends base_sequence;
  `uvm_object_utils(clear_mm2s_introut_sequence)
  
   reg_block RAL_Model;
  function new (string name = "clear_mm2s_introut_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
      
    RAL_Model.MM2S_DMASR.read(status, data);
    expected = RAL_Model.MM2S_DMASR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    data = 32'h1000; // Clears Interrupt (IOC)
    RAL_Model.MM2S_DMASR.write(status, data);

    // Read for Sanity
    RAL_Model.MM2S_DMASR.read(status, data);
    expected = RAL_Model.MM2S_DMASR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : clear_mm2s_introut_sequence


//////////////////////////////////////////////////////////////////////
//                      MM2S_LENGTH Sequence                        //
//////////////////////////////////////////////////////////////////////

class mm2s_length_sequence extends base_sequence;
  `uvm_object_utils(mm2s_length_sequence)
  
   reg_block RAL_Model;
  function new (string name = "mm2s_length_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
      
    data = cfg.DATA_LENGTH;
    RAL_Model.MM2S_LENGTH.write(status, data);

   endtask
endclass : mm2s_length_sequence


//////////////////////////////////////////////////////////////////////
//                      S2MM_LENGTH Sequence                        //
//////////////////////////////////////////////////////////////////////

class s2mm_length_sequence extends base_sequence;
  `uvm_object_utils(s2mm_length_sequence)
  
   reg_block RAL_Model;
  function new (string name = "s2mm_length_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
      
    data = cfg.DATA_LENGTH;
    RAL_Model.S2MM_LENGTH.write(status, data);

   endtask
endclass : s2mm_length_sequence

//////////////////////////////////////////////////////////////////////
//                  Clear S2MM Introut Sequence                     //
//////////////////////////////////////////////////////////////////////

class clear_s2mm_introut_sequence extends base_sequence;
  `uvm_object_utils(clear_s2mm_introut_sequence)
  
   reg_block RAL_Model;
  function new (string name = "clear_s2mm_introut_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
      
      RAL_Model.S2MM_DMASR.read(status, data);
      expected = RAL_Model.S2MM_DMASR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

      data = 32'h1000; // Clears Interrupt (IOC)
      RAL_Model.S2MM_DMASR.write(status, data);

      // Read for Sanity
      RAL_Model.S2MM_DMASR.read(status, data);
      expected = RAL_Model.S2MM_DMASR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : clear_s2mm_introut_sequence


//////////////////////////////////////////////////////////////////////
//                    Stop MM2S Channel Seq                         //
//////////////////////////////////////////////////////////////////////

class stop_mm2s_sequence extends base_sequence;
  `uvm_object_utils(stop_mm2s_sequence)
  
   reg_block RAL_Model;
  function new (string name = "stop_mm2s_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;
      
      RAL_Model.MM2S_DMACR.read(status, data);

      data = 1'b0;
      // Set bit[0] to 0 (Stop Channel)
      RAL_Model.MM2S_DMACR.write(status, data);
      RAL_Model.S2MM_DMACR.write(status, data);
      
      // Check Value again
      RAL_Model.S2MM_DMACR.read(status, data);
      RAL_Model.MM2S_DMACR.read(status, data);
      expected = RAL_Model.MM2S_DMACR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

      // Check Status Register
      RAL_Model.S2MM_DMASR.read(status, data);
      RAL_Model.MM2S_DMASR.read(status, data);
      expected = RAL_Model.MM2S_DMASR.get_mirrored_value();
      `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Halted Bit Mismatch:: Act = %0h, Exp = %0h", data, expected));

   endtask
endclass : stop_mm2s_sequence

//////////////////////////////////////////////////////////////////////
//                 Read Registers Sequence                          //
//////////////////////////////////////////////////////////////////////

class read_registers_sequence extends base_sequence;
  `uvm_object_utils(read_registers_sequence)
  
   reg_block RAL_Model;
  function new (string name = "read_registers_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;

    RAL_Model.MM2S_DMACR.read(status, data);
    expected = RAL_Model.MM2S_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    RAL_Model.MM2S_DMASR.read(status, data);
    expected = RAL_Model.MM2S_DMASR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("MM2S_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));
    

    RAL_Model.S2MM_DMACR.read(status, data);
    expected = RAL_Model.S2MM_DMACR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMACR Mismatch:: Act = %0h, Exp = %0h", data, expected));

    RAL_Model.S2MM_DMASR.read(status, data);
    expected = RAL_Model.S2MM_DMASR.get_mirrored_value();
    `DV_CHECK_EQ(data, expected, $sformatf("S2MM_DMASR Mismatch:: Act = %0h, Exp = %0h", data, expected));


   endtask
endclass : read_registers_sequence



////////////////////////////////////////
//          Coverage Tests            //
////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//                 Read Registers Sequence                          //
//////////////////////////////////////////////////////////////////////

class random_reg_sequence extends base_sequence;
  `uvm_object_utils(random_reg_sequence)
  
   reg_block RAL_Model;
  function new (string name = "random_reg_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    addr;
 
    ///////////  MM2S Registers ///////////////
    // Writing 1s

    data = 'hFFFFFFFF;
    RAL_Model.MM2S_DMACR.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.MM2S_DMASR.write(status, data);
    
    data = 'hFFFFFFFF;
    RAL_Model.MM2S_SA.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.MM2S_SA_MSB.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.MM2S_LENGTH.write(status, data);

    ///////////  MM2S Registers ///////////////
    // Writing 0s
    data = 'h0;
    RAL_Model.MM2S_DMACR.write(status, data);

    data = 'h0;
    RAL_Model.MM2S_DMASR.write(status, data);
    
    data = 'h0;
    RAL_Model.MM2S_SA.write(status, data);

    data = 'h0;
    RAL_Model.MM2S_SA_MSB.write(status, data);

    data = 'h0;
    RAL_Model.MM2S_LENGTH.write(status, data);

    ///////////  MM2S Registers ///////////////
    // Writing random
    data = $urandom;
    RAL_Model.MM2S_DMACR.write(status, data);

    data = $urandom;
    RAL_Model.MM2S_DMASR.write(status, data);
    
    data = $urandom;
    RAL_Model.MM2S_SA.write(status, data);

    data = $urandom;
    RAL_Model.MM2S_SA_MSB.write(status, data);

    data = $urandom;
    RAL_Model.MM2S_LENGTH.write(status, data);

    ///////////  S2MM Registers ///////////////
    // Writing 1s
    data = 'hFFFFFFFF;
    RAL_Model.S2MM_DMACR.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.S2MM_DMASR.write(status, data);
    
    data = 'hFFFFFFFF;
    RAL_Model.S2MM_DA.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.S2MM_DA_MSB.write(status, data);

    data = 'hFFFFFFFF;
    RAL_Model.S2MM_LENGTH.write(status, data);

    ///////////  S2MM Registers ///////////////
    // Writing 0s
    data = 'h0;
    RAL_Model.S2MM_DMACR.write(status, data);

    data = 'h0;
    RAL_Model.S2MM_DMASR.write(status, data);
    
    data = 'h0;
    RAL_Model.S2MM_DA.write(status, data);

    data = 'h0;
    RAL_Model.S2MM_DA_MSB.write(status, data);

    data = 'h0;
    RAL_Model.S2MM_LENGTH.write(status, data);


    ///////////  S2MM Registers ///////////////
    // Writing Random Values
    data = $urandom;
    RAL_Model.S2MM_DMACR.write(status, data);

    data = $urandom;
    RAL_Model.S2MM_DMASR.write(status, data);
    
    data = $urandom;
    RAL_Model.S2MM_DA.write(status, data);

    data = $urandom;
    RAL_Model.S2MM_DA_MSB.write(status, data);

    data = $urandom;
    RAL_Model.S2MM_LENGTH.write(status, data);

   endtask
endclass : random_reg_sequence


// Read All Registers one by one
class read_allreg_sequence extends base_sequence;
  `uvm_object_utils(read_allreg_sequence)
  
   reg_block RAL_Model;
  function new (string name = "read_allreg_sequence");
    super.new(name);  
  endfunction
  
  task body;
    uvm_status_e  status;
    bit [31:0]    data;
    bit [31:0]    expected;

    RAL_Model.MM2S_DMACR.read(status, data);
    RAL_Model.MM2S_DMASR.read(status, data); 
    RAL_Model.MM2S_SA.read(status, data); 
    RAL_Model.MM2S_SA_MSB.read(status, data); 
    RAL_Model.MM2S_LENGTH.read(status, data); 

    RAL_Model.S2MM_DMACR.read(status, data);
    RAL_Model.S2MM_DMASR.read(status, data); 
    RAL_Model.S2MM_DA.read(status, data); 
    RAL_Model.S2MM_DA_MSB.read(status, data); 
    RAL_Model.S2MM_LENGTH.read(status, data); 

   endtask
endclass : read_allreg_sequence


// Randomly Generates Read/Writes for Axi Lite
class random_rw_seq extends base_sequence;
  `uvm_object_utils(random_rw_seq)
  
  function new (string name = "random_rw_seq");
    super.new(name);  
  endfunction
  
  task body;
    bit [31:0]    addr;

    item  = reg_transaction::type_id::create("item");
    // item.c_addr.constraint_mode(0);
    item.c_read_transaction.constraint_mode(0);
    item.c_write_transaction.constraint_mode(0);

    repeat(150)  begin
      start_item(item);
        if(!item.randomize()) begin
          `uvm_error(get_type_name(), "Randomization failed");
        end
      finish_item(item);
    end

   endtask
endclass : random_rw_seq


// Testing Axi Lite
class testing_seq extends base_sequence;
  `uvm_object_utils(testing_seq)
  
  function new (string name = "testing_seq");
    super.new(name);  
  endfunction
  
  task body;
    bit [31:0]    addr;

    item  = reg_transaction::type_id::create("item");
    item.c_addr.constraint_mode(0);
    item.c_read_transaction.constraint_mode(0);
    item.c_write_transaction.constraint_mode(0);

    repeat(10)  begin
      start_item(item);
        if(!item.randomize() with { item.s_axi_lite_araddr == 'h2C;
                                    item.s_axi_lite_awaddr == 'h2C; }) begin
          `uvm_error(get_type_name(), "Randomization failed");
        end
      finish_item(item);
    end

   endtask
endclass : testing_seq

`endif