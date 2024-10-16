module top;

	import router_pkg :: *;
	import uvm_pkg :: *;

	bit clk;

	always
		#10 clk = ~clk;

	wr_if in(clk);
	rd_if in0(clk);
	rd_if in1(clk);
	rd_if in2(clk);

	router_top DUV (.clock(clk),.resetn(in.resetn),.read_enb_0(in0.read_enb),.read_enb_1(in1.read_enb),.read_enb_2(in2.read_enb),
			.data_in(in.data_in),.pkt_valid(in.pkt_valid),.data_out_0(in0.data_out),.data_out_1(in1.data_out),.data_out_2(in2.data_out),
			 .valid_out_0(in0.vld_out),.valid_out_1(in1.vld_out),.valid_out_2(in2.vld_out),.error(in.error),.busy(in.busy));

	initial
		begin

			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
	

			uvm_config_db #(virtual wr_if) :: set(null,"*","vif",in);
			uvm_config_db #(virtual rd_if) :: set(null,"*","vif_0",in0);
			uvm_config_db #(virtual rd_if) :: set(null,"*","vif_1",in1);
			uvm_config_db #(virtual rd_if) :: set(null,"*","vif_2",in2);



			run_test();
		end



  /////////////////////////////////////////////////////////////////////////////////assertion////////////////////////////////////////////////////////////////////////
  
property reset;
	@(posedge clk) !in.resetn |-> (in0.data_out == 0 || in1.data_out == 0 || in2.data_out == 0 && in.busy == 0);
endproperty

property pkt_vld;
	@(posedge clk) disable iff(!in.resetn)
				in.pkt_valid |=> in.busy;
endproperty

property vldxpkt;
	@(posedge clk) disable iff(!in.resetn)
				in.pkt_valid |-> ##3 (in0.vld_out || in1.vld_out || in2.vld_out);
endproperty

property vld_out_0;
	@(posedge clk) disable iff(!in.resetn)
				in0.vld_out |-> ##[0:29] in0.read_enb;
endproperty

property vld_out_1;
	@(posedge clk) disable iff(!in.resetn)
				in1.vld_out |-> ##[0:29] in1.read_enb;
endproperty

property vld_out_2;
	@(posedge clk) disable iff(!in.resetn)
				in2.vld_out |-> ##[0:29] in2.read_enb;
endproperty

property busy_ck;
	@(posedge clk) disable iff(!in.resetn)
				in.busy |-> $stable(in.data_in);
endproperty

property error_ck;
	@(posedge clk) disable iff(!in.resetn)
				DUV.rr.rst_int_reg |-> if(DUV.rr.intp != DUV.rr.packp)
							in.error == 1
							else
							in.error == 0;
endproperty

property rd_enb_0;
	@(posedge clk) disable iff(!in.resetn)
				in0.read_enb && in0.vld_out |=> in0.data_out != 0;
endproperty

property rd_enb_1;
	@(posedge clk) disable iff(!in.resetn)
				in1.read_enb && in1.vld_out |=> in1.data_out != 0;
endproperty

property rd_enb_2;
	@(posedge clk) disable iff(!in.resetn)
				in2.read_enb && in2.vld_out |=> in2.data_out != 0;
endproperty


RESET : assert property(reset);

PKT_VLD :  assert property(pkt_vld);

VLDXPKT : assert property(vldxpkt);

VLD_OUT_0 : assert property(vld_out_0);

VLD_OUT_1 : assert property(vld_out_1);

VLD_OUT_2 : assert property(vld_out_2);

BUSY : assert property(busy_ck);

ERROR : assert property(error_ck);

RD_ENB_0 : assert property(rd_enb_0);

RD_ENB_1 : assert property(rd_enb_1);

RD_ENB_2 : assert property(rd_enb_2);

  ////////////////////////////////////////////assertion coverage/////////////////////////////////////////////
  
COV_RESET : cover property(reset);

COV_PKT_VLD :  cover property(pkt_vld);

COV_VLDXPKT : cover property(vldxpkt);

COV_VLD_OUT_0 : cover property(vld_out_0);

COV_VLD_OUT_1 : cover property(vld_out_1);

COV_VLD_OUT_2 : cover property(vld_out_2);

COV_BUSY : cover property(busy_ck);

COV_ERROR : cover property(error_ck);

COV_RD_ENB_0 : cover property(rd_enb_0);

COV_RD_ENB_1 : cover property(rd_enb_1);

COV_RD_ENB_2 : cover property(rd_enb_2);


endmodule
