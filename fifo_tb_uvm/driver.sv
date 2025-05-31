class driver extends uvm_driver #(transaction);
	`uvm_component_utils(driver);
	transaction t, t_clone;
	virtual fifo_if fifo_if_i;
	uvm_blocking_put_port #(transaction) port; // sends data to scoreboard via TLM

	function new(string path = "driver", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		if(!uvm_config_db #(virtual fifo_if)::get(this, "", "fifo_if_i", fifo_if_i)) begin
			`uvm_fatal(get_name(), "Couldn't connect the driver to an interface!");
		end
	endfunction

	virtual task reset_phase(uvm_phase phase);
		phase.raise_objection(this);
		fifo_if_i.wr <= 1'b0;
		fifo_if_i.rd <= 1'b0;
		fifo_if_i.din <= 8'd0;
		fifo_if_i.rst <= 1'b1;
		#(`RST_DURATION);
		fifo_if_i.rst <= 1'b0;
		`uvm_info(get_name(), "Reset done.", UVM_NONE);
		phase.drop_objection(this);
	endtask

	virtual task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(t);
			fifo_if_i.din <= t.din;
			fifo_if_i.wr <= t.wr;
			fifo_if_i.rd <= t.rd;
			`uvm_info(get_name(), $sformatf("Stimulus applied: din: %0d, wr: %0d, rd: %0d.", t.din, t.wr, t.rd), UVM_NONE);
			$cast(t_clone, t.clone());
			port.put(t_clone);
			@(negedge fifo_if_i.clk);
			seq_item_port.item_done();
		end
	endtask
endclass