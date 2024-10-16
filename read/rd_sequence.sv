class rd_seqs_base extends uvm_sequence #(rd_xtn);

	`uvm_object_utils(rd_seqs_base)

	function new(string name = "rd_seqs_base");
		super.new(name);
	endfunction

	env_config env_cfg;
	
	task body();
		if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",env_cfg))
			`uvm_fatal("WR_SEQ","Getting failed !!!!")
	endtask

endclass


class rd_less_ft_seqs extends rd_seqs_base;

	`uvm_object_utils(rd_less_ft_seqs)

	function new(string name = "rd_less_ft_seqs");
		super.new(name);
	endfunction

  //  extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=rd_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_clock_cycle inside {[1:10]};});
		`uvm_info("RD_SEQS",$sformatf("printing from sequence \n %s",req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

class rd_equal_ft_seqs extends rd_seqs_base;

	`uvm_object_utils(rd_equal_ft_seqs)

	function new(string name = "rd_equal_ft_seqs");
		super.new(name);
	endfunction

   // extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=rd_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_clock_cycle inside {[0:10]};});
		`uvm_info("RD_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

class rd_great_ft_seqs extends rd_seqs_base;

	`uvm_object_utils(rd_great_ft_seqs)

	function new(string name = "rd_great_ft_seqs");
		super.new(name);
	endfunction

   // extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=rd_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_clock_cycle inside {[21:30]};});
		`uvm_info("RD_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

class rd_error_seqs extends rd_seqs_base;

	`uvm_object_utils(rd_error_seqs)

	function new(string name = "rd_error_seqs");
		super.new(name);
	endfunction

  //  extern task body();
	task body();
		super.body();
	//	repeat(env_cfg.no_of_repeat)begin
   	   	req=rd_xtn::type_id::create("req");		
		start_item(req);
		assert(req.randomize() with {no_of_clock_cycle == 5;});
		`uvm_info("RD_SEQS",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//	end
	endtask

endclass

