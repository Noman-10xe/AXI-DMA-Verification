// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
`ifndef MEM_MODEL
`define MEM_MODEL

class mem_model #(int AddrWidth = params_pkg::ADDR_WIDTH,
                  int DataWidth = params_pkg::DATA_WIDTH,
                  int MaskWidth = params_pkg::Byte_Lanes) extends uvm_object;

  typedef bit [AddrWidth-1:0] mem_addr_t;
  typedef bit [DataWidth-1:0] mem_data_t;
  typedef bit [MaskWidth-1:0] mem_mask_t;

  bit [7:0] system_memory[mem_addr_t];

  `uvm_object_param_utils(mem_model#(AddrWidth, DataWidth))

  `uvm_object_new

  function int get_written_bytes();
    return system_memory.size();
  endfunction

  function bit [7:0] read_byte(mem_addr_t addr);
    bit [7:0] data;
    if (system_memory.exists(addr)) begin
      data = system_memory[addr];
      `uvm_info(`gfn, $sformatf("Read Mem  : Addr[0x%0h], Data[0x%0h]", addr, data), UVM_HIGH)
    end else begin
      `uvm_info(`gfn, $sformatf("Read Mem  : Addr[0x%0h], Data[0x%0h]", addr, data), UVM_LOW)
      `DV_CHECK_STD_RANDOMIZE_FATAL(data)
      `uvm_error(`gfn, $sformatf("read to uninitialzed addr 0x%0h", addr))
    end
    return data;
  endfunction

  function void write_byte(mem_addr_t addr, bit [7:0] data);
    `uvm_info(`gfn, $sformatf("Write Mem : Addr[0x%0h], Data[0x%0h]", addr, data), UVM_LOW)
    system_memory[addr] = data;
  endfunction

  function void compare_byte(mem_addr_t addr, bit [7:0] act_data);
   `uvm_info(`gfn, $sformatf("Compare Mem : Addr[0x%0h], Act Data[0x%0h], Exp Data[0x%0h]",
                             addr, act_data, system_memory[addr]), UVM_LOW)
    `DV_CHECK_EQ(act_data, system_memory[addr], $sformatf("addr 0x%0h read out mismatch", addr))
  endfunction

  function void write(input mem_addr_t addr, mem_data_t data, mem_mask_t mask = '1);
    bit [7:0] byte_data;
    for (int i = 0; i < DataWidth / 8; i++) begin
      if (mask[0]) begin
        byte_data = data[7:0];
        write_byte(addr + i, byte_data);
      end
      data = data >> 8;
      mask = mask >> 1;
    end
  endfunction

  function mem_data_t read(mem_addr_t addr, mem_mask_t mask = '1);
    mem_data_t data;
    for (int i = DataWidth / 8 - 1; i >= 0; i--) begin
      data = data << 8;
      if (mask[MaskWidth - 1]) data[7:0] = read_byte(addr + i);
      else                     data[7:0] = 0;
      mask = mask << 1;
    end
    return data;
  endfunction

  function void compare(mem_addr_t addr, mem_data_t act_data, mem_mask_t mask = '1);
    bit [7:0] byte_data;

    // Calculate starting byte offset within the word
    int start_byte = addr % (DataWidth / 8);

    // Iterate over only the bytes specified by the mask
    for (int i = 0; i < $bits(mask); i++) begin
        if (mask[i]) begin
            // Calculate the byte address within the word
            int byte_addr = addr + (i - start_byte);

            // Extract the corresponding byte from act_data
            byte_data = act_data >> (8 * i);

            // Compare the byte
            compare_byte(byte_addr, byte_data);
        end
    end
endfunction



  // First 22 words to reflect init_file.coe, rest will be deadbeef
  mem_data_t init_values[22] = '{ 'h1, 'h2, 'h3, 'h4, 'h5, 'h6, 'h7, 'h8, 'h9, 'h10, 'h11, 
                                  'h12, 'h13, 'h14, 'h15, 'h16, 'h1A, 'h1B, 'h1C, 'h1D, 'h1E, 
                                  'h1F };

  function void init_memory();
    mem_addr_t addr = 0;
  
    // Initialize the entire memory with DEADBEEF in little-endian format
    for (addr = 0; addr < 32768; addr += 4) begin
      system_memory[addr]     = 8'hEF; // Byte 0 (LSB of DEADBEEF)
      system_memory[addr + 1] = 8'hBE; // Byte 1
      system_memory[addr + 2] = 8'hAD; // Byte 2
      system_memory[addr + 3] = 8'hDE; // Byte 3 (MSB of DEADBEEF)
    end

    addr = 0;
    foreach (init_values[i]) begin
      system_memory[addr]     = init_values[i][7:0];
      system_memory[addr + 1] = init_values[i][15:8];
      system_memory[addr + 2] = init_values[i][23:16];
      system_memory[addr + 3] = init_values[i][31:24];
      addr += 4;
    end
    
  endfunction : init_memory

endclass
`endif