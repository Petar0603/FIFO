`ifndef FIFO_PKG
`define FIFO_PKG

package fifo_pkg;
	`include "transaction.sv"
	`include "generator.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "scoreboard.sv"
	`include "environment.sv"
endpackage

`endif