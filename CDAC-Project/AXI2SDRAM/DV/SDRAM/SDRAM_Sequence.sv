class SDRAM_Sequence extends SDRAM_base_Sequence;

	`uvm_object_utils(SDRAM_Sequence)

	SDRAM_Packet trans;

	//constructor
	function new(string name="SDRAM_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------SDRAM_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(5)begin
			trans=SDRAM_Packet::type_id::create("trans");
			start_item(trans);
			assert(trans.randomize());
			`uvm_info(get_full_name(),"################################-SDRAM Generated Packet-############################",UVM_NONE)
			trans.print();
			finish_item(trans);
		end
	endtask : body

endclass : SDRAM_Sequence
