class AXI_Agent extends uvm_agent;

	`uvm_component_utils(AXI_Agent)

     AXI_Sequencer axi_seq;
     AXI_Driver    axi_drv;
     AXI_Monitor   axi_mon;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-------------------------AXI_Agent_build-------------------------------",UVM_NONE)
		axi_seq = AXI_Sequencer::type_id::create("axi_seq", this);
		axi_drv = AXI_Driver::type_id::create("axi_drv", this);
		axi_mon = AXI_Monitor::type_id::create("axi_mon", this);	
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	    `uvm_info(get_full_name(),"-------------------------AXI_Agent_connect-------------------------------",UVM_NONE)
	    axi_drv.seq_item_port.connect(axi_seq.seq_item_export);	
	endfunction : connect_phase
	
endclass : AXI_Agent