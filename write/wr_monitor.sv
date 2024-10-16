class wr_monitor extends uvm_monitor;

	`uvm_component_utils(wr_monitor)

	wr_agent_cfg wr_cfg;
	uvm_analysis_port #(wr_xtn) monitor_port;
	virtual wr_if.WR_MON vif;


	 function new(string name = "wr_monitor", uvm_component parent);
			super.new(name,parent);
			monitor_port = new("monitor port",this);
	endfunction

	 function void build_phase(uvm_phase phase);
			if(!uvm_config_db #(wr_agent_cfg) :: get(this,"","wr_agent_cfg",wr_cfg))
				`uvm_fatal("WR_MON","Getting failed");
	endfunction

	 function void connect_phase(uvm_phase phase);
			vif = wr_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();
			end
	endtask

	 task collect_data();
		wr_xtn xtn;
		xtn = wr_xtn :: type_id :: create("xtn");
			
		@(vif.wr_mon_cb);
		
		while(vif.wr_mon_cb.busy)
			@(vif.wr_mon_cb);

		while(!vif.wr_mon_cb.pkt_valid)
			@(vif.wr_mon_cb);

	//	@(vif.wr_mon_cb);

		xtn.header = vif.wr_mon_cb.data_in;
		xtn.payload = new[xtn.header[7:2]];

	//	@(vif.wr_mon_cb);
		
		foreach(xtn.payload[i])begin
			while(vif.wr_mon_cb.busy)
				@(vif.wr_mon_cb);
						@(vif.wr_mon_cb);
					xtn.payload[i] = vif.wr_mon_cb.data_in;
		end

		@(vif.wr_mon_cb);

		while(vif.wr_mon_cb.busy)
			@(vif.wr_mon_cb);
		while(vif.wr_mon_cb.pkt_valid)
			@(vif.wr_mon_cb);

		xtn.parity = vif.wr_mon_cb.data_in;
			repeat(3)
			@(vif.wr_mon_cb);
		
		xtn.error  = vif.wr_mon_cb.error;

		//	@(vif.wr_mon_cb);
			
			monitor_port.write(xtn);
		`uvm_info("WR_MON",$sformatf("printing from write monitor \n %s", xtn.sprint()),UVM_LOW)

	endtask
		
	
	
endclass
