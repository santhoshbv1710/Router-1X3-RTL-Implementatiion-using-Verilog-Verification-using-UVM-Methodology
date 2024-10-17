module router_reg(input clock,resetn,pkt_valid,
	input [7:0]data_in,
	input fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,
	output reg parity_done,low_pkt_valid,err,
	output reg [7:0]dout);


reg [7:0] head,ffb,intp,packp; 

////////////////////////////////////////douttttttttttttttttttttttttttttt

always@(posedge clock)begin
	if(!resetn)
		dout<=0;
	else begin
		if(detect_add && pkt_valid && (data_in[1:0] != 3)) dout <= dout;
	        else
		begin
			if(lfd_state) dout<=head;
		        else
			begin
				if(ld_state && (!fifo_full)) dout<=data_in;
				else
				begin
					if(ld_state && fifo_full) dout<=dout;
					else
					begin
						if(laf_state) dout <= ffb; else dout<= dout;
					end
			      end
	        	end
		end
	end
end


////////////////////////////////////headerrrrrrrrrrrrrrrrr

always@(posedge clock)begin
	if(!resetn)
		head<=0;
	else
	begin
		if(detect_add && pkt_valid && (data_in[1:0] != 3)) head<= data_in; else head <= head;
	end
end

///////////////////////////////// Innternal parity byteeeeeeeeeeeeeeeeeeeeee

always@(posedge clock)begin
	if(!resetn)
             intp <= 0;
   else
	begin
		if(detect_add)
			intp <= 0;
		else
		begin
			if(lfd_state)
				intp <= intp ^ head;
			else
			begin
				if(pkt_valid && ld_state && (!full_state))
					intp <= intp ^ data_in;
				else
					intp<=intp;
			end
		end
	end
end

/////////////////////// packet_parityyyyyyyyyyyyyyyyyyyyyyyyyyy byteeeeee

always@(posedge clock)begin
	if(!resetn)
		packp <= 0;
	else
	begin
		if(detect_add)
			packp <= 0;
		else
		begin
			if(ld_state && (!pkt_valid))
				packp <= data_in;
			else
				packp <= packp;
		end
	end
end

////////////////////fifo full state byteeeeeeeeeeeeeeeeee

always@(posedge clock)begin
	if(!resetn)
		ffb <= 0;
	else
	begin
		if(fifo_full && ld_state)
			ffb <= data_in;
		else
			ffb <= ffb;
	end
end
	

///////////////parity doneeeeeeeeeeeeeeeee

always@(posedge clock)
begin
	if(!resetn)
		parity_done <= 1'b0;
	  else if(detect_add)
		parity_done <= 1'b0;
		else
	begin
		if((ld_state) && (!fifo_full) && (!pkt_valid) && (laf_state))
			parity_done <= 1'b1;
			else if((laf_state) && (low_pkt_valid) && (!parity_done))
			parity_done <= 1'b1;
		else
			parity_done <= 1'b0;
	end
end

////////////// low pkttt validdddddd

always@(posedge clock)begin
	if(!resetn || rst_int_reg)
		low_pkt_valid <= 0;
	else
	begin
		if(ld_state && (!pkt_valid))
			low_pkt_valid <= 1'b1;
	end
end

/////////////errrrrrrrrrrrrrrr

always@(posedge clock)begin
	if(!resetn)
		err <= 0;
	else
	begin
		if(rst_int_reg)
	//	if(parity_done)
		begin
			if(intp != packp)
				err <= 1'b1;
		end
	end
end

endmodule










