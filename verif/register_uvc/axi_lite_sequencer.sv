/*************************************************************************
   > File Name: axi_lite_sequencer.sv
   > Description: Sequencer Class for AXI-lite Interface
   > Author: Noman Rafiq
   > Modified: Dec 19, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_LITE_SEQUENCER
`define AXI_LITE_SEQUENCER

class axi_lite_sequencer extends uvm_sequencer #(reg_transaction);
        `uvm_component_utils(axi_lite_sequencer)
        
        function new(string name = "axi_lite_sequencer", uvm_component parent);
        super.new(name, parent);
        endfunction : new

endclass : axi_lite_sequencer

`endif