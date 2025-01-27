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

class scoreboard extends uvm_scoreboard;
   `uvm_component_utils(scoreboard);

   // Implementation port for AXI-Stream READ Agent
   uvm_analysis_imp_mm2s_read   #(axis_transaction, scoreboard) read_export;
   uvm_analysis_imp_s2mm_write  #(axis_transaction, scoreboard) write_export;

   // Read and Write Queues for Comparison
   axis_transaction read_queue[$];
   axis_transaction write_queue[$];
   
   bit mm2s_prev_tlast = 0;
   int count = 0;

   // Environment configuration Handle
   environment_config env_cfg;
   
   // Source and Destination Addresses for Reference Memory
   bit [params_pkg::ADDR_WIDTH-1:0] src_addr;
   bit [params_pkg::ADDR_WIDTH-1:0] dst_addr;
   typedef bit [params_pkg::Byte_Lanes-1:0] mem_mask_t;
   bit [7:0] written_bytes = 0;

   // Local Memory Model
   mem_model memory;

   //  Constructor: new
   function new(string name = "scoreboard", uvm_component parent);
      super.new(name, parent);

      // Create implementation ports
      read_export    = new("read_export", this);
      write_export   = new("write_export", this);
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

      if ( item.tvalid && item.tready ) begin
         `uvm_info(get_type_name(), $sformatf("Received AXIs Read Transaction"), UVM_HIGH);

         // Add transaction to read queue
         read_queue.push_back(item);
      end
      
      if (mm2s_prev_tlast) begin

         if (item.introut != 1) begin
            `uvm_error(`gfn, $sformatf("mm2s_introut comparison failed. Act = %0d, Exp = %0d", item.introut, 1));
         end
         else begin
            `uvm_info(`gfn, "mm2s_introut comparison Passed.", UVM_NONE);
         end
      end

      mm2s_prev_tlast = item.tlast;
      
   endfunction : write_mm2s_read

   virtual function void write_s2mm_write (axis_transaction item);

      // Add valid transaction to write queue
      if ( item.tvalid && item.tready ) begin
         `uvm_info(get_type_name(), $sformatf("Received AXIs Write Transaction"), UVM_HIGH);
         write_queue.push_back(item);
      end

      if (item.tlast) begin

         if ( count == 37 ) begin
            if (item.introut != 1) begin
               `uvm_error(`gfn, $sformatf("s2mm_introut comparison failed. Act = %0d, Exp = %0d", item.introut, 1));
            end
            else begin
               `uvm_info(`gfn, "s2mm_introut comparison Passed.", UVM_NONE);
               count = 0;
            end
         end
         count++;
      end

   endfunction : write_s2mm_write

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