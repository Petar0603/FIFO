interface fifo_if();

	logic clk;
	logic rst;
	logic [7:0] din;
	logic [7:0] dout;
	logic wr;
	logic rd;
	logic empty;
	logic full;

endinterface