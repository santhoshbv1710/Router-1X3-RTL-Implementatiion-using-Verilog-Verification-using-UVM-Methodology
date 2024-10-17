module router_fsm(input clock,resetn,pkt_valid,parity_done,
                                     input[1:0]data_in,
		                 	input soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
	                                      output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

reg [2:0]ste;
reg [2:0]nste;

parameter DECODE_ADDRESS     = 3'b000,       //s0
          LOAD_FIRST_DATA    = 3'b001,       //s1
	  LOAD_DATA          = 3'b010,      //s2
	  FIFO_FULL_STATE    = 3'b011,     //s3
	  LOAD_AFTER_FULL    = 3'b100,    //s4
	  LOAD_PARITY        = 3'b101,   //s5
	  CHECK_PARITY_ERROR = 3'b110,  //s6
	  WAIT_TILL_EMPTY    = 3'b111; //s7


	  reg[1:0]addr;

	  always@(posedge clock)begin
		  if(!resetn)
			  addr <= 2'b0;
		  else 
			  addr <= data_in;
	  end

	  always@(posedge clock)begin
		  if(!resetn)
			  ste <= DECODE_ADDRESS;
		  else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
			  ste <= DECODE_ADDRESS;
		  else
			  ste <= nste;
	  end

	  always@(*)begin
		  case(ste)
			  DECODE_ADDRESS : if((pkt_valid && (data_in[1:0] == 0) && fifo_empty_0)||
                               (pkt_valid && (data_in[1:0] == 1) && fifo_empty_1)||
					                (pkt_valid && (data_in[1:0] == 2) && fifo_empty_2)) nste = LOAD_FIRST_DATA;
					    
					   else if((pkt_valid && (data_in[1:0] == 0) && !fifo_empty_0)||
                          (pkt_valid && (data_in[1:0] == 1) && !fifo_empty_1)||
					           (pkt_valid && (data_in[1:0] == 2) && !fifo_empty_2)) nste =  WAIT_TILL_EMPTY;  else nste =  DECODE_ADDRESS;

		          LOAD_FIRST_DATA : nste = LOAD_DATA;
		        
		          LOAD_DATA : if(!fifo_full && !pkt_valid) nste =  LOAD_PARITY ; else if(fifo_full) nste = FIFO_FULL_STATE; else nste = LOAD_DATA ;

			  FIFO_FULL_STATE : if(!fifo_full) nste = LOAD_AFTER_FULL ; else nste = FIFO_FULL_STATE;

		          LOAD_AFTER_FULL : if(!parity_done && low_pkt_valid) nste =  LOAD_PARITY; else if(!parity_done && !low_pkt_valid) nste = LOAD_DATA ;
		                            else if(parity_done) nste = DECODE_ADDRESS; else nste = LOAD_AFTER_FULL;

                          LOAD_PARITY : nste = CHECK_PARITY_ERROR;
		          
		          CHECK_PARITY_ERROR : if(fifo_full) nste = FIFO_FULL_STATE; else if(!fifo_full) nste  = DECODE_ADDRESS;else nste = CHECK_PARITY_ERROR;                          

	                  WAIT_TILL_EMPTY : if((fifo_empty_0 && (addr == 0)) || (fifo_empty_1 && (addr == 1)) || (fifo_empty_2 && (addr == 2))) 
		                   nste = LOAD_FIRST_DATA; else nste = WAIT_TILL_EMPTY;

				    default : nste = DECODE_ADDRESS;

		    endcase
	    end


assign detect_add = (ste == DECODE_ADDRESS);

assign ld_state = (ste == LOAD_DATA);

assign laf_state = (ste == LOAD_AFTER_FULL);

assign full_state = (ste == FIFO_FULL_STATE);

assign write_enb_reg = ( ste  == LOAD_DATA || ste == LOAD_PARITY || ste == LOAD_AFTER_FULL);

assign rst_int_reg = (ste == CHECK_PARITY_ERROR);

assign lfd_state = (ste == LOAD_FIRST_DATA);

assign busy = (ste == LOAD_FIRST_DATA || ste == LOAD_PARITY || ste == FIFO_FULL_STATE || ste  == LOAD_AFTER_FULL || ste == WAIT_TILL_EMPTY || ste == CHECK_PARITY_ERROR);

endmodule 

		          
		          



                          		  

				      




