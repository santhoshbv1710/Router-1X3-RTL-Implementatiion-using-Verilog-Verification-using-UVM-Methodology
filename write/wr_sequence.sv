class wr_seqs_base extends uvm_sequence #(wr_xtn);

	`uvm_object_utils(wr_seqs_base)
	env_config env_cfg;
	bit [1:0] addr;
	function new(string name = "wr_seqs_base");
		super.new(name);
	endfunction

	task body();
		if(!uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit",addr))
			`uvm_fatal("WR_SEQ","Getting failed !!!!")
	endtask

		

endclass


class wr_less_ft_seqs extends wr_seqs_base;

	`uvm_object_utils(wr_less_ft_seqs)

	function new(string name = "wr_less_ft_seqs");
		super.new(name);
	endfunction
//endfunction

   	task body();
		super.body();
   	   	req=wr_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:13]}; header[1:0] == addr;});
		`uvm_info("WR_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask
endclass

class wr_equal_ft_seqs extends wr_seqs_base;

	`uvm_object_utils(wr_equal_ft_seqs)

	function new(string name = "wr_equal_ft_seqs");
		super.new(name);
	endfunction

   	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=wr_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {header[7:2] == 14; header[1:0] == addr;});
		`uvm_info("WR_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

class wr_great_ft_seqs extends wr_seqs_base;

	`uvm_object_utils(wr_great_ft_seqs)

	function new(string name = "wr_great_ft_seqs");
		super.new(name);
	endfunction

   // extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=wr_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[14:20]}; header[1:0] == addr;});
		`uvm_info("WR_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

class wr_error_seqs extends wr_seqs_base;

	`uvm_object_utils(wr_error_seqs)
	

	function new(string name = "wr_error_seqs");
		super.new(name);
	endfunction

   // extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=wr_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:14]};  header[1:0] == addr;});
		`uvm_info("WR_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask


endclass

