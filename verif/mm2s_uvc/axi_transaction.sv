/*************************************************************************
   > File Name: axi_transaction.sv
   > Description: Transation Item Class for AXI4 Interface
   > Author: Noman Rafiq
   > Modified: Dec 25, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef AXI_TRANSACTION
`define AXI_TRANSACTION

class axi_transaction extends uvm_sequence_item;
	
        ////////////////////////////////////////////////////////////////////////////////////////
        //                                     SIGNALS                                        //
        ////////////////////////////////////////////////////////////////////////////////////////
        // read address channel
        bit              [ params_pkg::ADDR_WIDTH-1     :       0 ]     araddr;
        bit              [ 7                            :       0 ]     arlen;
        bit              [ 2                            :       0 ]     arsize;
        bit              [ 1                            :       0 ]     arburst;
        bit              [ 2                            :       0 ]     arprot;
        bit              [ 3                            :       0 ]     arcache;
        bit                                                             arvalid;
        rand bit                                                        arready;
        // read data channel
        rand bit         [ params_pkg::DATA_WIDTH-1     :       0 ]     rdata;
        rand bit         [ 1                            :       0 ]     rresp;
        rand bit                                                        rlast;
        rand bit                                                        rvalid;
        bit                                                             rready;

        // write address channel
        rand bit         [ params_pkg::ADDR_WIDTH-1     :       0 ]     awaddr;
        rand bit         [ 7                            :       0 ]     awlen;
        rand bit         [ 2                            :       0 ]     awsize;
        rand bit         [ 1                            :       0 ]     awburst;
        rand bit         [ 2                            :       0 ]     awprot;
        rand bit         [ 3                            :       0 ]     awcache;
        rand bit                                                        awvalid;
        rand bit                                                        awready;
        // write data channel
        rand bit         [ params_pkg::DATA_WIDTH-1     :       0 ]     wdata;
        rand bit         [ 3                            :       0 ]     wstrb;
        rand bit                                                        wlast;
        rand bit                                                        wvalid;
        rand bit                                                        wready;
        // write response channel
        rand bit         [ 1                            :       0 ]     bresp;
        rand bit                                                        bvalid;
        rand bit                                                        bready;

	// Constructor
	function new ( string name = "axi_transaction" );
		super.new(name);
	endfunction : new
	
	`uvm_object_utils_begin(axi_transaction)
                `uvm_field_int      (araddr,	        UVM_DEFAULT)
	    	`uvm_field_int      (arlen,	        UVM_DEFAULT)
	    	`uvm_field_int      (arsize,            UVM_DEFAULT)
	    	`uvm_field_int      (arburst,           UVM_DEFAULT)
	    	`uvm_field_int      (arprot,            UVM_DEFAULT)
	    	`uvm_field_int      (arcache,           UVM_DEFAULT)
	    	`uvm_field_int      (arvalid,           UVM_DEFAULT)
	    	`uvm_field_int      (arready,           UVM_DEFAULT)
	    	`uvm_field_int      (rdata,             UVM_DEFAULT)
	    	`uvm_field_int      (rresp,	        UVM_DEFAULT)
	    	`uvm_field_int      (rlast,	        UVM_DEFAULT)
                `uvm_field_int      (rvalid,            UVM_DEFAULT)
                `uvm_field_int      (rready,            UVM_DEFAULT)
                `uvm_field_int      (awaddr,            UVM_DEFAULT)
                `uvm_field_int      (awlen,             UVM_DEFAULT)
                `uvm_field_int      (awsize,            UVM_DEFAULT)
                `uvm_field_int      (awburst,           UVM_DEFAULT)
                `uvm_field_int      (awprot,	        UVM_DEFAULT)
                `uvm_field_int      (awcache,	        UVM_DEFAULT)
                `uvm_field_int      (awvalid,           UVM_DEFAULT)
                `uvm_field_int      (awready,           UVM_DEFAULT)
                `uvm_field_int      (wdata,             UVM_DEFAULT)
                `uvm_field_int      (wstrb,	        UVM_DEFAULT)
                `uvm_field_int      (wlast,	        UVM_DEFAULT)
                `uvm_field_int      (wvalid,            UVM_DEFAULT)
                `uvm_field_int      (wready,            UVM_DEFAULT)
                `uvm_field_int      (bvalid,            UVM_DEFAULT)
                `uvm_field_int      (bready,            UVM_DEFAULT)
                `uvm_field_int      (bresp,             UVM_DEFAULT)
  	`uvm_object_utils_end

        //////////////////////////////////////////////////////////////
        //                         Constraints                      //
        //////////////////////////////////////////////////////////////
        constraint c_rresp {
                rresp == 0;
        }

        constraint c_arready {
                arready == 1;
        }
        
        constraint c_rvalid {
                rvalid == 1;
        }

        constraint c_bresp {
                bresp == 2'b00;
        }


endclass : axi_transaction

`endif