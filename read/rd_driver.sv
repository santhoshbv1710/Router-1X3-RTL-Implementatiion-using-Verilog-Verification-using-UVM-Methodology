class rd_driver extends uvm_driver #(rd_xtn);

	`uvm_component_utils(rd_driver)
	rd_agent_cfg rd_cfg;

	virtual rd_if.RD_DRV vif;



	 function new(string name = "rd_driver",uvm_component parent);
			super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(rd_agent_cfg) :: get(this,"","rd_agent_cfg",rd_cfg))
			`uvm_fatal("RD_DRV","Getting failed ")
	endfunction

	 function void connect_phase (uvm_phase phase);
			vif = rd_cfg.vif;
	endfunction


	task run_phase (uvm_phase phase);
		forever 
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(rd_xtn xtn);
			`uvm_info("RD_DRV",$sformatf("printing from read driver \n %s", req.sprint()),UVM_LOW)
		@(vif.rd_drv_cb);
			while(vif.rd_drv_cb.vld_out == 0)
				@(vif.rd_drv_cb);

			repeat(xtn.no_of_clock_cycle)
			@(vif.rd_drv_cb);

			@(vif.rd_drv_cb);

			vif.rd_drv_cb.read_enb <= 1'b1;
			
			
			while(vif.rd_drv_cb.vld_out == 1)
				@(vif.rd_drv_cb);
			
			vif.rd_drv_cb.read_enb <= 1'b0;

	endtask

	
endclass

