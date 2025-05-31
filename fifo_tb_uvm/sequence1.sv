class sequence1 extends uvm_sequence #(transaction);
	`uvm_object_utils(sequence1)
	transaction t;
	int count = 0; // only tracks the current no. of iteration

	function new(string path = "sequence1");
		super.new(path);
	endfunction

	function void display_op();
		if(this.t.wr == 1) begin
			`uvm_info(get_name(), "Performing write operation.", UVM_NONE);
		end
		else begin
			`uvm_info(get_name(), "Performing read operation.", UVM_NONE);
		end
	endfunction

	virtual task body();
		#(`RST_DURATION); // wait for reset_phase of driver to finish
		t = transaction::type_id::create("t");
		repeat(`NUM_ITERATIONS) begin
			start_item(t);
			if (!t.randomize()) begin
				`uvm_error(get_name(), "Randomization failed!");
			end
			`uvm_info(get_name(), $sformatf("Iteration no. %0d ", count), UVM_NONE);
			display_op();
			`uvm_info(get_name(), $sformatf("Data sent to Driver: din: %0d, wr: %0d, rd: %0d.", t.din, t.wr, t.rd), UVM_NONE);
			count++;
			finish_item(t);
		end
	endtask
endclass