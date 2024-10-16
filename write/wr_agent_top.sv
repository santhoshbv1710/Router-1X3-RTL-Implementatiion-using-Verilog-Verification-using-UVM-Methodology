class wr_agent_top extends uvm_env;

	`uvm_component_utils(wr_agent_top)

	  wr_agent agnth;

	function new(string name = "wr_agent_top" , uvm_component parent);
			super.new(name,parent);
	endfunction
		
	function void build_phase(uvm_phase phase);
			agnth=wr_agent::type_id::create("wr_agnth",this);
	endfunction
	 task run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask			
	
endclass

