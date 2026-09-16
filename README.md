# AMHRA — Full RTL Project

This package contains the bottom-to-top RTL implementation of the Adaptive Multi-Stage
Hardware Recovery Architecture integrated with a small RISC-V-style workload endpoint.

Important distinction:
- The recovery architecture is complete at RTL level.
- The included CPU endpoint is a small deterministic demonstration core, not a complete
  production RV32I processor.
- For a full SoC demonstration, it can be replaced by a verified open-source RV32I core
  while keeping the AMHRA recovery interface.
- Synthesis/STA/physical-design scripts are templates where technology-specific data is required.

Run first:
  ./scripts/run_iverilog.sh

Then:
  ./scripts/run_vcs.sh

Then open the generated VCD with Verdi/GTKWave.

Do not present the illustrative reliability values as measured results.
