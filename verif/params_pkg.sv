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

  // Bus address info (source) width
  localparam int BUS_AIW = 8;

  // Bus data info (source) width
  localparam int BUS_DIW = 1;

  // Bus data user width
  localparam int BUS_DUW = 16;

endpackage : params_pkg
