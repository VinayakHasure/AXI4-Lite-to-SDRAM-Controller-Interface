class SDRAM_Sequencer extends uvm_sequencer#(SDRAM_Packet);

	`uvm_component_utils(SDRAM_Sequencer)
    
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
endclass : SDRAM_Sequencer