class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	uvm_analysis_imp #(transaction, scoreboard) monitor_imp;
	uvm_blocking_put_imp #(transaction, scoreboard) driver_imp;
	transaction t_monitor, t_driver;

	bit [7:0] queue[$];
	bit [7:0] temp;

	function new(string path = "scoreboard", uvm_component parent = null);
		super.new(path, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		t_monitor = transaction::type_id::create("t_monitor");
		t_driver = transaction::type_id::create("t_driver");
		monitor_imp = new("monitor_imp", this);
		driver_imp = new("driver_imp", this);
	endfunction

	function void queue_temp_update();
		if(t_driver.wr == 1 && t_monitor.full != 1)
			queue.push_back(t_driver.din);
		else if(t_driver.rd == 1 && t_monitor.empty != 1)
			temp = queue.pop_front();
	endfunction

	function void compare();
		if(t_driver.rd == 1) begin
			if(t_monitor.dout == temp) begin
				`uvm_info(get_name(), "Data match!", UVM_NONE);
			end else begin
				`uvm_error(get_name(), "Data mismatch!");
			end
		end
	endfunction

	function void show_fifo_status();
		if(t_monitor.full == 1) begin
			`uvm_info(get_name(), "FIFO is full!", UVM_NONE);
		end
		else if(t_monitor.empty == 1) begin
			`uvm_info(get_name(), "FIFO is empty!", UVM_NONE);
		end
		else begin
			`uvm_info(get_name(), "FIFO has data written!", UVM_NONE);
		end
	endfunction

	virtual function void write(transaction t_monitor);
		this.t_monitor = t_monitor;
		compare();
		`uvm_info(get_name(), $sformatf("Data received from monitor:  dout: %0d, empty: %0d, full: %0d.", this.t_monitor.dout, this.t_monitor.empty, this.t_monitor.full), UVM_DEBUG);
		show_fifo_status();
	endfunction

	virtual function void put(transaction t_driver);
		this.t_driver = t_driver;
		queue_temp_update();
		`uvm_info(get_name(), $sformatf("Data received from driver: din: %0d, wr: %0d, rd: %0d.", this.t_driver.din, this.t_driver.wr, this.t_driver.rd), UVM_DEBUG);
	endfunction

endclass