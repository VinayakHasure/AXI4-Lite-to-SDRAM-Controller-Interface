class SDRAM_Agent extends uvm_agent;

	`uvm_component_utils(SDRAM_Agent)

     // SDRAM_Sequencer sdm_seq;
     // SDRAM_Driver    sdm_drv;
     SDRAM_Monitor   sdm_mon;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-------------------------SDRAM_Agent_build-------------------------------",UVM_NONE)
		// sdm_seq = SDRAM_Sequencer::type_id::create("sdm_seq", this);
		// sdm_drv = SDRAM_Driver::type_id::create("sdm_drv", this);
		sdm_mon = SDRAM_Monitor::type_id::create("sdm_mon", this);	
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	    `uvm_info(get_full_name(),"-------------------------SDRAM_Agent_connect-------------------------------",UVM_NONE)
	    // sdm_drv.seq_item_port.connect(sdm_seq.seq_item_export);	
	endfunction : connect_phase
	
endclass : SDRAM_Agent