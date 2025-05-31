`include "fifo_if.sv"
`include "fifo_pkg.sv"

`timescale 1ns / 1ps

import fifo_pkg::*;

module fifo_tb_top;

	int fifo_iterations = 30; // number of times for generator to generate stimuli

	environment env;

	fifo_if tb_if();

	fifo dut(.clk(tb_if.clk),
				.din(tb_if.din),
				.dout(tb_if.dout),
				.wr(tb_if.wr),
				.rd(tb_if.rd),
				.empty(tb_if.empty),
				.full(tb_if.full),
				.rst(tb_if.rst));

	task reset(); // pretest situation, rst is set for 5 positive edges of a clock, and then it is reset
		tb_if.rst <= 1;
		repeat(5) @(posedge tb_if.clk);
		tb_if.rst <= 0;
		@(posedge tb_if.clk);
	endtask

	initial begin
		env = new(fifo_iterations, tb_if); // create environment object and connect it to interface
	end

	initial begin // clock driving
		tb_if.clk <= 0;
	end
	always #5 tb_if.clk = ~tb_if.clk;

	initial begin
		reset();
		env.run();
	end

	initial begin
		$dumpfile("dump.vcd"); // value change dump file
		$dumpvars;
	end

endmodule