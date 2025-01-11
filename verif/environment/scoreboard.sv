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
`uvm_analysis_imp_decl(_resp)
class scoreboard extends uvm_scoreboard;
   `uvm_component_utils(scoreboard);

   // Implementation port for AXI-Stream READ Agent
   uvm_analysis_imp_mm2s_read   #(axis_transaction, scoreboard) read_export;
   uvm_analysis_imp_s2mm_write  #(axis_transaction, scoreboard) write_export;

   // Response Port from AXI
   uvm_analysis_imp_resp  #(axi_transaction, scoreboard) resp_export;

   // Read and Write Queues for Comparison
   axis_transaction read_queue[$];
   axis_transaction write_queue[$];
   axi_transaction resp_queue[$];

   bit [params_pkg::ADDR_WIDTH-1:0] src_addr = `SRC_ADDR;
   bit [params_pkg::ADDR_WIDTH-1:0] dst_addr = `DST_ADDR;
   bit [7:0] written_bytes = 0;

   // Local Memory Model
   mem_model memory;

   //  Constructor: new
   function new(string name = "scoreboard", uvm_component parent);
      super.new(name, parent);

      // Create implementation ports
      read_export    = new("read_export", this);
      write_export   = new("write_export", this);
      resp_export    = new("resp_export", this);
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
      // print transaction
      // `uvm_info(get_type_name(), $sformatf("\n%s", item.sprint), UVM_LOW);
   endfunction : write_s2mm_write

   // Write Method for response Port
   virtual function void write_resp (axi_transaction item);
      `uvm_info(get_type_name(), $sformatf("Received AXI Response Transaction"), UVM_LOW);
      // Add transaction to response queue
      resp_queue.push_back(item);
   endfunction : write_resp

   task run_phase(uvm_phase phase);
      axis_transaction read_item;
      axis_transaction write_item;
      axi_transaction  resp_item;

      forever begin
         fork
            begin
               // MM2S Read Comparison
               // wait(resp_queue.size>0);
               // resp_item = resp_queue.pop_front();

               // if ((resp_item.bvalid && resp_item.bready) && (resp_item.bresp == 'h0)) begin
               wait(read_queue.size > 0);
               if (read_queue.size > 0) begin
                  read_item       = read_queue.pop_front();
                  memory.compare(src_addr, read_item.tdata, read_item.tkeep);
                  src_addr =   src_addr+4;
               end    
               // end
            end
            
            begin
               // S2MM Write Comparison
               wait(write_queue.size > 0);
               if (written_bytes <= 'h80 ) begin
                  if (write_queue.size > 0 ) begin
                     write_item     = write_queue.pop_front();
                     `uvm_info("Scoreboard :: Run Phase", $sformatf("\n%s", write_item.sprint), UVM_DEBUG);
                     memory.write(dst_addr, write_item.tdata, write_item.tkeep);
                     dst_addr =   dst_addr+4;
                  end
                  written_bytes   = dst_addr;
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