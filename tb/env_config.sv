class env_config extends uvm_object;

`uvm_object_utils(env_config)

	bit has_wagent = 1;
	bit has_ragent = 1;
	bit has_virtual_sequencer = 1;
	bit has_scoreboard = 1;
	bit [1:0] addr;
	wr_agent_cfg wr_cfg;
	rd_agent_cfg rd_cfg[];


	int no_of_agent;
	int no_of_repeat;
	function new(string name = "ram_env_config");
			super.new(name);
	endfunction

	function void build_phase(uvm_phase phase);
		rd_cfg = new[no_of_agent];
	endfunction

endclass
