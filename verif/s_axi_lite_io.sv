/*************************************************************************
   > File Name:     s_axi_lite_io.sv
   > Description:   Interface for Configuring Address Mapped 
   --               Registers (Dut's internal registers)
   > Author:        Noman Rafiq
   > Modified:      Dec 18, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef S_AXI_LITE_IO
`define S_AXI_LITE_IO

interface s_axi_lite_io #(  int ADDR_WIDTH = params_pkg::ADDR_WIDTH,
                            int DATA_WIDTH = params_pkg::DATA_WIDTH
                        )   (
                            input logic axi_aclk,
                            input logic axi_resetn
                            );
  
  // Signals
  logic                                 s_axi_lite_awvalid;
  logic                                 s_axi_lite_awready;
  logic     [ 9             :   0]      s_axi_lite_awaddr;
  logic                                 s_axi_lite_wvalid;
  logic                                 s_axi_lite_wready;
  logic     [ DATA_WIDTH-1  :   0]      s_axi_lite_wdata;
  logic     [ 1             :   0]      s_axi_lite_bresp;
  logic                                 s_axi_lite_bvalid;
  logic                                 s_axi_lite_bready;
  logic                                 s_axi_lite_arvalid;
  logic                                 s_axi_lite_arready;
  logic     [ 9             :   0]      s_axi_lite_araddr;
  logic                                 s_axi_lite_rvalid;
  logic                                 s_axi_lite_rready;
  logic     [ DATA_WIDTH-1  :   0]      s_axi_lite_rdata;
  logic     [ 1             :   0]      s_axi_lite_rresp;

  ///////////////////////////////////////////////////////////////
  //
  // Clocking Blocks
  //

  // Driver Clocking Block
  clocking ioDriv @(posedge axi_aclk);
    default input #0ns output #2;
    // Address channel
    output        s_axi_lite_awvalid;
    output        s_axi_lite_awaddr;
    input         s_axi_lite_awready;
    // Write Data Channel
    output        s_axi_lite_wvalid;
    output        s_axi_lite_wdata;
    input         s_axi_lite_wready;
    // Write Response Channel
    output        s_axi_lite_bready;
    input         s_axi_lite_bresp;
    input         s_axi_lite_bvalid;
    // Read Address Channel
    output        s_axi_lite_arvalid;
    output        s_axi_lite_araddr;
    input         s_axi_lite_arready;
    // Read Data Channel
    output        s_axi_lite_rready;    
    input         s_axi_lite_rvalid;
    input         s_axi_lite_rdata;
    input         s_axi_lite_rresp;
  endclocking : ioDriv

  // Monitor Clocking Block
  clocking ioMon @(posedge axi_aclk);
    default input #0ns output #2;
    
    // Address channel
    input         s_axi_lite_awvalid;
    input         s_axi_lite_awaddr;
    input         s_axi_lite_awready;
    // Write Data Channel
    input         s_axi_lite_wvalid;
    input         s_axi_lite_wdata;
    input         s_axi_lite_wready;
    // Write Response Channel
    input         s_axi_lite_bready;
    input         s_axi_lite_bresp;
    input         s_axi_lite_bvalid;
    // Read Address Channel
    input         s_axi_lite_arvalid;
    input         s_axi_lite_araddr;
    input         s_axi_lite_arready;
    // Read Data Channel
    input         s_axi_lite_rready;    
    input         s_axi_lite_rvalid;
    input         s_axi_lite_rdata;
    input         s_axi_lite_rresp;
  endclocking : ioMon


  /* write_reg()
   * Writes a Specified Value to a Register
   * Inputs: Data and Addr
   */
  task write_reg (input logic [DATA_WIDTH-1:0] data, input logic [9:0] addr);
    // Address Phase
    ioDriv.s_axi_lite_awvalid <= 1'b1;
    ioDriv.s_axi_lite_awaddr  <= addr;
    wait (ioDriv.s_axi_lite_awready);     // Wait for handshake
    ioDriv.s_axi_lite_awvalid <= 1'b0;    // Deassert valid
  
    // Write Data Phase
    ioDriv.s_axi_lite_wvalid <= 1'b1;
    ioDriv.s_axi_lite_wdata  <= data;
    wait (ioDriv.s_axi_lite_wready);      // Wait for handshake
    ioDriv.s_axi_lite_wvalid <= 1'b0;     // Deassert valid
  
    // Write Response Phase
    wait (ioMon.s_axi_lite_bvalid);       // Wait for valid response
    ioDriv.s_axi_lite_bready <= 1'b1;     // Assert ready for response
    wait (!ioMon.s_axi_lite_bvalid);      // Wait for response to complete
    ioDriv.s_axi_lite_bready <= 1'b0;     // Deassert ready
  endtask : write_reg
  
  /* read_reg()
   * Reads the Value from a Register
   * Inputs: Data and Addr
   */
  task read_reg(input logic [9:0] addr);
    // Address Phase
    ioDriv.s_axi_lite_arvalid <= 1'b1;
    ioDriv.s_axi_lite_araddr  <= addr;
    wait (ioDriv.s_axi_lite_arready);     // Wait for handshake
    ioDriv.s_axi_lite_arvalid <= 1'b0;    // Deassert valid
  
    // Data Phase
    wait (ioMon.s_axi_lite_rvalid);       // Wait for valid read data
    ioDriv.s_axi_lite_rready <= 1'b1;     // Assert ready for response
    wait (!ioMon.s_axi_lite_rvalid);      // Wait for transaction to complete
    ioDriv.s_axi_lite_rready <= 1'b0;     // Deassert ready
  endtask : read_reg

  ///////////////////////////////////////////////////////////////
  //
  // Wait Clocks
  //
  task automatic wait_clks(input int num);
        repeat (num) @(posedge axi_aclk);
  endtask
  ///////////////////////////////////////////////////////////////
  task automatic wait_neg_clks(input int num);
        repeat (num) @(negedge axi_aclk);
  endtask

endinterface : s_axi_lite_io

`endif