class scoreboard;

	mailbox #(transaction) mon2sco, gen2sco;
	event scoreboard_done;

	transaction tr, tr_ref; // additional local transaction object for the golden data forming

	bit [7:0] queue[$]; // queue to store golden data
	bit [7:0] temp; // temporary variable to store golden data which is read and compared to the actual output of DUT
	int error_count = 0; // counts the times when actual data and golden data don't match

	function new(mailbox #(transaction) mon2sco, gen2sco, event scoreboard_done);
		this.mon2sco = mon2sco;   
		this.gen2sco = gen2sco;
		this.scoreboard_done = scoreboard_done;
	endfunction

	task queue_temp_update;
		if(tr_ref.wr == 1 && tr.full != 1)
			queue.push_back(tr_ref.din); // store the data from generator in queue in fifo manner
		else if(tr_ref.rd == 1 && tr.empty != 1)
			temp = queue.pop_front(); // read the data from queue in fifo manner    
	endtask

	task compare; // actual data and golden data comparison
		if(tr.empty != 1 && tr.full != 1) begin
			if(tr_ref.rd == 1) begin
				if(tr.dout == temp) begin
					$display("[SCO] : DATA OUTPUT MATCHES GOLDEN DATA! \t | \t TIME : %0t", $time); 
				end else begin
					$display("[SCO] : DATA OUTPUT DOESN'T MATCH GOLDEN DATA! \t | \t TIME : %0t", $time);   
					error_count++;
				end
			end
		end
	endtask

	task show_fifo_status;
		if(tr.full == 1)
			$display("[SCO] : FIFO IS FULL! \t | \t TIME : %0t", $time);
		else if(tr.empty == 1)
			$display("[SCO] : FIFO IS EMPTY! \t | \t TIME : %0t", $time);
		else
			$display("[SCO] : FIFO HAS DATA WRITTEN! \t | \t TIME : %0t", $time);
	endtask

	task display_error_count;
		$display("[SCO] : CURRENT ERROR COUNT = %0d \t | \t TIME : %0t", error_count, $time);
		$display("-----------------------------------------------------");
	endtask

	task run;
		forever begin
			gen2sco.get(tr_ref);
			mon2sco.get(tr);
			queue_temp_update();
			compare();
			show_fifo_status();
			display_error_count();
			-> scoreboard_done;
		end    
	endtask

endclass