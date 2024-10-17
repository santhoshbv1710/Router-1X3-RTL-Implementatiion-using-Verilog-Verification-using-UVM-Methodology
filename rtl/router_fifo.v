module router_fifo #(localparam W=9,D=16,A=4)
                      (input clock,resetn,soft_reset,write_enb,read_enb,lfd_state,
			                  input [W-2:0]data_in,
                                output full,empty,
			                           	output reg[W-2:0]data_out);

//localparam W=9,D=16,A=4;
reg [W-1:0]mem[0:D-1];
reg [A:0]wp,rp;
integer i;
reg [W-3:0]count;
reg tlfd;
//reg [4:0]c;
always@(posedge clock)begin
	if(!resetn)
		tlfd<=0;
	else
		tlfd<=lfd_state;
end

//write operation
always@(posedge clock)
begin
	if(!resetn)
	begin
		for(i=0;i<D;i=i+1)begin
			mem[i]<=0;
			end
		wp<=0;
	end
	else if(soft_reset)
	begin
		for(i=0;i<D;i=i+1)begin
			mem[i]<=0;
			end
		wp<=0;
	end
	
	else if(write_enb && !full)
	begin
			if(wp[4])
			wp<=1'b0;
		else begin
				mem[wp]<={tlfd,data_in};
			wp<=wp+1'b1;
		end
	end
	end
			

always@(posedge clock)
begin
	if(!resetn)
	begin
		rp<=5'b0;
		data_out<=1'b0;
		
	end
	else if(soft_reset)
	begin
		rp<=5'b0;
		data_out<= 1'bz;
	end
	else if(count== 7'b0 && data_out!=0)
		data_out<= 1'bz;
	else if(read_enb && !empty)
	begin
			if(rp[4])
			rp<=1'b0;
		else
		begin
	data_out<=mem[rp[3:0]][W-2:0];
		rp<=rp+1'b1;
		end
	end

end

always@(posedge clock)
begin
if(!resetn) count<=7'b0;
else if(soft_reset) count<=7'b0;
else if(read_enb && !empty)begin
	case( mem[rp[3:0]][W-1])
       1'b1 :  count <= mem[rp[3:0]][7:2]+1'b1;
	    1'b0 : if(count!=7'b0) count<=count-1'b1; else count<=count;
	    default : count <= count;
    endcase
end

else
count<=count;

end

assign full=(wp == D && rp == 0);
assign empty=(rp == wp);

/*
assign empty=(wp==rp);
assign full=(wp+1==rp);

*/
endmodule

