/*************************************************************************
   > File Name: coverage_model.sv
   > Description: Functional Coverage Class
   > Author: Noman Rafiq
   > Modified: Jan 19, 2025
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef FUNC_COV
`define FUNC_COV

//////////////////////////////////////////////////////////////////
//                      AXI LITE COVERAGE                       //
//////////////////////////////////////////////////////////////////
class axi_lite_coverage extends uvm_subscriber #(reg_transaction);
   `uvm_component_utils(axi_lite_coverage);
        
        reg_transaction tr;

        //  Constructor: new
        function new(string name = "axi_lite_coverage", uvm_component parent);
           super.new(name, parent);
           cg_read_channel      = new();
           cg_write_channel     = new();
        endfunction: new

        // write methods implementation
        virtual function void write(reg_transaction t);
             `uvm_info(`gfn, "Recieved AXI Lite transaction in Coverage Model", UVM_NONE)
             tr = t;
             cg_read_channel.sample();
             cg_write_channel.sample();
        endfunction : write

        
        // AXI LITE Read Channel Covergroup
        covergroup cg_read_channel;
             cp_arvalid: coverpoint tr.s_axi_lite_arvalid {
                     bins arvalid_0 = {0};
                     bins arvalid_1 = {1};
             }
             cp_arready: coverpoint tr.s_axi_lite_arready {
                     bins arready_0 = {0};
                     bins arready_1 = {1};
             }
             cp_araddr: coverpoint tr.s_axi_lite_araddr {
                     // MM2S READ Registers
                     bins araddr_MM2S_DMACR  = {'h00};
                     bins araddr_MM2S_DMASR  = {'h04};
                     bins araddr_MM2S_SA     = {'h18};
                     bins araddr_MM2S_LENGTH = {'h28};

                     // S2MM READ Registers
                     bins araddr_S2MM_DMACR  = {'h30};
                     bins araddr_S2MM_DMASR  = {'h34};
                     bins araddr_S2MM_DA     = {'h48};
                     bins araddr_S2MM_LENGTH = {'h58};
             }
             
             cp_rvalid: coverpoint tr.s_axi_lite_rvalid {
                     bins rvalid_0 = {0};
                     bins rvalid_1 = {1};
             }
             cp_rready: coverpoint tr.s_axi_lite_rready {
                     bins rready_0 = {0};
                     bins rready_1 = {1};
             }
             cp_rdata: coverpoint tr.s_axi_lite_rdata {
                     bins rdata_bin = {['h0:'hFFFFFFFF]};
             }
             cp_rresp: coverpoint tr.s_axi_lite_rresp {
                     bins rresp_okay         = {2'b00};
             }

             CROSS_ARREADY_ARVALID : cross cp_arvalid, cp_arready {
                ignore_bins ignore_0 = binsof(cp_arvalid.arvalid_0) && binsof(cp_arready.arready_1);
             }

             CROSS_RREADY_RVALID : cross cp_rready, cp_rvalid{
                ignore_bins ignore_0 = binsof(cp_rvalid.rvalid_1) && binsof(cp_rready.rready_0);
             }

             CROSS_ADDR_CTRL: cross cp_araddr, cp_arvalid, cp_arready {
                bins valid_araddr = binsof(cp_araddr) && binsof(cp_arvalid.arvalid_1) && binsof(cp_arready);
                bins invalid_araddr = binsof(cp_araddr) && binsof(cp_arvalid.arvalid_0) && binsof(cp_arready);
                ignore_bins ignore_0 = !((binsof(cp_araddr) intersect { 'h00, 'h04, 'h18, 'h28, 'h30, 'h34, 'h48, 'h58 }));
             }

             CROSS_RDATA_CTRL: cross cp_rvalid, cp_rready, cp_rresp;

        endgroup : cg_read_channel


         // AXI LITE Write Channel Covergroup
        covergroup cg_write_channel;
                cp_awvalid : coverpoint tr.s_axi_lite_awvalid {
                        bins awvalid_0 = {0};
                        bins awvalid_1 = {1};
                }
                cp_awready : coverpoint tr.s_axi_lite_awready {
                        bins awready_0 = {0};
                        bins awready_1 = {1};
                }
                cp_awaddr : coverpoint tr.s_axi_lite_awaddr {
                        // MM2S READ Registers
                        bins awaddr_MM2S_DMACR  = {'h00};
                        bins awaddr_MM2S_DMASR  = {'h04};
                        bins awaddr_MM2S_SA     = {'h18};
                        bins awaddr_MM2S_LENGTH = {'h28};

                        // S2MM READ Registers
                        bins awaddr_S2MM_DMACR  = {'h30};
                        bins awaddr_S2MM_DMASR  = {'h34};
                        bins awaddr_S2MM_DA     = {'h48};
                        bins awaddr_S2MM_LENGTH = {'h58};
                }

                cp_wvalid : coverpoint tr.s_axi_lite_wvalid {
                        bins wvalid_0 = {0};
                        bins wvalid_1 = {1};
                }
                cp_wready : coverpoint tr.s_axi_lite_wready {
                        bins wready_0 = {0};
                        bins wready_1 = {1};
                }
                cp_wdata : coverpoint tr.s_axi_lite_wdata {
                        bins wdata_bin = {['h0:'hFFFFFFFF]};
                }
                cp_bresp : coverpoint tr.s_axi_lite_bresp {
                        bins bresp_okay         = {2'b00};
                        bins bresp_slvErr       = {2'b10};
                }
                cp_bvalid : coverpoint tr.s_axi_lite_bvalid {
                        bins bvalid_0 = {0};
                        bins bvalid_1 = {1};
                }
                cp_bready : coverpoint tr.s_axi_lite_bready {
                        bins bready_0 = {0};
                        bins bready_1 = {1};
                }

                CROSS_AWREADY_AWVALID : cross cp_awvalid, cp_awready;
                CROSS_WREADY_WVALID : cross cp_wready, cp_wvalid;
                CROSS_AWADDR_CTRL: cross cp_awaddr, cp_awvalid, cp_awready;
                CROSS_WDATA_CTRL: cross cp_wdata, cp_wvalid, cp_wready, cp_bresp;

                cross_awvalid_x_awadrr: cross cp_awaddr, cp_awvalid {
                        bins valid_awaddr = binsof(cp_awaddr) && binsof(cp_awvalid);
                        ignore_bins invalid_awaddr = !(binsof(cp_awaddr));
                }

        endgroup : cg_write_channel

endclass: axi_lite_coverage

`endif