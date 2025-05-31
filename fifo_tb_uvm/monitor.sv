class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)
	uvm_analysis_port #(transaction) port;
	transaction t, t_clone;
	virtual fifo_if fifo_if_i;

	function new(string path = "monitor", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		port = new("port", this);
		t = transaction::type_id::create("t");
		if(!uvm_config_db #(virtual fifo_if)::get(this, "", "fifo_if_i", fifo_if_i)) begin
			`uvm_fatal(get_name(), "Couldn't connect the monitor to an interface!");
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		#(`RST_DURATION);; // wait for the reset_phase of driver to finish
		forever begin
			@(posedge fifo_if_i.clk);
			#1; // wait for some time after posedge to sample the data
			t.dout = fifo_if_i.dout;
			t.empty = fifo_if_i.empty;
			t.full = fifo_if_i.full;
			`uvm_info(get_name(), $sformatf("Data sampled: dout: %0d, empty: %0d, full: %0d.", t.dout, t.empty, t.full), UVM_NONE);
			$cast(t_clone,t.clone());
			port.write(t_clone);
		end
	endtask
endclass