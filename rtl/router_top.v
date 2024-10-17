module router_top (input clock,resetn,read_enb_0,read_enb_1,read_enb_2,
	input [7:0]data_in,
	input pkt_valid,
	output [7:0]data_out_0,data_out_1,data_out_2,
	output valid_out_0,valid_out_1,valid_out_2,error,busy);


wire [2:0] write_enb1;			
wire [7:0]dt;
wire emt0,emt1,emt2;



router_fsm  rfsm(clock,resetn,pkt_valid,parity_done,data_in[1:0],soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,emt0,emt1,emt2,busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);


router_sync  rsync(detect_add,data_in[1:0],write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,emt0,emt1,emt2,
				full_0,full_1,full_2,
			 write_enb1,
				 fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,
				 valid_out_0,valid_out_1,valid_out_2);

router_reg   rr( clock,resetn,pkt_valid,data_in,
	 fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
	parity_done,low_pkt_valid,error,dt);

router_fifo rf1( clock,resetn,soft_reset_0,write_enb1[0],read_enb_0,lfd_state,dt,full_0,emt0,data_out_0);

router_fifo rf2( clock,resetn,soft_reset_1,write_enb1[1],read_enb_1,lfd_state,dt,full_1,emt1,data_out_1);

router_fifo rf3( clock,resetn,soft_reset_2,write_enb1[2],read_enb_2,lfd_state,dt,full_2,emt2,data_out_2);


endmodule



	




