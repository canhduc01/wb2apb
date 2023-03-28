@echo off
DOSKEY rm  = rmdir /s work
DOSKEY vlb = vlib work
DOSKEY vlg = vlog -writetoplevels questa.tops -timescale 1ns/1ns "+incdir+../libs/uvm-1.1d/src" -f filelist_rtl.f -cover bcefs -f filelist_tb.f -l vlog.log
DOSKEY vsm = vsim WB2APB_top_tb -solvefaildebug -assertdebug -assertcover -fsmdebug -sva -coverage -voptargs=+acc -l vsim.log +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=WB2APB_test -sv_lib ../libs/uvm-1.1d/lib/uvm_dpiWin64 -wlf vsim.wlf -batch -do "coverage save -onexit -assert -code bcefs -directive -cvg coverage.ucdb; add wave -r /WB2APB_top_tb/*; run -all; quit"
