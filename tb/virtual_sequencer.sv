class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

	`uvm_component_utils(virtual_sequencer)

	wr_sequencer wr_seqr;
	rd_sequencer rd_seqr[];
	env_config env_cfg;

function new(string name = "virtual_sequencer",uvm_component parent);
		super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",env_cfg))
		`uvm_fatal("VR_SEQR","Getting failed !!!")

		rd_seqr = new[env_cfg.no_of_agent];
		
endfunction

endclass

