module router_sync #(parameter N=2)
                    (input detect_add,
			    input [N-1:0]data_in,
			        input write_enb_reg,clock,resetn,read_enb_0,read_enb_1,read_enb_2,empty_0,empty_1,empty_2,
				full_0,full_1,full_2,
				output reg [N:0]write_enb,
				output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,
				output vld_out_0,vld_out_1,vld_out_2);


			reg[N-1:0]add;
			reg[4:0]count_0,count_1,count_2;

			always@(posedge clock)begin
				if(!resetn)
					add <= {N{1'b0}};
				else if(detect_add)
					add <= data_in;
					else
					add<=add;
			end

			///////////// write enableeeeeeeeeeeeeee

			always@(*)begin
				if(write_enb_reg)begin
					case(add)
						2'b00 : write_enb = 3'b001;
						2'b01 : write_enb = 3'b010;
						2'b10 : write_enb = 3'b100;
						
						default : write_enb = 3'b000;
					endcase
				end
				else
					write_enb = 3'b000;
			end

			////////////// fifo_fulllllllllll

			always@(*)begin
				case(add)
					2'b00 : fifo_full = full_0;
					2'b01 : fifo_full = full_1;
					2'b10 : fifo_full = full_2;
					//2'b11 : fifo_full = 1'b0;
					default : fifo_full = 1'b0;
				endcase
			end
			
			
			////////for empty and assign validx
			
			assign vld_out_0 = ~empty_0;
		   assign vld_out_1 = ~empty_1;
			assign vld_out_2 = ~empty_2;

			////////////for count 0 and soft_rst 0

			always@(posedge clock)begin
				if(!resetn)begin
					count_0 <= 5'b1;
					soft_reset_0 <= 1'b0;
				end
				else if(!vld_out_0)begin
					count_0 <= 5'b1;
					soft_reset_0 <= 5'b0;
				end
				else if(read_enb_0)
	begin
		count_0<=5'b1;
		soft_reset_0<=0;
	end
	else
	begin
		if(count_0==5'd30)
		begin
			count_0<=5'b1;
			soft_reset_0<=1'b1;
		end
		else
		begin
			soft_reset_0<=0;
			count_0<=count_0+1'b1;
		end
	end
			end

				//////////for count 1 and soft reset 1

			always@(posedge clock)begin
				if(!resetn)begin
					count_1 <= 5'b1;
					soft_reset_1 <= 1'b0;
				end
				else if(!vld_out_1)begin
					count_1 <= 5'b1;
					soft_reset_1 <= 5'b0;
				end
			else if(read_enb_1)
	begin
		count_1<=5'b1;
		soft_reset_1<=0;
	end
	else
	begin
		if(count_1==5'd30)
		begin
			count_1<=5'b1;
			soft_reset_1<=1'b1;
		end
		else
		begin
			soft_reset_1<=0;
			count_1<=count_1+1'b1;
		end
	end
			end

			////////////////for count 2 and soft reset 2
			
			always@(posedge clock)begin
				if(~resetn)begin
					count_2 <= 5'b1;
					soft_reset_2 <= 1'b0;
				end
				else if(~vld_out_2)begin
					count_2 <= 5'b1;
					soft_reset_2 <= 5'b0;
				end
	
		else if(read_enb_2)
	begin
		count_2<=5'b1;
		soft_reset_2<=0;
	end
	else
	begin
		if(count_2==5'd30)
		begin
			count_2<=5'b1;
			soft_reset_2<=1'b1;
		end
		else
		begin
			soft_reset_2<=0;
			count_2<=count_2+1'b1;
		end
	end

end

				
			

	endmodule



				













