class rd_agent_cfg extends uvm_object;

	`uvm_object_utils(rd_agent_cfg)

	uvm_active_passive_enum is_active = UVM_ACTIVE;

		static int mon_rcvd_xtn_cnt = 0;
		virtual rd_if vif;
		static int drv_data_sent_cnt = 0;
		int no_of_agent;
		bit [1:0] addr;
		function new(string name = "rd_agent_cfg");
			super.new(name);
		endfunction
endclass

