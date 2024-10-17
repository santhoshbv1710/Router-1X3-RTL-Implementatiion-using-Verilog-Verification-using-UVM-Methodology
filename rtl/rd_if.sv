interface rd_if (input bit clock);

	logic [7:0] data_out;
	bit read_enb;
	bit vld_out;
	
	bit clk;
	assign clk = clock;

	clocking rd_drv_cb @(posedge clk);
	default input #1 output #1;
		input vld_out;
		output read_enb;
	endclocking

	clocking rd_mon_cb @(posedge clk);
	default input #1 output #1;
		input data_out;
		input read_enb;
	endclocking

	modport RD_DRV (clocking rd_drv_cb);
	modport RD_MON (clocking rd_mon_cb);

endinterface 
