class transaction;

	randc bit [7:0] din; // cyclic randomize din input
	bit [7:0] dout;
	rand bit wr; // randomize write signal
	rand bit rd; // randomize read signal
	bit empty;
	bit full; 

	constraint din_c { din inside {[0:30]};} // din can have random values in range from 0 to 30
	constraint wr_rd { wr != rd; wr dist {0 :/ 30, 1 :/ 70};} // read and write can't have the same value, and write operation happens 70% of the time

	function transaction copy(); // deep copy of the transaction class, which is sent in each of the generator iterations
	copy = new();
	copy.din = this.din;
	copy.dout = this.dout;
	copy.wr = this.wr;
	copy.rd = this.rd;
	copy.empty = this.empty;
	copy.full = this.full;
	endfunction

endclass