class rd_agent_top extends uvm_env;

	`uvm_component_utils(rd_agent_top)

	  rd_agent agnth[];
	env_config env_cfg;
	function new(string name = "wr_agent_top" , uvm_component parent);
			super.new(name,parent);
	endfunction
		
	function void build_phase(uvm_phase phase);
			if(!uvm_config_db #(env_config) :: get(this,"","env_config",env_cfg))
			`uvm_fatal("AGT_TOP","configuration getting failed")

			agnth = new[env_cfg.no_of_agent];
			
			foreach(agnth[i])begin
					agnth[i] = rd_agent :: type_id :: create($sformatf("agnth[%0d]",i),this);
						end
			endfunction
	
	
endclass

