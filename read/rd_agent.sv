class rd_agent extends uvm_agent;

	`uvm_component_utils(rd_agent)

	rd_agent_cfg rd_cfg;

	rd_driver drvh;
	rd_monitor monh;
	rd_sequencer seqrh;


	 function new(string name = "rd_agent", uvm_component parent);
			super.new(name,parent);
	endfunction

	 function void build_phase(uvm_phase phase);
			if(!uvm_config_db #(rd_agent_cfg)::get(this,"","rd_agent_cfg",rd_cfg))
				`uvm_fatal("RD_AGNT","Getting failed !!!!!") 

				monh=rd_monitor::type_id::create("monh",this);	

				if(rd_cfg.is_active==UVM_ACTIVE)
					begin
						drvh=rd_driver::type_id::create("drvh",this);
						seqrh=rd_sequencer::type_id::create("seqrh",this);
					end
		
	endfunction

	 function void connect_phase(uvm_phase phase);
			if(rd_cfg.is_active==UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
  			end
	endfunction
endclass
