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

   bit [params_pkg::ADDR_WIDTH-1:0] src_addr = `SRC_ADDR;
   bit [params_pkg::ADDR_WIDTH-1:0] dst_addr = `DST_ADDR;

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
   endfunction: build_phase

   // write methods implementation
   virtual function void write_mm2s_read (axis_transaction item);
      `uvm_info(get_type_name(), $sformatf("Received AXIs Read Transaction"), UVM_NONE);
      // Add transaction to read queue
      read_queue.push_back(item);
   endfunction : write_mm2s_read

   virtual function void write_s2mm_write (axis_transaction item);
      `uvm_info(get_type_name(), $sformatf("Received AXIs Write Transaction"), UVM_NONE);
      // Add transaction to write queue
      write_queue.push_back(item);
   endfunction : write_s2mm_write

   task run_phase(uvm_phase phase);
      axis_transaction read_item;
      axis_transaction write_item;

      forever begin
         fork
            begin
               // MM2S Read Comparison
               wait(read_queue.size > 0);

               if (read_queue.size > 0) begin
                 read_item       = read_queue.pop_front();
                 memory.compare(src_addr, read_item.tdata, read_item.tkeep);
                 src_addr =   src_addr+4;
               end
            end

            begin
               // S2MM Write Comparison
               wait(write_queue.size > 0);

               if (write_queue.size > 0) begin
                  write_item     = write_queue.pop_front();
                 memory.write(dst_addr, write_item.tdata, write_item.tkeep);
                 dst_addr =   dst_addr+4;
               end
            end
         join
      end
   endtask : run_phase

   function void report_phase(uvm_phase phase);
      uvm_report_server svr;
      super.report_phase(phase);
      svr = uvm_report_server::get_server();

      if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "---            TEST FAILED          ---", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
      else begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "---           TEST PASSED           ---", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
   endfunction : report_phase

endclass: scoreboard
`endif