class AXI2SDRAM_Environment extends uvm_env;

	`uvm_component_utils(AXI2SDRAM_Environment)

	AXI_Agent   axi_agt;
	SDRAM_Agent sdram_agt;
	AXI_SDRAM_Scoreboard axi_sd_scb;
	AXI_SDRAM_Coverage axi_sd_cvg;
	
    function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-------------------------AXI2SDRAM_Environment_build-------------------------------",UVM_NONE)
		axi_agt   = AXI_Agent::type_id::create("axi_agt", this);
		sdram_agt = SDRAM_Agent::type_id::create("sdram_agt", this);
		axi_sd_scb = AXI_SDRAM_Scoreboard::type_id::create("axi_sd_scb", this);	
		axi_sd_cvg = AXI_SDRAM_Coverage::type_id::create("axi_sd_cvg", this);	
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axi_agt.axi_mon.item_collected_port.connect(axi_sd_scb.analysis_imp_a);
      sdram_agt.sdm_mon.item_collected_port.connect(axi_sd_scb.analysis_imp_b);
      axi_agt.axi_mon.item_collected_port.connect(axi_sd_cvg.analysis_imp_c);
      sdram_agt.sdm_mon.item_collected_port.connect(axi_sd_cvg.analysis_imp_d);
    endfunction
	
endclass : AXI2SDRAM_Environment
