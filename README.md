# FIFO
FIFO memory designed in Verilog and verified in SystemVerilog and UVM.

---
## About
- Simple First In First Out Memory.
- 16*8 memory.
- 'cnt' counts the current memory locations occupied for 'empty' and 'full' flags.
- 'wrptr' and 'rdptr' are registers that store the location in memory from which data is read or written.
- Testbench files are in 'fifo_tb_sv' and 'fifo_tb_uvm' folders. (Both include 'fifo_pkg' packages
with all of the classes included: driver, monitor, scoreboard etc.)

---
## Simulation Screenshots
SystemVerilog Simulation
<div align="center"> <img src="/fifo_simulation_results/sv_tb_results/sv_vivado_waveforms.png"> </div>

UVM Simulation
<div align="center"> <img src="/fifo_simulation_results/uvm_tb_results/uvm_eda_waveforms.png"> </div> 

---
## Console Info
- Console outputs from Vivado Simulator (for SV simulation) and EDA Playground (for UVM simulation)
are included in 'fifo_simulation_results' file.
