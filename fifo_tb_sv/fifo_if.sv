interface fifo_if(); // fifo interface, clk and rst signals are generated in 'tb' module

	logic clk;
	logic rst;
	logic [7:0] din; // all of the signals are of type 'logic', to cover both 'reg' and 'wire' types in DUT
	logic [7:0] dout;
	logic wr;
	logic rd;
	logic empty;
	logic full;

endinterface