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
                tlast dist {1:/ 1, 0:/9 }; 
        }
	
endclass : axis_transaction

`endif