class driver;

	virtual fifo_if drv_if; // interface handle (classes can't have interface instances so they use a handle!)

	mailbox #(transaction) gen2drv; // mailbox to receive data from the generator
	transaction tr; // local transaction object

	function new(mailbox #(transaction) gen2drv, virtual fifo_if drv_if);
		this.gen2drv = gen2drv;
		this.drv_if = drv_if; // connect the driver to the interface
	endfunction

	task run();
		forever begin
			gen2drv.get(tr); // get the data from the generator and store it in the local transaction object, no need for a constructor for the transaction object
			if(tr.wr == 1) begin // display appropriate message
				$display("[DRV] : PERFORMING WRITE OPERATION \t DIN : %0d \t | \t TIME : %0t", tr.din, $time);  
			end
			else begin
				$display("[DRV] : PERFORMING READ OPERATION \t | \t TIME : %0t", $time);
			end
			// send generator data to the interface ports
			drv_if.din <= tr.din;
			drv_if.wr <= tr.wr;
			drv_if.rd <= tr.rd;
			@(negedge drv_if.clk); // only send data to interface on the negative edge of the clock
		end 
	endtask

endclass