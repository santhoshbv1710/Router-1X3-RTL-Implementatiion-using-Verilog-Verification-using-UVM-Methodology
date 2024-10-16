class rd_monitor extends uvm_monitor;

	`uvm_component_utils(rd_monitor)
  
		rd_agent_cfg rd_cfg;
		uvm_analysis_port #(rd_xtn) monitor_port;
		virtual rd_if.RD_MON vif;

	 function new(string name = "rd_monitor", uvm_component parent);
			super.new(name,parent);
			monitor_port = new("mp",this);
	endfunction
	 function void build_phase(uvm_phase phase);
			if(!uvm_config_db #(rd_agent_cfg) :: get(this,"","rd_agent_cfg",rd_cfg))
				`uvm_fatal("RD_MON","Getting failed !!!");
		//	`uvm_info("RD_MON","rd monior entered",UVM_LOW)
	endfunction
	 function void connect_phase(uvm_phase phase);
			vif = rd_cfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

	 task collect_data();
		rd_xtn xtn;
		xtn = rd_xtn :: type_id :: create("xtn");
		
		while(!vif.rd_mon_cb.read_enb)
			@(vif.rd_mon_cb);

		@(vif.rd_mon_cb);
		xtn.header = vif.rd_mon_cb.data_out;

		xtn.payload = new[xtn.header[7:2]];

		@(vif.rd_mon_cb);

		foreach(xtn.payload[i])begin
				while(!vif.rd_mon_cb.read_enb)
						@(vif.rd_mon_cb);
				xtn.payload[i] = vif.rd_mon_cb.data_out;
		@(vif.rd_mon_cb);
		end
     
		xtn.parity = vif.rd_mon_cb.data_out;
		
		@(vif.rd_mon_cb);
	
		monitor_port.write(xtn); 

				`uvm_info("RD_MON",$sformatf("printing from read monitor \n %s", xtn.sprint()),UVM_LOW)

	endtask

endclass
