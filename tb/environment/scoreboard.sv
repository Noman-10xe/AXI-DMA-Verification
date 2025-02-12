/*************************************************************************
   > File Name: scoreboard.sv
   > Description: Scoreboard Class
   > Author: Noman Rafiq
   > Modified: Dec 31, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef SCOREBOARD
`define SCOREBOARD

`uvm_analysis_imp_decl(_mm2s_read)
`uvm_analysis_imp_decl(_s2mm_write)
`uvm_analysis_imp_decl(_axi)

class scoreboard extends uvm_scoreboard;
   `uvm_component_utils(scoreboard);

   // Implementation port for AXI-Stream READ Agent
   uvm_analysis_imp_mm2s_read    #(axis_transaction, scoreboard)  read_export;
   uvm_analysis_imp_s2mm_write   #(axis_transaction, scoreboard)  write_export;
   uvm_analysis_imp_axi          #(axi_transaction, scoreboard)   axi_export;

   // Read and Write Queues for Comparison
   axis_transaction read_queue[$];
   axis_transaction write_queue[$];
   
   int expected_bvalids = 0;

   // Environment configuration Handle
   environment_config env_cfg;
   
   // Source and Destination Addresses for Reference Memory
   bit [params_pkg::ADDR_WIDTH-1:0] src_addr;
   bit [params_pkg::ADDR_WIDTH-1:0] dst_addr;
   typedef bit [params_pkg::Byte_Lanes-1:0] mem_mask_t;
   bit [7:0] written_bytes = 0;
   
   // MM2S Interrupt Logic
   bit prev_tlast;
   // S2MM Interrupt Logic Control
   static int received_bvalid_count = 0;
   int expected_bvalid_count;
   int remainder, remain_bytes;
   bit all_bvalids_received;        // Flag for last bvalid
   bit transfer_in_progress;        // Indicates active transfer
   bit error_occurred;              // Track if an error occurred
   bit waiting_for_interrupt;       // Waiting for interrupt after BVALIDs complete
   bit irq_EN_snapshot;             // Snapshot of irq_EN at transfer start
   bit [params_pkg::ADDR_WIDTH-1:0] curr_dst_addr;
   
   // Capture configuration at transfer start
   int current_data_length;

   // Local Memory Model
   mem_model memory;

   //  Constructor: new
   function new(string name = "scoreboard", uvm_component parent);
      super.new(name, parent);

      // Create implementation ports
      read_export    = new("read_export", this);
      write_export   = new("write_export", this);
      axi_export     = new("axi_export", this);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      // Create local memory model
      memory = mem_model_pkg::mem_model#()::type_id::create("memory");

      // Initialize Local Memory
      memory.init_memory();

      // Get env_cfg
      if (!uvm_config_db#(environment_config)::get(this, get_full_name(), "env_cfg", env_cfg))
        `uvm_fatal("NOCONFIG",{"Environment Configurations must be set for: ",get_full_name()});

      // Assign Addresses for Scoreboard Reference Memory R/W
      src_addr = env_cfg.SRC_ADDR;
      dst_addr = env_cfg.DST_ADDR;

   endfunction: build_phase

   // write methods implementation
   virtual function void write_mm2s_read (axis_transaction item);

      `uvm_info(get_type_name(), $sformatf("Received AXIs Read Transaction"), UVM_HIGH);
      
      // Enable Checker if the Interrupt was configured
      if (env_cfg.irq_EN) begin
         if(prev_tlast == 1) begin
            if (item.introut != 1) begin
               `uvm_error(`gfn, $sformatf("mm2s_introut comparison failed. Act = %0d, Exp = %0d", item.introut, 1));
            end
            else begin
               `uvm_info(`gfn, "mm2s_introut comparison Passed.", UVM_NONE);
            end
         end
      end

      // Add transaction to read queue
      read_queue.push_back(item);

      prev_tlast = item.tlast;

   endfunction : write_mm2s_read

   // Stream Write Transaction
   virtual function void write_s2mm_write (axis_transaction item);

      // Add valid transaction to write queue
      if ( item.tvalid && item.tready ) begin
         `uvm_info(get_type_name(), $sformatf("Received AXIs Write Transaction"), UVM_HIGH);
         write_queue.push_back(item);
      end

   endfunction : write_s2mm_write

   function void write_axi(axi_transaction item);

      // Detect new transfer (e.g., AWVALID assertion)
      if (item.awvalid && !transfer_in_progress) begin
        // Check for missing interrupt from previous transfer
        if (waiting_for_interrupt && irq_EN_snapshot) begin
          `uvm_error(get_type_name(), "Interrupt not received after BVALIDs completed!")
        end
        reset_state();
        capture_config();
        transfer_in_progress = 1;
        `uvm_info(get_type_name(), $sformatf("New transfer started (DATA_LENGTH=%0d)", 
                  current_data_length), UVM_DEBUG)
      end
  
      // Track BVALIDs during active transfer
      if (transfer_in_progress) begin
        if (item.bvalid && item.bready) begin
          received_bvalid_count++;
          `uvm_info(get_type_name(), $sformatf("BVALID: %0d/%0d", 
                    received_bvalid_count, expected_bvalid_count), UVM_DEBUG)
  
          // Check for BVALID completion
          if (received_bvalid_count == expected_bvalid_count) begin
            all_bvalids_received = 1;
            transfer_in_progress = 0;  // BVALIDs done, wait for interrupt
            if (irq_EN_snapshot) waiting_for_interrupt = 1;
            `uvm_info(get_type_name(), "All BVALIDs received", UVM_MEDIUM)
          end
        end
      end
  
      // Handle interrupt assertion
      if (item.s2mm_introut) begin
        
        // Interrupt after BVALIDs complete
        if (waiting_for_interrupt) begin
          if (received_bvalid_count != expected_bvalid_count) begin
            `uvm_error(get_type_name(), $sformatf("FAIL: s2mm_introut asserted with a BVALID mismatch! Exp: %0d Got: %0d",
                      expected_bvalid_count, received_bvalid_count))
          end
          else if ( received_bvalid_count == expected_bvalid_count )begin
            `uvm_info(get_type_name(), "PASS: s2mm_introut asserted correctly", UVM_MEDIUM)
          end
          reset_state();
        end
      end
  
    endfunction : write_axi
  
    // Reset all state variables
    function void reset_state();
      transfer_in_progress = 0;
      waiting_for_interrupt = 0;
      received_bvalid_count = 0;
      all_bvalids_received = 0;
    endfunction
  
    // Capture configuration at transfer start
    function void capture_config();
      current_data_length = env_cfg.DATA_LENGTH;
      curr_dst_addr = env_cfg.DST_ADDR;
      irq_EN_snapshot = env_cfg.irq_EN;
      calculate_expected_bvalids();
    endfunction
  
    // Calculate expected BVALIDs
    function void calculate_expected_bvalids();
      int remainder = curr_dst_addr % 'h40; // Assuming dst_addr is the start address
      int first_burst_bytes;
    
      if (current_data_length <= 64) begin
        expected_bvalid_count = (remainder == 0) ? 1 : 2;
      end else begin
        // Handle initial misalignment
        if (remainder != 0) begin
          first_burst_bytes = 64 - remainder;
          // Case: Entire transfer fits in first two bursts
          if (current_data_length <= first_burst_bytes) begin
            expected_bvalid_count = 2;
          end 
          // Case: Multiple bursts after initial misalignment
          else begin
            int remaining_data = current_data_length - first_burst_bytes;
            expected_bvalid_count = 1 + (remaining_data / 64) + ((remaining_data % 64 != 0) ? 1 : 0);
          end
        end else begin
          // No misalignment, simple calculation
          expected_bvalid_count = (current_data_length / 64) + ((current_data_length % 64 != 0) ? 1 : 0);
        end
      end
    endfunction


   task run_phase(uvm_phase phase);
      axis_transaction read_item;
      axis_transaction write_item;

      forever begin
         fork
            begin
               if ( env_cfg.scoreboard_read ) begin
                  // MM2S Read Comparison
                  wait(read_queue.size > 0);
                  if ( read_queue.size > 0 ) begin
                     read_item       = read_queue.pop_front();
                     memory.compare(src_addr, read_item.tdata, read_item.tkeep);
                     src_addr = src_addr + calculate_offset(read_item.tkeep);
                  end
               end
            end
            
            begin
               if ( env_cfg.scoreboard_write ) begin
                  // S2MM Write Comparison
                  wait(write_queue.size > 0);
                     if (write_queue.size > 0 ) begin
                        write_item     = write_queue.pop_front();
                        memory.write(dst_addr, write_item.tdata, write_item.tkeep);
                        dst_addr = dst_addr + calculate_offset(write_item.tkeep);
                        written_bytes   = dst_addr;
                  end
               end
            end
         join

         `uvm_info("DBG", $sformatf("Written Bytes = %0d", written_bytes), UVM_DEBUG);
      end
      
   endtask : run_phase

   function void report_phase(uvm_phase phase);
      uvm_report_server svr;
      super.report_phase(phase);
      svr = uvm_report_server::get_server();

      if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
         `uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "---            TEST FAILED         ---", UVM_NONE)
         `uvm_info(get_type_name(), "--------------------------------------", UVM_NONE)
      end
      else begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "---           TEST PASSED           ---", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
   endfunction : report_phase

   function int unsigned calculate_offset(mem_mask_t tkeep);
      int unsigned offset = 0;
      offset = 0;
      for (int i = 0; i < $bits(tkeep); i++) begin
          if (tkeep[i]) offset++;
      end
      return offset;
   endfunction

endclass: scoreboard

`endif