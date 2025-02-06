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
                        bins            zero_value         = {32'h00000000};                    // Explicit bin for zero
                        bins            low_values         = {[32'h00000001:32'h00000FFF]};     // Small values
                        bins            mid_values         = {[32'h00001000:32'h0000FFFF]};     // Mid-range values
                        bins            high_values        = {[32'h00010000:$]};                // High values
                }

                // Control Register Fields
                cp_DMACR_RS: coverpoint tr.s_axi_lite_rdata[0] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_Reset: coverpoint tr.s_axi_lite_rdata[2] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_IOC_IrqEN: coverpoint tr.s_axi_lite_rdata[12] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_ERR_IrqEN: coverpoint tr.s_axi_lite_rdata[14] {
                        bins zero = {0};  
                        bins one  = {1};  
                }

                // Status Register Fields
                cp_DMASR_Halted: coverpoint tr.s_axi_lite_rdata[0] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                cp_DMASR_Idle: coverpoint tr.s_axi_lite_rdata[1] {
                        bins zero = {0};
                        bins one  = {1};
                }

                cp_DMASR_DMASlvErr: coverpoint tr.s_axi_lite_rdata[5] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                
                cp_DMASR_DMADecErr: coverpoint tr.s_axi_lite_rdata[6] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                
                cp_DMASR_IOC_Irq: coverpoint tr.s_axi_lite_rdata[12] {
                    bins zero = {0};  
                    bins one  = {1};  
                }
                
                cp_DMASR_Err_Irq: coverpoint tr.s_axi_lite_rdata[14] {
                        bins zero = {0};  
                        bins one  = {1};  
                }                    

                cp_rresp: coverpoint tr.s_axi_lite_rresp {
                        bins               rresp_okay      = {2'b00};
                        ignore_bins        rresp_ExOkay    = {2'b01};
                        ignore_bins        rresp_slvErr    = {2'b10};
                        ignore_bins        rresp_decErr    = {2'b11};
                }
                
                CROSS_ARREADY_ARVALID : cross cp_arvalid, cp_arready {           
                        ignore_bins ignore_0 = binsof(cp_arvalid.arvalid_0) && binsof(cp_arready.arready_1);
                }
                
                CROSS_RREADY_RVALID : cross cp_rready, cp_rvalid;
                
                CROSS_ADDR_CTRL : cross cp_araddr, cp_arvalid, cp_arready {
                        ignore_bins invalid     = binsof(cp_arvalid.arvalid_0) && binsof(cp_arready.arready_1);
                        ignore_bins ignore_0    = !((binsof(cp_araddr) intersect { 'h00, 'h04, 'h18, 'h28, 'h30, 'h34, 'h48, 'h58 }));
                }
                CROSS_RDATA_CTRL : cross cp_rvalid, cp_rready, cp_rresp, cp_rdata{
                        ignore_bins ignore_0 = binsof(cp_rvalid.rvalid_0) && (binsof(cp_rdata.mid_values) || binsof(cp_rdata.low_values));
                }

                // MM2S_DMACR Register
                cp_MM2S_DMACR_X_araddr: cross cp_DMACR_RS, cp_DMACR_Reset, cp_DMACR_IOC_IrqEN, cp_DMACR_ERR_IrqEN, cp_araddr {
                        bins MM2S_DMACR_RS_low                  = binsof(cp_araddr) && binsof(cp_DMACR_RS.zero);
                        bins MM2S_DMACR_RS_hi                   = binsof(cp_araddr) && binsof(cp_DMACR_RS.one);
                        bins MM2S_DMACR_Reset_low               = binsof(cp_araddr) && binsof(cp_DMACR_Reset.zero);
                        bins MM2S_DMACR_Reset_hi                = binsof(cp_araddr) && binsof(cp_DMACR_Reset.one);
                        bins MM2S_DMACR_IOC_IrqEN_lo            = binsof(cp_araddr) && binsof(cp_DMACR_IOC_IrqEN.zero);
                        bins MM2S_DMACR_IOC_IrqEN_hi            = binsof(cp_araddr) && binsof(cp_DMACR_IOC_IrqEN.one);
                        bins MM2S_DMACR_ERR_IrqEN_low           = binsof(cp_araddr) && binsof(cp_DMACR_ERR_IrqEN.zero);
                        bins MM2S_DMACR_ERR_IrqEN_hi            = binsof(cp_araddr) && binsof(cp_DMACR_ERR_IrqEN.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_araddr.araddr_MM2S_DMACR);
                }

                // MM2S_DMASR Register
                cp_MM2S_DMASR_X_araddr: cross cp_DMASR_Idle, cp_DMASR_Halted, cp_DMASR_DMASlvErr, cp_DMASR_DMADecErr, cp_DMASR_IOC_Irq, cp_DMASR_Err_Irq, cp_araddr {
                        bins MM2S_DMASR_Halted_low              = binsof(cp_araddr) && binsof(cp_DMASR_Halted.zero);
                        bins MM2S_DMASR_Halted_hi               = binsof(cp_araddr) && binsof(cp_DMASR_Halted.one);
                        bins MM2S_DMASR_Idle_low                = binsof(cp_araddr) && binsof(cp_DMASR_Idle.zero);
                        bins MM2S_DMASR_Idle_hi                 = binsof(cp_araddr) && binsof(cp_DMASR_Idle.one);
                        bins MM2S_DMASR_DMASlvErr_low           = binsof(cp_araddr) && binsof(cp_DMASR_DMASlvErr.zero);
                        bins MM2S_DMASR_DMASlvErr_hi            = binsof(cp_araddr) && binsof(cp_DMASR_DMASlvErr.one);
                        bins MM2S_DMASR_DMADecErr_low           = binsof(cp_araddr) && binsof(cp_DMASR_DMADecErr.zero);
                        bins MM2S_DMASR_DMADecErr_hi            = binsof(cp_araddr) && binsof(cp_DMASR_DMADecErr.one);
                        bins MM2S_DMASR_IOC_Irq_low             = binsof(cp_araddr) && binsof(cp_DMASR_IOC_Irq.zero);
                        bins MM2S_DMASR_IOC_Irq_hi              = binsof(cp_araddr) && binsof(cp_DMASR_IOC_Irq.one);
                        bins MM2S_DMASR_Err_Irq_low             = binsof(cp_araddr) && binsof(cp_DMASR_Err_Irq.zero);
                        bins MM2S_DMASR_Err_Irq_hi              = binsof(cp_araddr) && binsof(cp_DMASR_Err_Irq.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_araddr.araddr_MM2S_DMASR);
                }

                // S2MM_DMACR Register
                cp_S2MM_DMACR_X_araddr: cross cp_DMACR_RS, cp_DMACR_Reset, cp_DMACR_IOC_IrqEN, cp_DMACR_ERR_IrqEN, cp_araddr {
                        bins S2MM_DMACR_RS_low                  = binsof(cp_araddr) && binsof(cp_DMACR_RS.zero);
                        bins S2MM_DMACR_RS_hi                   = binsof(cp_araddr) && binsof(cp_DMACR_RS.one);
                        bins S2MM_DMACR_Reset_low               = binsof(cp_araddr) && binsof(cp_DMACR_Reset.zero);
                        bins S2MM_DMACR_Reset_hi                = binsof(cp_araddr) && binsof(cp_DMACR_Reset.one);
                        bins S2MM_DMACR_IOC_IrqEN_lo            = binsof(cp_araddr) && binsof(cp_DMACR_IOC_IrqEN.zero);
                        bins S2MM_DMACR_IOC_IrqEN_hi            = binsof(cp_araddr) && binsof(cp_DMACR_IOC_IrqEN.one);
                        bins S2MM_DMACR_ERR_IrqEN_low           = binsof(cp_araddr) && binsof(cp_DMACR_ERR_IrqEN.zero);
                        bins S2MM_DMACR_ERR_IrqEN_hi            = binsof(cp_araddr) && binsof(cp_DMACR_ERR_IrqEN.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_araddr.araddr_S2MM_DMACR);
                }

                // S2MM_DMASR Register
                cp_S2MM_DMASR_X_araddr: cross cp_DMASR_Idle, cp_DMASR_Halted, cp_DMASR_DMASlvErr, cp_DMASR_DMADecErr, cp_DMASR_IOC_Irq, cp_DMASR_Err_Irq, cp_araddr {
                        bins S2MM_DMASR_Halted_low              = binsof(cp_araddr) && binsof(cp_DMASR_Halted.zero);
                        bins S2MM_DMASR_Halted_hi               = binsof(cp_araddr) && binsof(cp_DMASR_Halted.one);
                        bins S2MM_DMASR_Idle_low                = binsof(cp_araddr) && binsof(cp_DMASR_Idle.zero);
                        bins S2MM_DMASR_Idle_hi                 = binsof(cp_araddr) && binsof(cp_DMASR_Idle.one);
                        bins S2MM_DMASR_DMASlvErr_low           = binsof(cp_araddr) && binsof(cp_DMASR_DMASlvErr.zero);
                        bins S2MM_DMASR_DMADecErr_low           = binsof(cp_araddr) && binsof(cp_DMASR_DMADecErr.zero);
                        bins S2MM_DMASR_IOC_Irq_low             = binsof(cp_araddr) && binsof(cp_DMASR_IOC_Irq.zero);
                        bins S2MM_DMASR_IOC_Irq_hi              = binsof(cp_araddr) && binsof(cp_DMASR_IOC_Irq.one);
                        bins S2MM_DMASR_Err_Irq_low             = binsof(cp_araddr) && binsof(cp_DMASR_Err_Irq.zero);
                        ignore_bins ignore_other_addresses      = !binsof(cp_araddr.araddr_S2MM_DMASR);
                }

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
                        bins            zero_value         = {32'h00000000};                    // Explicit bin for zero
                        bins            low_values         = {[32'h00000001:32'h00000FFF]};     // Small values
                        bins            mid_values         = {[32'h00001000:32'h0000FFFF]};     // Mid-range values
                        bins            high_values        = {[32'h00010000:$]};                // High values
                }

                // Control Register Fields
                cp_DMACR_RS: coverpoint tr.s_axi_lite_wdata[0] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_Reset: coverpoint tr.s_axi_lite_wdata[2] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_IOC_IrqEN: coverpoint tr.s_axi_lite_wdata[12] {
                        bins zero = {0};  
                        bins one  = {1};  
                }
                    
                cp_DMACR_ERR_IrqEN: coverpoint tr.s_axi_lite_wdata[14] {
                        bins zero = {0};  
                        bins one  = {1};  
                }

                // Status Register Fields                
                cp_DMASR_IOC_Irq: coverpoint tr.s_axi_lite_wdata[12] {
                    bins zero = {0};
                    bins one  = {1};
                }
                
                cp_DMASR_Err_Irq: coverpoint tr.s_axi_lite_wdata[14] {
                        bins zero = {0};
                        bins one  = {1};
                }

                cp_bresp : coverpoint tr.s_axi_lite_bresp {
                        bins            bresp_okay         = {2'b00};
                        ignore_bins     bresp_slvErr       = {2'b10};
                        ignore_bins     bresp_decErr       = {2'b11};
                        ignore_bins     bresp_ExOkay       = {2'b01};
                        
                }
                cp_bvalid : coverpoint tr.s_axi_lite_bvalid {
                        bins bvalid_0 = {0};
                        bins bvalid_1 = {1};
                }
                cp_bready : coverpoint tr.s_axi_lite_bready {
                        bins bready_0 = {0};
                        bins bready_1 = {1};
                }
                
                CROSS_AWREADY_AWVALID : cross cp_awvalid, cp_awready {
                        ignore_bins ignore_0 = binsof(cp_awvalid.awvalid_0) && binsof(cp_awready.awready_1);
                }
                
                CROSS_WREADY_WVALID : cross cp_wready, cp_wvalid {
                        ignore_bins ignore_0 = binsof(cp_wvalid.wvalid_0) && binsof(cp_wready.wready_1);
                }
                
                CROSS_ADDR_CTRL: cross cp_awaddr, cp_awvalid, cp_awready {
                        bins valid_awaddr               = binsof(cp_awaddr) && binsof(cp_awvalid.awvalid_1) && binsof(cp_awready.awready_1);
                        ignore_bins invalid_awaddr      = binsof(cp_awaddr) && binsof(cp_awvalid.awvalid_0) && binsof(cp_awready.awready_1);
                        ignore_bins ignore_0            = !((binsof(cp_awaddr) intersect { 'h00, 'h04, 'h18, 'h28, 'h30, 'h34, 'h48, 'h58 }));
                }

                CROSS_BRESP_CTRL: cross cp_bvalid, cp_bready, cp_bresp, cp_wdata{
                        ignore_bins ignore_0 = binsof(cp_bvalid.bvalid_0) && binsof(cp_bready.bready_1);
                }

                // MM2S_DMACR Register
                cp_MM2S_DMACR_X_awaddr: cross cp_DMACR_RS, cp_DMACR_Reset, cp_DMACR_IOC_IrqEN, cp_DMACR_ERR_IrqEN, cp_awaddr {
                        bins MM2S_DMACR_RS_low                  = binsof(cp_awaddr) && binsof(cp_DMACR_RS.zero);
                        bins MM2S_DMACR_RS_hi                   = binsof(cp_awaddr) && binsof(cp_DMACR_RS.one);
                        bins MM2S_DMACR_Reset_low               = binsof(cp_awaddr) && binsof(cp_DMACR_Reset.zero);
                        bins MM2S_DMACR_Reset_hi                = binsof(cp_awaddr) && binsof(cp_DMACR_Reset.one);
                        bins MM2S_DMACR_IOC_IrqEN_lo            = binsof(cp_awaddr) && binsof(cp_DMACR_IOC_IrqEN.zero);
                        bins MM2S_DMACR_IOC_IrqEN_hi            = binsof(cp_awaddr) && binsof(cp_DMACR_IOC_IrqEN.one);
                        bins MM2S_DMACR_ERR_IrqEN_low           = binsof(cp_awaddr) && binsof(cp_DMACR_ERR_IrqEN.zero);
                        bins MM2S_DMACR_ERR_IrqEN_hi            = binsof(cp_awaddr) && binsof(cp_DMACR_ERR_IrqEN.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_awaddr.awaddr_MM2S_DMACR);
                }

                // MM2S_DMASR Register
                cp_MM2S_DMASR_X_awaddr: cross cp_DMASR_IOC_Irq, cp_DMASR_Err_Irq, cp_awaddr {
                        bins MM2S_DMASR_IOC_Irq_low             = binsof(cp_awaddr) && binsof(cp_DMASR_IOC_Irq.zero);
                        bins MM2S_DMASR_IOC_Irq_hi              = binsof(cp_awaddr) && binsof(cp_DMASR_IOC_Irq.one);
                        bins MM2S_DMASR_Err_Irq_low             = binsof(cp_awaddr) && binsof(cp_DMASR_Err_Irq.zero);
                        bins MM2S_DMASR_Err_Irq_hi              = binsof(cp_awaddr) && binsof(cp_DMASR_Err_Irq.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_awaddr.awaddr_MM2S_DMASR);
                }


                // S2MM_DMACR Register
                cp_S2MM_DMACR_X_awaddr: cross cp_DMACR_RS, cp_DMACR_Reset, cp_DMACR_IOC_IrqEN, cp_DMACR_ERR_IrqEN, cp_awaddr {
                        bins S2MM_DMACR_RS_low                  = binsof(cp_awaddr) && binsof(cp_DMACR_RS.zero);
                        bins S2MM_DMACR_RS_hi                   = binsof(cp_awaddr) && binsof(cp_DMACR_RS.one);
                        bins S2MM_DMACR_Reset_low               = binsof(cp_awaddr) && binsof(cp_DMACR_Reset.zero);
                        bins S2MM_DMACR_Reset_hi                = binsof(cp_awaddr) && binsof(cp_DMACR_Reset.one);
                        bins S2MM_DMACR_IOC_IrqEN_lo            = binsof(cp_awaddr) && binsof(cp_DMACR_IOC_IrqEN.zero);
                        bins S2MM_DMACR_IOC_IrqEN_hi            = binsof(cp_awaddr) && binsof(cp_DMACR_IOC_IrqEN.one);
                        bins S2MM_DMACR_ERR_IrqEN_low           = binsof(cp_awaddr) && binsof(cp_DMACR_ERR_IrqEN.zero);
                        bins S2MM_DMACR_ERR_IrqEN_hi            = binsof(cp_awaddr) && binsof(cp_DMACR_ERR_IrqEN.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_awaddr.awaddr_S2MM_DMACR);
                }

                // S2MM_DMASR Register
                cp_S2MM_DMASR_X_awaddr: cross cp_DMASR_IOC_Irq, cp_DMASR_Err_Irq, cp_awaddr {
                        bins S2MM_DMASR_IOC_Irq_low             = binsof(cp_awaddr) && binsof(cp_DMASR_IOC_Irq.zero);
                        bins S2MM_DMASR_IOC_Irq_hi              = binsof(cp_awaddr) && binsof(cp_DMASR_IOC_Irq.one);
                        bins S2MM_DMASR_Err_Irq_low             = binsof(cp_awaddr) && binsof(cp_DMASR_Err_Irq.zero);
                        bins S2MM_DMASR_Err_Irq_hi              = binsof(cp_awaddr) && binsof(cp_DMASR_Err_Irq.one);
                        ignore_bins ignore_other_addresses      = !binsof(cp_awaddr.awaddr_S2MM_DMASR);
                }

        endgroup : cg_write_channel

endclass: axi_lite_coverage


////////////////////////////////////////////////////////////////////
//                 AXI-Stream READ Coverage                       //
////////////////////////////////////////////////////////////////////
class axis_read_coverage extends uvm_subscriber #(axis_transaction);
        `uvm_component_utils(axis_read_coverage);

             axis_transaction tr;
     
             //  Constructor: new
             function new(string name = "axis_read_coverage", uvm_component parent);
                super.new(name, parent);
                cg_axis_read    = new();
                cg_mm2s_introut = new();
             endfunction: new
     
             // write methods implementation
             virtual function void write(axis_transaction t);
                  `uvm_info(`gfn, "Recieved AXIS READ transaction in Coverage Model", UVM_HIGH)
                  tr = t;
                  cg_axis_read.sample();
                  cg_mm2s_introut.sample();
             endfunction : write
             
             // AXI-Stream Read Covergroup
             covergroup cg_axis_read;
                cp_tdata        : coverpoint tr.tdata  {
                        bins            zero_value         = {32'h00000000};                    // Explicit bin for zero
                        bins            low_values         = {[32'h00000001:32'h00000FFF]};     // Small values
                        bins            mid_values         = {[32'h00001000:32'h0000FFFF]};     // Mid-range values
                        bins            high_values        = {[32'h00010000:$]};                // High values
                }       
                cp_tkeep        : coverpoint tr.tkeep  {
                        bins tkeep_1            = {'h1 };
                        bins tkeep_3            = {'h3 };
                        bins tkeep_7            = {'h7 };
                        bins tkeep_15           = {'hf };
                        ignore_bins ignore[]    = {'h0, 'h2, 'h4, 'h5, 'h6, 'h8, 'h9, 'ha, 'hb, 'hc, 'hd, 'he };
                }
                cp_tvalid       : coverpoint tr.tvalid {
                        bins tvalid_0 = {0};
                        bins tvalid_1 = {1};
                }       
                cp_tready       : coverpoint tr.tready {
                        bins tready_0 = {0};
                        bins tready_1 = {1};
                }       
                cp_tlast        : coverpoint tr.tlast  {
                        bins tlast_0 = {0};
                        bins tlast_1 = {1};
                }

                CROSS_TDATA_TKEEP       : cross cp_tdata, cp_tkeep {
                        ignore_bins ignore_0 = binsof(cp_tdata.mid_values) && binsof(cp_tkeep.tkeep_1);
                }
                CROSS_TVALID_TREADY     : cross cp_tvalid, cp_tready;
                CROSS_TVALID_TLAST      : cross cp_tvalid, cp_tlast {
                        ignore_bins ignore_0 = binsof(cp_tvalid.tvalid_0) && binsof(cp_tlast.tlast_1);
                }

             endgroup : cg_axis_read

             // MM2S Interrupt Coverage
             covergroup cg_mm2s_introut;
                cp_mm2s_introut :       coverpoint tr.introut {
                        bins mm2s_introut_0 = {0};
                        bins mm2s_introut_1 = {1};
                }
             endgroup : cg_mm2s_introut


     
endclass: axis_read_coverage


////////////////////////////////////////////////////////////////////
//                AXI-Stream Write Coverage                       //
////////////////////////////////////////////////////////////////////
class axis_write_coverage extends uvm_subscriber #(axis_transaction);
        `uvm_component_utils(axis_write_coverage);

             axis_transaction tr;
     
             //  Constructor: new
             function new(string name = "axis_write_coverage", uvm_component parent);
                super.new(name, parent);
                cg_axis_write = new();
             endfunction: new
     
             // write methods implementation
             virtual function void write(axis_transaction t);
                  `uvm_info(`gfn, "Recieved AXIS READ transaction in Coverage Model", UVM_HIGH)
                  tr = t;
                  cg_axis_write.sample();
             endfunction : write
             
             // AXI-Stream Read Covergroup
             covergroup cg_axis_write;
                cp_tdata        : coverpoint tr.tdata  {
                        bins            zero_value         = {32'h00000000};                    // Explicit bin for zero
                        bins            low_values         = {[32'h00000001:32'h00000FFF]};     // Small values
                        bins            mid_values         = {[32'h00001000:32'h0000FFFF]};     // Mid-range values
                        bins            high_values        = {[32'h00010000:32'hFFFFFFFF]};     // High values
                        bins            all_ones           = {32'hFFFFFFFF};                    // Explicit bin for all ones
                }       
                cp_tkeep        : coverpoint tr.tkeep  {
                        bins tkeep[]            = {'h1, 'h3, 'h7, 'hf};
                        ignore_bins ignore[]    = {'h0, 'h2, 'h4, 'h5, 'h6, 'h8, 'h9, 'ha, 'hb, 'hc, 'hd, 'he };
                }
                cp_tvalid       : coverpoint tr.tvalid {
                        bins tvalid_0 = {0};
                        bins tvalid_1 = {1};
                }       
                cp_tready       : coverpoint tr.tready {
                        bins tready_0 = {0};
                        bins tready_1 = {1};
                }       
                cp_tlast        : coverpoint tr.tlast  {
                        bins tlast_0 = {0};
                        bins tlast_1 = {1};
                }

                CROSS_TDATA_TKEEP       : cross cp_tdata, cp_tkeep;
                CROSS_TVALID_TREADY     : cross cp_tvalid, cp_tready;
                CROSS_TVALID_TLAST      : cross cp_tvalid, cp_tlast {
                        ignore_bins ignore_0 = binsof(cp_tvalid.tvalid_0) && binsof(cp_tlast.tlast_1);
                }

             endgroup : cg_axis_write
     
endclass: axis_write_coverage


////////////////////////////////////////////////////////////////////
//                    s2mm_introut coverage                       //
////////////////////////////////////////////////////////////////////
class s2mm_introut_coverage extends uvm_subscriber #(axi_transaction);
        `uvm_component_utils(s2mm_introut_coverage);

             axi_transaction tr;
     
             //  Constructor: new
             function new(string name = "s2mm_introut_coverage", uvm_component parent);
                super.new(name, parent);
                cg_s2mm_introut = new();
             endfunction: new
     
             // write methods implementation
             virtual function void write(axi_transaction t);
                  `uvm_info(`gfn, "Recieved AXI transaction in Coverage Model", UVM_HIGH)
                  tr = t;
                  cg_s2mm_introut.sample();
             endfunction : write
             
             // S2MM Interrupt Coverage
             covergroup cg_s2mm_introut;
                cp_s2mm_introut :       coverpoint tr.s2mm_introut {
                        bins s2mm_introut_0 = {0};
                        bins s2mm_introut_1 = {1};
                }
             endgroup : cg_s2mm_introut
     
endclass: s2mm_introut_coverage

`endif