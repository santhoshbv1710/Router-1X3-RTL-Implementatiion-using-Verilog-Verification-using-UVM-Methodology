class wr_agent extends uvm_agent;

	`uvm_component_utils(wr_agent)

	wr_agent_cfg wr_cfg;

	wr_driver drvh;
	wr_monitor monh;
	wr_sequencer seqrh;


	 function new(string name = "wr_agent", uvm_component parent = null);
			super.new(name,parent);
	endfunction

	 function void build_phase(uvm_phase phase);
			if(!uvm_config_db #(wr_agent_cfg)::get(this,"","wr_agent_cfg",wr_cfg))
				`uvm_fatal("WR_AGNT","Getting failed !!!!!") 

				monh=wr_monitor::type_id::create("monh",this);	

				if(wr_cfg.is_active==UVM_ACTIVE)
					begin
						drvh=wr_driver::type_id::create("drvh",this);
						seqrh=wr_sequencer::type_id::create("seqrh",this);
					end
		
	endfunction

	 function void connect_phase(uvm_phase phase);
			if(wr_cfg.is_active==UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
  			end
	endfunction
endclass
