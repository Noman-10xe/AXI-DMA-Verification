/*************************************************************************
   > File Name:     params_pkg.sv
   > Description:   Package File containing Parameters, Environment can be 
   --               parametrized through these parameters.
   > Author:        Noman Rafiq
   > Modified:      Dec 18, 2024
   > Mail:          noman.rafiq@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

package params_pkg;

  // Bus address width
  localparam int ADDR_WIDTH = 32;

  // Bus data width (must be a multiple of 8)
  localparam int DATA_WIDTH = 32;

  // Bus data mask width (number of byte lanes)
  localparam int Byte_Lanes = (DATA_WIDTH >> 3);

  `define SRC_ADDR 32'h0;

endpackage : params_pkg
