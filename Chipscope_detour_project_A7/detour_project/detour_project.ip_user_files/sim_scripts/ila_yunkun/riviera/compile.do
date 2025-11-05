transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../project_yunkun.gen/sources_1/ip/ila_yunkun/hdl/verilog" -l xpm -l xil_defaultlib \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  -incr \
"C:/Xilinx/Vivado/2024.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../project_yunkun.gen/sources_1/ip/ila_yunkun/hdl/verilog" -l xpm -l xil_defaultlib \
"../../../../project_yunkun.gen/sources_1/ip/ila_yunkun/sim/ila_yunkun.v" \

vlog -work xil_defaultlib \
"glbl.v"

