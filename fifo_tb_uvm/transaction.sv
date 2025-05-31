class transaction extends uvm_sequence_item;

	randc bit [7:0] din; // cyclic randomize
	bit [7:0] dout;
	rand bit wr; // regular randomize
	rand bit rd;
	bit empty;
	bit full; 

	// din can have values from 0 to 30 only
	constraint din_c { din inside {[0:30]};}
	// write and read can't happen simultaneously, and write happens 70% of the time
	constraint wr_rd { wr != rd; wr dist {0 :/ 30, 1 :/ 70};} 

	function new(string path = "transaction");
		super.new(path);
	endfunction

	`uvm_object_utils_begin(transaction) // registering to a factory (for clone method)
		`uvm_field_int(din, UVM_DEFAULT)
		`uvm_field_int(dout, UVM_DEFAULT)
		`uvm_field_int(wr, UVM_DEFAULT)
		`uvm_field_int(rd, UVM_DEFAULT)
		`uvm_field_int(empty, UVM_DEFAULT)
		`uvm_field_int(full, UVM_DEFAULT)
	`uvm_object_utils_end

endclass