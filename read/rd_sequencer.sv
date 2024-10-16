class rd_sequencer extends uvm_sequencer #(rd_xtn);

	`uvm_component_utils(rd_sequencer);
  
		function new(string name = "rd_sequencer",uvm_component parent);
		super.new(name,parent);
 	endfunction
endclass
