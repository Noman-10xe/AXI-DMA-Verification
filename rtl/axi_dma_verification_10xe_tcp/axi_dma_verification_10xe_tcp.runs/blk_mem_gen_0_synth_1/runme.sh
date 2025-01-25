#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/xe-user106/vivado/Vivado/2022.1/ids_lite/ISE/bin/lin64:/home/xe-user106/vivado/Vivado/2022.1/bin
else
  PATH=/home/xe-user106/vivado/Vivado/2022.1/ids_lite/ISE/bin/lin64:/home/xe-user106/vivado/Vivado/2022.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/xe-user106/10x-Engineers/SOC-DV/TCP/axi_dma_verification/rtl/axi_dma_verification_10xe_tcp/axi_dma_verification_10xe_tcp.runs/blk_mem_gen_0_synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log blk_mem_gen_0.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source blk_mem_gen_0.tcl
