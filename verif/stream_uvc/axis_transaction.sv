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
                tlast dist {1:/1, 0:/99 }; 
        }

        constraint c_tdata { 
                tdata inside {32'h01010101, 32'h02020202, 32'h03030303, 32'h04040404, 32'h05050505, 
                32'h06060606, 32'h07070707, 32'h08080808, 32'h09090909, 32'h0a0a0a0a, 32'h0b0b0b0b, 
                32'h0c0c0c0c, 32'h0d0d0d0d, 32'h0e0e0e0e, 32'h0f0f0f0f, 32'h10101010, 32'h11111111, 
                32'h12121212, 32'h13131313, 32'h14141414, 32'h15151515, 32'h16161616, 32'h17171717, 
                32'h18181818, 32'h19191919, 32'h20202020, 32'h21212121, 32'h22222222, 32'h23232323, 
                32'h24242424, 32'h25252525, 32'h26262626, 32'h27272727, 32'h28282828, 32'h29292929}; 
        }
	
endclass : axis_transaction

`endif