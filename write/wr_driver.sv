class wr_driver extends uvm_driver #(wr_xtn);

	`uvm_component_utils(wr_driver)
	wr_agent_cfg wr_cfg;
	virtual wr_if.WR_DRV vif;
	 function new(string name = "wr_driver",uvm_component parent);
			super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(wr_agent_cfg) :: get(this,"","wr_agent_cfg",wr_cfg))
				`uvm_fatal("WR_DRV","Getting failed ")
	endfunction

	 function void connect_phase (uvm_phase phase);
			vif = wr_cfg.vif;
	endfunction


	 task run_phase (uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask
	
	task send_to_dut(wr_xtn xtn);
		`uvm_info("WR_DRV",$sformatf("printing from write driver \n %s", req.sprint()),UVM_LOW)
		@(vif.wr_drv_cb);
			vif.wr_drv_cb.resetn <= 1'b0;
		@(vif.wr_drv_cb)
			vif.wr_drv_cb.resetn <= 1'b1;

		while(vif.wr_drv_cb.busy)
			@(vif.wr_drv_cb);

		@(vif.wr_drv_cb);
		vif.wr_drv_cb.pkt_valid <= 1'b1;
		vif.wr_drv_cb.data_in <= xtn.header;

		@(vif.wr_drv_cb);

		foreach(xtn.payload[i])begin
			while(vif.wr_drv_cb.busy)
				@(vif.wr_drv_cb);
					vif.wr_drv_cb.data_in <= xtn.payload[i];
				@(vif.wr_drv_cb);
		end

		while(vif.wr_drv_cb.busy)
			@(vif.wr_drv_cb);

				vif.wr_drv_cb.pkt_valid <= 1'b0;
				vif.wr_drv_cb.data_in <= xtn.parity;
		@(vif.wr_drv_cb);
		endtask

endclass
