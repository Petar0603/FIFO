// this is a verilog design for 16*8 fifo memory
module fifo(
	input clk,
	input [7:0] din,
	output reg [7:0] dout,
	input wr,
	input rd,
	input rst,
	output empty,
	output full
	);

	reg [3:0] wrptr, rdptr; // address pointers for read and write operations
	reg [7:0] mem[0:15];
	reg [4:0] cnt; // counter used for 'full' and 'empty' flags
	integer i = 0;

	always @(posedge clk) begin
		if(rst == 1'b1) begin // synchronous reset
			for(i = 0; i < 16; i = i + 1) begin
				mem[i] <= 8'd0; // reset all of the memory locations
			end
			wrptr <= 4'd0; // reset the pointers
			rdptr <= 4'd0;
			cnt <= 5'd0;
		end
		else if(wr == 1'b1 && cnt != 5'd16)begin // write operation
			mem[wrptr] <= din;
			wrptr <= wrptr + 1;
			cnt <= cnt + 1;
		end
		else if(rd == 1'b1 && cnt != 5'd0)begin // read operation
			dout <= mem[rdptr];
			rdptr <= rdptr + 1;
			cnt <= cnt - 1;
		end
	end

	assign empty = (cnt == 5'd0)? 1'b1 : 1'b0; // empty flag
	assign full = (cnt == 5'd16)? 1'b1 : 1'b0; // full flag

endmodule
