# Adapt library setup to your lab/PDK before running.
set TOP amhra_riscv_soc_top
set RTL_DIR ./rtl

# Example technology setup:
# set_app_var search_path [list ./lib]
# set_app_var target_library [list ./lib/your_stdcell.db]
# set_app_var link_library "* $target_library"

read_verilog -format verilog [glob $RTL_DIR/*.v]
current_design $TOP
link
source ./constraints/amhra.sdc
check_design > ./reports_dc_check.rpt
compile_ultra
report_area > ./reports_dc_area.rpt
report_timing -max_paths 20 > ./reports_dc_timing.rpt
report_power > ./reports_dc_power.rpt
write -format verilog -hierarchy -output ./amhra_synth.v
write_sdc ./amhra_synth.sdc
write -format ddc -hierarchy -output ./amhra.ddc
