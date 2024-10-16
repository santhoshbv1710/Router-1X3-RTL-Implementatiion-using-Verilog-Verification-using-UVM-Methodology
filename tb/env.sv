class env extends uvm_env;

	`uvm_component_utils(env)

	wr_agent_top wagt_top;
	rd_agent_top ragt_top;

	virtual_sequencer v_sequencer;
	scoreboard sb;
	env_config env_cfg;

	function new(string name = "env", uvm_component parent);
			super.new(name,parent);
	endfunction

	 function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config) :: get(this,"","env_config",env_cfg))
			`uvm_fatal("ENV","getting failed !!!!")

		if(env_cfg.has_wagent)begin
			uvm_config_db #(wr_agent_cfg) :: set(this,"*","wr_agent_cfg",env_cfg.wr_cfg);
				wagt_top = wr_agent_top :: type_id :: create("wagt_top",this);
			end

		if(env_cfg.has_ragent)begin
			foreach(env_cfg.rd_cfg[i])
				uvm_config_db #(rd_agent_cfg) :: set(this,$sformatf("ragt_top.agnth[%0d]*",i),"rd_agent_cfg",env_cfg.rd_cfg[i]);
						
				ragt_top = rd_agent_top :: type_id :: create("ragt_top",this);

			end

		if(env_cfg.has_virtual_sequencer)
			v_sequencer = virtual_sequencer :: type_id :: create("v_sequencer",this);

		if(env_cfg.has_scoreboard)
			sb = scoreboard :: type_id :: create("sb",this);

	endfunction


	function void connect_phase(uvm_phase phase);

		if(env_cfg.has_virtual_sequencer)begin
			 v_sequencer.wr_seqr = wagt_top.agnth.seqrh;
				
	
			foreach(ragt_top.agnth[i])
				 v_sequencer.rd_seqr[i] = ragt_top.agnth[i].seqrh;
					end

		if(env_cfg.has_scoreboard)begin
				foreach(env_cfg.rd_cfg[i])
					ragt_top.agnth[i].monh.monitor_port.connect(sb.fifo_rdh[i].analysis_export);

				wagt_top.agnth.monh.monitor_port.connect(sb.fifo_wrh.analysis_export);

		end
				
	endfunction

endclass
		


