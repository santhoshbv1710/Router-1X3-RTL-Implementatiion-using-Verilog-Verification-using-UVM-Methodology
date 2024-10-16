class test_base extends uvm_test;

	`uvm_component_utils(test_base)

	
	env envh;
	env_config env_cfg;
	wr_agent_cfg wr_cfg;
	rd_agent_cfg rd_cfg[];

	bit [1:0] addr;
	int no_of_agent = 3;
	bit has_ragent = 1;
    	bit has_wagent = 1;
	int count = 100;
	function new(string name = "ram_base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void config_ram();
	 if (has_wagent)
		begin 			
			if(!uvm_config_db #(virtual wr_if)::get(this,"","vif",wr_cfg.vif))
				`uvm_fatal("TB","Getting failed !!!")
			wr_cfg.is_active = UVM_ACTIVE;
			env_cfg.wr_cfg = wr_cfg;
		end

	 if (has_ragent)
		begin 
			env_cfg.no_of_agent = no_of_agent;
			env_cfg.rd_cfg = new[no_of_agent];
			foreach(env_cfg.rd_cfg[i]) begin
				if(!uvm_config_db #(virtual rd_if)::get(this,"",$sformatf("vif_%0d",i),rd_cfg[i].vif))
				`uvm_fatal("TB","Getting failed !!!")
				rd_cfg[i].is_active = UVM_ACTIVE;
				env_cfg.rd_cfg[i] = rd_cfg[i];	
			end
		end
	 env_cfg.has_wagent = has_wagent;
         env_cfg.has_ragent = has_ragent;

                
	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
		  
	endfunction

		
	function void build_phase(uvm_phase phase);
		env_cfg=env_config::type_id::create("env_cfg");

	 if(has_wagent)
	        wr_cfg=wr_agent_cfg::type_id::create("wr_cfg");

   	 if(has_ragent)begin
		rd_cfg = new[no_of_agent];
		foreach(rd_cfg[i])begin
		rd_cfg[i] =rd_agent_cfg::type_id::create($sformatf("rd_cfg[%0d]",i));
		rd_cfg[i].is_active = UVM_ACTIVE;
		end
		end
	
		 config_ram();

		envh=env::type_id::create("envh", this);

	endfunction
        
	task call();
			randomize(addr) with {addr inside {[0:2]}; unique{addr};};
			uvm_config_db #(bit[1:0]) :: set(this,"*","bit",addr);
	endtask

endclass


class less_ft_test extends test_base;

	`uvm_component_utils(less_ft_test)
	less_ft_vseqs seqh;
	
	 function new(string name = "less_ft_test" , uvm_component parent);
			super.new(name,parent);
       	endfunction

	 function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction


	 task run_phase(uvm_phase phase);
  		  phase.raise_objection(this);
			repeat(count)begin
			super.call();
				seqh=less_ft_vseqs::type_id::create("seqh");
				seqh.start(envh.v_sequencer);
			end
		#30;
  		  phase.drop_objection(this);
		endtask
	
endclass

class equal_ft_test extends test_base;

	`uvm_component_utils(equal_ft_test)
		
	equal_ft_vseqs seqh;
	
	 function new(string name = "equal_ft_test" , uvm_component parent);
			super.new(name,parent);
       	endfunction

	 function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	 task run_phase(uvm_phase phase);
  		  phase.raise_objection(this);
		repeat(count)begin
			super.call();
			seqh=equal_ft_vseqs::type_id::create("seqh");
			seqh.start(envh.v_sequencer);
		end
		#30;
  		  phase.drop_objection(this);
	endtask	
endclass

class great_ft_test extends test_base;

	`uvm_component_utils(great_ft_test)
	
	great_ft_vseqs seqh;
	
	 function new(string name = "great_ft_test" , uvm_component parent);
			super.new(name,parent);
       	endfunction
							
	 function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	 task run_phase(uvm_phase phase);
  		  phase.raise_objection(this);
			repeat(count)begin
			super.call();				
			seqh=great_ft_vseqs::type_id::create("seqh");
				seqh.start(envh.v_sequencer);
			end
		#30;
  		  phase.drop_objection(this);
	endtask		
endclass


class error_ft_test extends test_base;

	`uvm_component_utils(error_ft_test)
	error_vseqs seqh;
	
	 function new(string name = "error_ft_test" , uvm_component parent);
			super.new(name,parent);
       	endfunction

	 function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	 task run_phase(uvm_phase phase);
  		  phase.raise_objection(this);
			repeat(count)begin
			super.call();		
			seqh=error_vseqs::type_id::create("seqh");
			set_type_override_by_type(wr_xtn::get_type(),wr_xtn_ext :: get_type(),1);
			seqh.start(envh.v_sequencer);
			end
		#30
  		  phase.drop_objection(this);
	endtask

	
		
endclass

