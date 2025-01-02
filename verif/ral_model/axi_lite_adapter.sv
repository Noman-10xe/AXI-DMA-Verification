/*************************************************************************
   > File Name: axi_lite_adapter.sv
   > Description: Adapter Class to convert transactions from generic 
   >    register read/writes to physical bus accesses (AXI-Lite) and 
   >    vice versa.
   > Author: Noman Rafiq
   > Modified: Dec 31, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef ADAPTER
`define ADAPTER

class axi_lite_adapter extends uvm_reg_adapter;
  `uvm_object_utils(axi_lite_adapter)
  
  function new(string name = "axi_lite_adapter");
    super.new(name);
  endfunction : new

  // Convert RAL operation to AXI-Lite transaction
  virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
    reg_transaction bus_item = reg_transaction::type_id::create("bus_item");

    // Read
    if (rw.kind == UVM_READ) begin
      bus_item.s_axi_lite_arvalid = 1'b1;
      bus_item.s_axi_lite_rready  = 1'b1;
      bus_item.s_axi_lite_araddr  = rw.addr[9:0];
    end

    // Write
    else if (rw.kind == UVM_WRITE) begin
      bus_item.s_axi_lite_awvalid = 1'b1;
      bus_item.s_axi_lite_awaddr = rw.addr[9:0];
      bus_item.s_axi_lite_wvalid = 1'b1;
      bus_item.s_axi_lite_wdata = rw.data;
    end

    `uvm_info(get_type_name(),
      $sformatf("reg2bus: addr = %0h, data = %0h, kind = %s", 
        rw.addr, rw.data, (rw.kind == UVM_READ) ? "READ" : "WRITE"), 
        UVM_DEBUG);
    return bus_item;

  endfunction : reg2bus
  
  // Convert AXI-Lite transaction to RAL operation
  virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
    reg_transaction bus_pkt;

    if (!$cast(bus_pkt, bus_item)) begin
      `uvm_fatal(get_type_name(), "Failed to cast bus_item transaction");
      return;
    end

    // Read
    if (bus_pkt.s_axi_lite_arvalid) begin
      rw.addr[9:0]  = bus_pkt.s_axi_lite_araddr;
      rw.data       = bus_pkt.s_axi_lite_rdata;
      rw.kind       = UVM_READ;

      if (bus_pkt.s_axi_lite_rresp == 2'b00) begin
        rw.status = UVM_IS_OK;
      end 
      else begin
        rw.status = UVM_NOT_OK;
      end
    end
    
    // Write
    else if (bus_pkt.s_axi_lite_awvalid) begin
      rw.addr[9:0]  = bus_pkt.s_axi_lite_awaddr;
      rw.data       = bus_pkt.s_axi_lite_wdata;
      rw.kind       = UVM_WRITE;

      if (bus_pkt.s_axi_lite_bresp == 2'b00) begin
        rw.status = UVM_IS_OK;
      end 
      else begin
        rw.status = UVM_NOT_OK;
      end

    end

    `uvm_info(get_type_name(),
      $sformatf("bus2reg: addr = %0h, data = %0h, kind = %s", 
        rw.addr, rw.data, (rw.kind == UVM_READ) ? "READ" : "WRITE"), 
      UVM_DEBUG);

  endfunction : bus2reg

endclass : axi_lite_adapter
`endif