/*************************************************************************
   > File Name: reg_transaction.sv
   > Description: Transation Item Class for AXI-lite Interface
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef REG_TRANSACTION
`define REG_TRANSACTION

class reg_transaction extends uvm_sequence_item;
	
        rand    bit                                   s_axi_lite_awvalid;
        rand    bit                                   s_axi_lite_awready;
        randc   bit     [ 9             :   0]        s_axi_lite_awaddr;
        rand    bit                                   s_axi_lite_wvalid;
        rand    bit                                   s_axi_lite_wready;
        rand    bit     [ DATA_WIDTH-1  :   0]        s_axi_lite_wdata;
        rand    bit     [ 1             :   0]        s_axi_lite_bresp;
        rand    bit                                   s_axi_lite_bvalid;
        rand    bit                                   s_axi_lite_bready;
        rand    bit                                   s_axi_lite_arvalid;
        rand    bit                                   s_axi_lite_arready;
        randc   bit     [ 9             :   0]        s_axi_lite_araddr;
        rand    bit                                   s_axi_lite_rvalid;
        rand    bit                                   s_axi_lite_rready;
        rand    bit     [ DATA_WIDTH-1  :   0]        s_axi_lite_rdata;
        rand    bit     [ 1             :   0]        s_axi_lite_rresp;

	// Constructor
	function new ( string name = "reg_transaction" );
		super.new(name);
	endfunction : new
	
	`uvm_object_utils_begin(reg_transaction)
                `uvm_field_int      (s_axi_lite_awvalid,	UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_awready,	UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_awaddr,		UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_wvalid,		UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_wready,	        UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_wdata,	        UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_bresp,	        UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_bvalid,	        UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_bready,	        UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_arvalid,	UVM_DEFAULT)
	    	`uvm_field_int      (s_axi_lite_arready,	UVM_DEFAULT)
                `uvm_field_int      (s_axi_lite_araddr,	        UVM_DEFAULT)
                `uvm_field_int      (s_axi_lite_rvalid,	        UVM_DEFAULT)
                `uvm_field_int      (s_axi_lite_rready,	        UVM_DEFAULT)
                `uvm_field_int      (s_axi_lite_rdata,	        UVM_DEFAULT)
                `uvm_field_int      (s_axi_lite_rresp,	        UVM_DEFAULT)
  	`uvm_object_utils_end

        //////////////////////////////////////////////////////////////////////
        //                          Constraints                             //
        //////////////////////////////////////////////////////////////////////
        constraint c_s_axi_lite_awvalid { 
                s_axi_lite_awvalid == 1'b1;
        }
        
        constraint c_s_axi_lite_arvalid { 
                s_axi_lite_arvalid == 1'b1;
        }

        constraint c_s_axi_lite_wvalid { 
                s_axi_lite_wvalid == 1'b1;
        }

        constraint c_s_axi_lite_rready { 
                s_axi_lite_rready == 1'b1;
        }

        constraint c_addr { 
                s_axi_lite_araddr inside {10'h00, 10'h04, 10'h18, 10'h1C, 10'h28, 10'h30, 10'h34, 10'h34, 10'h48, 10'h4C, 10'h58 };
                s_axi_lite_awaddr inside {10'h00, 10'h04, 10'h18, 10'h1C, 10'h28, 10'h30, 10'h34, 10'h34, 10'h48, 10'h4C, 10'h58 };
        }

        


	
endclass : reg_transaction

`endif