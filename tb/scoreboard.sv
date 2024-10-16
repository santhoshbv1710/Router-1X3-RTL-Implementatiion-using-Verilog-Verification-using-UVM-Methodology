class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

    uvm_tlm_analysis_fifo #(rd_xtn) fifo_rdh[];
    uvm_tlm_analysis_fifo #(wr_xtn) fifo_wrh;

	env_config env_cfg;
	wr_xtn wr_data;
	rd_xtn rd_data;
	
	static int wr_xtn_in=0;
	static int rd_xtn_in=0;

	static int compared_count =0;
	static int dropped_count = 0;
	bit [1:0] addr;

	wr_xtn wr_cov;

covergroup rout_fcov;
	option.per_instance=1;

		
          PAYLOAD_LENGTH : coverpoint wr_cov.header[7:2] {
					bins low = {1};
					bins mid1 = {[2:5]};
					bins mid2 = {[6:10]};
					bins mid3 = {[11:13]};
					bins high = {14};
						}
    	     	     
           ADDR : coverpoint wr_cov.header[1:0] {
                   bins addr_0  =  {0};
		   bins addr_1  =  {1};
		   bins addr_2  =  {2};
                 }
    
            ERROR : coverpoint wr_cov.error;
         LEN_X_ADDR : cross ADDR,PAYLOAD_LENGTH;
          
endgroup


	function new(string name = "scoreboard",uvm_component parent);
		super.new(name,parent);
			rout_fcov = new();
	endfunction

		function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config) :: get(this,"","env_config",env_cfg))
			`uvm_fatal("SB","Getting failed !!!!")

				fifo_rdh = new[env_cfg.no_of_agent];
				foreach(fifo_rdh[i])
				fifo_rdh[i] = new($sformatf("fifo_rdh[%0d]",i),this);

				fifo_wrh = new("fifo_wrh",this);
		endfunction

	

		task run_phase (uvm_phase phase);
				forever
					begin
						fifo_wrh.get(wr_data);
						wr_xtn_in++;
						wr_cov = wr_data;
    						rout_fcov.sample();						
						fifo_rdh[wr_data.header[1:0]].get(rd_data);
						rd_xtn_in++;						
						check_data(rd_data);
					end
		endtask
		
	function void check_data(rd_xtn rd);
		if(wr_data.error)begin
				dropped_count++;
			`uvm_info("DEST_PACKET :",$sformatf("printing from sb  ==> parity = %0d",rd.parity),UVM_LOW)
			`uvm_info("SOURCE_PACKET :",$sformatf("printing from sb ==> parity = %0d",wr_data.parity),UVM_LOW)
			
			`uvm_error("SB","Parity not matched -----> Corrupted packet recieved by destination")		
		end
		else
			begin
		rd_xtn rd_new;
		rd_new = rd_xtn :: type_id :: create("rd_new");
		rd_new.header = wr_data.header;
		rd_new.payload = wr_data.payload;
		rd_new.parity = wr_data.parity;
	
			
		if(rd_new.compare(rd))begin
			compared_count++;
			`uvm_info("SB","Packets matched both read and write",UVM_LOW)
			`uvm_info("SB","Packet sent to the destination Successfully",UVM_LOW)
			`uvm_info("DEST_PACKET :",$sformatf("printing from sb \n %s", rd.sprint()),UVM_LOW)
			`uvm_info("SOURCE_PACKET :",$sformatf("printing from sb \n %s", rd_new.sprint()),UVM_LOW)

		end
		else
			begin
				dropped_count++;
				`uvm_info("DEST_PACKET :",$sformatf("printing from sb \n %s", rd.sprint()),UVM_LOW)
				`uvm_info("SOURCE_PACKET :",$sformatf("printing from sb \n %s", rd_new.sprint()),UVM_LOW)

				`uvm_error("SB","Packets not matched")
			end
	end
	endfunction

function void report_phase(uvm_phase phase);
	`uvm_info("SB REPORT :",$sformatf("No of Write transaction recived = %0d \n                                                                               No of read transaction recived = %0d",wr_xtn_in,rd_xtn_in),UVM_LOW) 
		`uvm_info("SB REPORT :",$sformatf("No of times compared successfully = %0d \n                         	                                               No of times dropped = %0d",compared_count,dropped_count),UVM_LOW) 
endfunction

endclass	
