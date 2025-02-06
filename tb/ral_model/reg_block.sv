/*************************************************************************
   > File Name: reg_block.sv
   > Description: Register Block that contains all of the DMA's internal
   >              registers for Direct Register Mode.
   > Author: Noman Rafiq
   > Modified: Dec 31, 2024
   > Mail: noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/
`ifndef REG_BLOCK
`define REG_BLOCK

class reg_block extends uvm_reg_block;
        
        `uvm_object_utils(reg_block)
        
        // MM2S Control and Status Registers
        mm2s_dmacr      MM2S_DMACR;
        mm2s_dmasr      MM2S_DMASR;
        mm2s_length     MM2S_LENGTH;
        mm2s_sa         MM2S_SA;
        mm2s_sa_msb     MM2S_SA_MSB;

        // S2MM Control and Status Registers
        s2mm_dmacr      S2MM_DMACR;
        s2mm_dmasr      S2MM_DMASR;
        s2mm_length     S2MM_LENGTH;
        s2mm_da         S2MM_DA;
        s2mm_da_msb     S2MM_DA_MSB;

        function new(string name = "reg_block");
            super.new(name, build_coverage(UVM_NO_COVERAGE));
        endfunction : new
      
        virtual function void build();
                /* 
                 *  "create_map()"
                 *  Desc: Creates an Address Map
                 *  ///////  Inputs   ///////     
                 *   1.   string name,
                 *   2.   uvm_reg_addr_t base_addr,
                 *   3.   int unsigned n_bytes,
                 *   4.   uvm_endianness_e endian,
                 *   5.   bit byte_addressing = 1,
                 */
                default_map = create_map("default_map", 0, 4, UVM_LITTLE_ENDIAN, 0);
                
                MM2S_DMACR = mm2s_dmacr::type_id::create("MM2S_DMACR");
                MM2S_DMACR.configure(this,null);
                MM2S_DMACR.build();

                MM2S_DMASR = mm2s_dmasr::type_id::create("MM2S_DMASR");
                MM2S_DMASR.configure(this,null);
                MM2S_DMASR.build();

                MM2S_LENGTH = mm2s_length::type_id::create("MM2S_LENGTH");
                MM2S_LENGTH.configure(this,null);
                MM2S_LENGTH.build();

                MM2S_SA = mm2s_sa::type_id::create("MM2S_SA");
                MM2S_SA.configure(this,null);
                MM2S_SA.build();

                MM2S_SA_MSB = mm2s_sa_msb::type_id::create("MM2S_SA_MSB");
                MM2S_SA_MSB.configure(this,null);
                MM2S_SA_MSB.build();

                S2MM_DMACR = s2mm_dmacr::type_id::create("S2MM_DMACR");
                S2MM_DMACR.configure(this,null);
                S2MM_DMACR.build();

                S2MM_DMASR = s2mm_dmasr::type_id::create("S2MM_DMASR");
                S2MM_DMASR.configure(this,null);
                S2MM_DMASR.build();

                S2MM_LENGTH = s2mm_length::type_id::create("S2MM_LENGTH");
                S2MM_LENGTH.configure(this,null);
                S2MM_LENGTH.build();

                S2MM_DA = s2mm_da::type_id::create("S2MM_DA");
                S2MM_DA.configure(this,null);
                S2MM_DA.build();

                S2MM_DA_MSB = s2mm_da_msb::type_id::create("S2MM_DA_MSB");
                S2MM_DA_MSB.configure(this,null);
                S2MM_DA_MSB.build();

                default_map.set_auto_predict(1);                // auto-prediction

                /* 
                 *  "default_map.add_reg()"
                 *  Desc: Adds Register to the Map
                 *  ///////  Inputs   ///////     
                 *   1.   reg_inst,
                 *   2.   offset,
                 *   3.   access,
                 */
                default_map.add_reg(MM2S_DMACR,         'h00, "RW");
                default_map.add_reg(MM2S_DMASR,         'h04, "RW");
                default_map.add_reg(MM2S_SA,            'h18, "RW");
                default_map.add_reg(MM2S_SA_MSB,        'h1C, "RW");
                default_map.add_reg(MM2S_LENGTH,        'h28, "RW");
                default_map.add_reg(S2MM_DMACR,         'h30, "RW");
                default_map.add_reg(S2MM_DMASR,         'h34, "RW");
                default_map.add_reg(S2MM_DA,            'h48, "RW");
                default_map.add_reg(S2MM_DA_MSB,        'h4C, "RW");
                default_map.add_reg(S2MM_LENGTH,        'h58, "RW");

                // Lock Model
                lock_model();
       
        endfunction : build
      
endclass : reg_block

`endif