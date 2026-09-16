#!/bin/bash
set -e
mkdir -p sim
iverilog -g2012 -I rtl -o sim/amhra_sim \
  -f scripts/filelist.f tb/tb_amhra_riscv_soc.v
vvp sim/amhra_sim | tee sim/amhra.log
