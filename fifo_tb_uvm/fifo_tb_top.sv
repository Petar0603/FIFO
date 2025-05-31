`include "fifo_if.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "fifo_pkg.sv"
import fifo_pkg::*;

`timescale 1ns/1ps

module fifo_tb_top();

	fifo_if tb_if();
	fifo dut (
		.clk(tb_if.clk),
		.rst(tb_if.rst),
		.din(tb_if.din),
		.dout(tb_if.dout),
		.wr(tb_if.wr),
		.rd(tb_if.rd),
		.empty(tb_if.empty),
		.full(tb_if.full)
	);

	initial begin
		tb_if.clk <= 1'b0;
	end
	always #5 tb_if.clk <= ~tb_if.clk;

	initial begin
		uvm_top.set_report_verbosity_level(UVM_MEDIUM);
		uvm_top.set_report_max_quit_count(`MAX_ERROR_COUNT);
		uvm_config_db #(virtual fifo_if)::set(null, "uvm_test_top.env.agn*", "fifo_if_i", tb_if);
		run_test("test");
	end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule