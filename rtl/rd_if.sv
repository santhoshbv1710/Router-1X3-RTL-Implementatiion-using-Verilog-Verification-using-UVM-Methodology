interface wr_if (input bit clock);

	bit clk;
	
	assign clk = clock;

	bit resetn;
	bit pkt_valid;
	logic [7:0] data_in;
	bit error;
	bit busy;
	
	clocking wr_drv_cb @(posedge clk);
		default input #1 output #1;
		output resetn;
		output data_in;
		output pkt_valid;
		input busy;
	endclocking

	clocking wr_mon_cb @(posedge clk);
		default input #1 output #1;
		input data_in;
		input pkt_valid;
		input resetn;
		input busy;
		input error;
	endclocking
	
	modport WR_DRV (clocking wr_drv_cb);
	modport WR_MON (clocking wr_mon_cb);

endinterface		
