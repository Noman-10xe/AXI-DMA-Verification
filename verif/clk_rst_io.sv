/*************************************************************************
   > File Name:     clk_rst_io.sv
   > Description:   Interface for Clock and reset Generation
   > Author:        Noman Rafiq
   > Modified:      Dec 18, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef CLK_RST_IO
`define CLK_RST_IO

interface clk_rst_io (
  inout axi_aclk,
  inout axi_resetn
);
  logic clk_o;
  logic rstn_o;

  // Clocking blocks
  clocking cb @(posedge clk_o);
  endclocking

  clocking cbn @(negedge clk_o);
  endclocking

  // Wait for 'n' clocks based on positive clock edge
  task automatic wait_clks(int num_clks);
    repeat (num_clks) @cb;
  endtask

  // Wait for 'n' clocks based on negative clock edge
  task automatic wait_n_clks(int num_clks);
    repeat (num_clks) @cbn;
  endtask

  /* Generate clock Function
   * NOTE: "Automatic" for independent calls (separate stack 
   * for each invocation)
   * Description: Generates a clock with a time period = clk_period
   * Inputs: clk_period  
   */
  task automatic gen_clock(input real clk_period);
    forever begin
      clk_o = 1'b0;
      #(clk_period / 2);
      clk_o = 1'b1;
      #(clk_period / 2);
    end
  endtask : gen_clock

  /* Generates reset 
   * Description: Generates a reset pulse with n number of cycles.
   * Inputs: reset_cycles  
   */
  task automatic gen_reset(input int reset_cycles);
    rstn_o = 1'b0;
    wait_clks(reset_cycles);
    rstn_o = 1'b1;
    wait_clks(1); // Ensure stable reset release
  endtask : gen_reset

  // Assert reset
  task automatic assert_reset();
    rstn_o = 1'b0;
    #1; // Ensure reset propagates
  endtask

  // Deassert reset
  task automatic deassert_reset();
    rstn_o = 1'b1;
    #1; // Ensure reset propagates
  endtask

  // Drive reset for specific duration
  task automatic drive_reset(input int duration_clks);
    assert_reset();
    wait_clks(duration_clks);
    deassert_reset();
  endtask

  assign axi_aclk   = clk_o;
  assign axi_resetn = rstn_o;

endinterface : clk_rst_io

`endif
