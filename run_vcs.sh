#!/bin/bash
set -e
mkdir -p sim
vcs -full64 -sverilog -Irtl -debug_access+all \
  -f scripts/filelist.f tb/tb_amhra_riscv_soc.v \
  -top tb_amhra_riscv_soc -o sim/simv
./sim/simv | tee sim/vcs.log
