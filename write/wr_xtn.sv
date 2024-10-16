class wr_xtn extends uvm_sequence_item;

	`uvm_object_utils(wr_xtn)

	rand bit [7:0] header;
	rand bit [7:0] payload[];
	 bit [7:0] parity;
	
//	bit resetn;
	
	bit error;
	constraint lt_header {header[1:0] != 2'b11;}
	
	constraint lt_payload {payload.size == header[7:2] && header[7:2] != 0;}
	
	function new(string name = "wr_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);

	printer.print_field("header",header,8,UVM_DEC);
	
	foreach(payload[i])begin
		printer.print_field($sformatf("payload[%0d]",i),payload[i],8,UVM_DEC);
	end

	printer.print_field("parity",parity,8,UVM_DEC);

	endfunction

	function void post_randomize();
		parity = header;

		foreach(payload[i])
				parity = parity ^ payload[i];
	endfunction
endclass

class wr_xtn_ext extends wr_xtn;
	`uvm_object_utils(wr_xtn_ext)

	function new(string name = "wr_xtn_ext");
		super.new(name);
	endfunction

	function void post_randomize();
		parity = header;
		foreach(payload[i])
				parity = parity + payload[i];

	endfunction
endclass

