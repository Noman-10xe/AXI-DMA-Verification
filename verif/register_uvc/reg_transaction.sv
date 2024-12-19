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
	
        rand bit                                   s_axi_lite_awvalid;
        rand bit                                   s_axi_lite_awready;
        rand bit     [ 9             :   0]        s_axi_lite_awaddr;
        rand bit                                   s_axi_lite_wvalid;
        rand bit                                   s_axi_lite_wready;
        rand bit     [ DATA_WIDTH-1  :   0]        s_axi_lite_wdata;
        rand bit     [ 1             :   0]        s_axi_lite_bresp;
        rand bit                                   s_axi_lite_bvalid;
        rand bit                                   s_axi_lite_bready;
        rand bit                                   s_axi_lite_arvalid;
        rand bit                                   s_axi_lite_arready;
        rand bit     [ 9             :   0]        s_axi_lite_araddr;
        rand bit                                   s_axi_lite_rvalid;
        rand bit                                   s_axi_lite_rready;
        rand bit     [ DATA_WIDTH-1  :   0]        s_axi_lite_rdata;
        rand bit     [ 1             :   0]        s_axi_lite_rresp;

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
	
endclass : reg_transaction

`endif