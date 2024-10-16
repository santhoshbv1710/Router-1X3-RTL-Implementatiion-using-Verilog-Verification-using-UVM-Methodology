class wr_agent_cfg extends uvm_object;

	`uvm_object_utils(wr_agent_cfg)

	uvm_active_passive_enum is_active = UVM_ACTIVE;

	static int mon_rcvd_stn_cnt = 0;
	static int drv_data_sent_cnt = 0;
	virtual wr_if vif;

	 function new(string name = "wr_agent_cfg");
			super.new(name);
	endfunction
endclass
