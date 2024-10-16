class rd_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(rd_xtn);

	bit [7:0] header;
	bit [7:0] payload[];
	bit [7:0] parity;
	rand int no_of_clock_cycle;
	
	function new (string name = "rd_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);

	printer.print_field("header",header,8,UVM_DEC);
	
	foreach(payload[i])begin
		printer.print_field($sformatf("payload[%0d]",i),payload[i],8,UVM_DEC);
	end
	
	printer.print_field("parity",parity,8,UVM_DEC);

	printer.print_field("No of clock Cycle",no_of_clock_cycle,32,UVM_DEC);
	endfunction

	function bit do_compare(uvm_object rhs,uvm_comparer comparer=null);
			rd_xtn rhs_2;

		if(!$cast(rhs_2,rhs))
			begin
				`uvm_error("do_compare","casting failed")
				return 0;
			end

		return
			super.do_compare(rhs,comparer) &&
			this.header == rhs_2.header &&
			this.payload == rhs_2.payload &&
			this.parity == rhs_2.parity;
	endfunction

endclass
