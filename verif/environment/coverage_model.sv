/*************************************************************************
   > File Name: coverage_model.sv
   > Description: Functional Coverage Class
   > Author: Noman Rafiq
   > Modified: Jan 19, 2025
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef FUNC_COV
`define FUNC_COV

`uvm_analysis_imp_decl(_axis_read)
`uvm_analysis_imp_decl(_axis_write)
`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_axi_lite)

class coverage_model extends uvm_component;
   `uvm_component_utils(coverage_model);

   // Implementation port for AXI-Stream READ Agent
   uvm_analysis_imp_axis_read   #(axis_transaction, coverage_model)     axis_read_export;
   uvm_analysis_imp_axis_write  #(axis_transaction, coverage_model)     axis_write_export;
   uvm_analysis_imp_axi_lite    #(reg_transaction, coverage_model)      axi_lite_export;
   uvm_analysis_imp_axi         #(axi_transaction, coverage_model)      axi_export;
   
   //  Constructor: new
   function new(string name = "coverage_model", uvm_component parent);
      super.new(name, parent);
      
      // Create implementation ports
      axis_read_export  = new("axis_read_export", this);
      axis_write_export = new("axis_write_export", this);
      axi_lite_export   = new("axi_lite_export", this);
      axi_export        = new("axi_export", this);

      // TODO : Create Covergroups Here
//       cg = new()

   endfunction: new

   // write methods implementation
   virtual function void write_axis_read (axis_transaction item);
        // TODO : Call cg.sample()
   endfunction : write_axis_read

   virtual function void write_axis_write (axis_transaction item);

   endfunction : write_axis_write

   virtual function void write_axi_lite (reg_transaction item);

   endfunction : write_axi_lite

   virtual function void write_axi (axi_transaction item);
        `uvm_info(`gfn, $sformatf("Received AXI Transaction in Coverage Model"), UVM_NONE)
        
   endfunction : write_axi


// Checks that the SPI master registers have
// all been accessed for both reads and writes
// covergroup reg_rw_cov;
//         option.per_instance = 1; ADDR:
//         coverpoint address {
//         bins DATA0 = {0}; bins
//         DATA1 = {4}; bins DATA2 =
//         {8}; bins DATA3 = {5'hC};
//         bins CTRL
//         = {5'h10};
//         bins DIVIDER = {5'h14};
//         bins SS = {5'h18};
//         }
//         CMD: coverpoint wnr {
//         bins RD = {0};
//         bins WR = {1};
//         }
//         RW_CROSS: cross CMD, ADDR;
// endgroup: reg_rw_cov

endclass: coverage_model

`endif