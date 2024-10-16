
class virtual_seqs_base extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(virtual_seqs_base)


		wr_sequencer wr_seqr;
		rd_sequencer rd_seqr[];
    virtual_sequencer vsqr;

		
		wr_less_ft_seqs wr_less;
		rd_less_ft_seqs rd_less;

		wr_equal_ft_seqs wr_equal;
		rd_equal_ft_seqs rd_equal;

		wr_great_ft_seqs wr_great;
		rd_great_ft_seqs rd_great;

		wr_error_seqs wr_error;
		rd_error_seqs rd_error;

		env_config env_cfg;
		bit [1:0] addr;
	 function new(string name = "virtual_seqs_base");
		super.new(name);
	endfunction


		task body();
			if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",env_cfg))
				`uvm_fatal("VR_SEQS","Getting failed !!!")
			if(!uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit",addr))
				`uvm_fatal("VR_SEQS","getting failed")

 			 assert($cast(vsqr,m_sequencer)) else begin
    			`uvm_error("VR_SEQS_BODY", "Error in $cast of virtual sequencer")
			  end
				
				  wr_seqr = vsqr.wr_seqr;
				  rd_seqr = new[env_cfg.no_of_agent];
				rd_seqr[addr] = vsqr.rd_seqr[addr];
		endtask

   
endclass

class less_ft_vseqs extends virtual_seqs_base;

		`uvm_object_utils(less_ft_vseqs)

	 function new(string name = "less_ft_vseqs");
		super.new(name);
	endfunction

	 task body();
		super.body();
		wr_less = wr_less_ft_seqs :: type_id :: create("wr_less");
		rd_less = rd_less_ft_seqs :: type_id :: create("rd_less");

	fork
		wr_less.start(wr_seqr);
 		
		rd_less.start(rd_seqr[addr]);
	join
	endtask
			
				
		
endclass


class equal_ft_vseqs extends virtual_seqs_base;

		`uvm_object_utils(equal_ft_vseqs)

	 function new(string name = "equal_ft_vseqs");
		super.new(name);
	endfunction
//	extern task body();

	 task body();
		super.body();
		wr_equal = wr_equal_ft_seqs :: type_id :: create("wr_equal");
		rd_equal = rd_equal_ft_seqs :: type_id :: create("rd_equal");
	fork
		wr_equal.start(wr_seqr);
 		
		rd_equal.start(rd_seqr[addr]);
	join
		
	endtask

		
//	endtask
			
endclass


class great_ft_vseqs extends virtual_seqs_base;

		`uvm_object_utils(great_ft_vseqs)

	 function new(string name = "great_ft_vseqs");
		super.new(name);
	endfunction
//	extern task body();
	 task body();
		super.body();
		wr_great = wr_great_ft_seqs :: type_id :: create("wr_great");
		rd_great = rd_great_ft_seqs :: type_id :: create("rd_great");
	
	fork
		wr_great.start(wr_seqr);
 		
		rd_great.start(rd_seqr[addr]);
	join
	endtask


//	endtask
			
endclass



class error_vseqs extends virtual_seqs_base;

		`uvm_object_utils(error_vseqs)

	 function new(string name = "error_vseqs");
		super.new(name);
	endfunction
//	extern task body();

	 task body();
		super.body();
		wr_error = wr_error_seqs :: type_id :: create("wr_error");
		rd_error = rd_error_seqs :: type_id :: create("rd_error");

		
	fork
		wr_error.start(wr_seqr);
		
		rd_error.start(rd_seqr[addr]);
	join
		
	endtask
		
endclass
