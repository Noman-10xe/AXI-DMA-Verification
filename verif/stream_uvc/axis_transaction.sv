/*************************************************************************
   > File Name: axis_transaction.sv
   > Description: Transation Item Class for AXI-Stream Interface
   > Author: Noman Rafiq
   > Modified: Dec 20, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXIS_TRANSACTION
`define AXIS_TRANSACTION

class axis_transaction extends uvm_sequence_item;

        rand bit [ params_pkg::DATA_WIDTH-1             :       0 ]     tdata;
        rand bit [              3                       :       0 ]     tkeep;
        rand bit                                                        tvalid;
        rand bit                                                        tready;
        rand bit                                                        tlast;
        rand bit                                                        introut;

	// Constructor
	function new ( string name = "axis_transaction" );
		super.new(name);
	endfunction : new
	
	`uvm_object_utils_begin(axis_transaction)
                `uvm_field_int      (tdata,     UVM_DEFAULT)
	    	`uvm_field_int      (tkeep,     UVM_DEFAULT)
	    	`uvm_field_int      (tvalid,    UVM_DEFAULT)
	    	`uvm_field_int      (tready,    UVM_DEFAULT)
	    	`uvm_field_int      (tlast,     UVM_DEFAULT)
                `uvm_field_int      (introut,   UVM_DEFAULT)
  	`uvm_object_utils_end

        //////////////////////////////////////////////////////////////////////
        //                          Constraints                             //
        //////////////////////////////////////////////////////////////////////
        constraint c_tkeep {
                tkeep == 4'hf;
        }
        
        constraint c_tvalid { 
                tvalid == 1'b1;
        }

        constraint c_tready { 
                tready == 1'b1;
        }

        constraint c_tlast {  
                tlast == 0;
        }

        constraint c_tdata { 
                tdata inside {32'h00000101, 32'h00020202, 32'h03030303, 32'h04040404, 32'h5050505,
                32'h0000FFFF, 32'hFFFFFFFF, 32'h00100000, 32'h00000000, 32'h00000001, 32'h00001000,
                32'h1000FFFF, 32'h00000FFF, 32'h0010000F, 32'ha0a0a0b0, 32'h0c000001, 32'hFFFF1000};
        }
	
endclass : axis_transaction

`endif