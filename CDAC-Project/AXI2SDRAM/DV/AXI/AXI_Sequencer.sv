class AXI_Sequencer extends uvm_sequencer#(AXI_Packet);

	`uvm_component_utils(AXI_Sequencer)
    
	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new
	
endclass : AXI_Sequencer