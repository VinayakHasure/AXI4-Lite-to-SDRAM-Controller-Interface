`uvm_analysis_imp_decl(_port_c)
`uvm_analysis_imp_decl(_port_d)
class AXI_SDRAM_Coverage extends uvm_component;

	
	`uvm_component_utils(AXI_SDRAM_Coverage)

	uvm_analysis_imp_port_c #(AXI_Packet,AXI_SDRAM_Coverage) analysis_imp_c;  
	uvm_analysis_imp_port_d #(SDRAM_Packet,AXI_SDRAM_Coverage) analysis_imp_d; 

	AXI_Packet axi_tr;
	SDRAM_Packet sdram_tr;
    


	covergroup cg_AXI_SDRAM();
		option.comment="Coverage for axi2sdram controller";
		option.per_instance = 1;
          
          //AXI Signals
		 AWADDR : coverpoint (axi_tr.AWADDR);
		 AWVALID: coverpoint (axi_tr.AWVALID);
		 AWREADY: coverpoint (axi_tr.AWREADY);

		 WDATA  : coverpoint (axi_tr.WDATA);
		 WSTRB  : coverpoint (axi_tr.WSTRB);
		 WVALID : coverpoint (axi_tr.WVALID);
		 WREADY : coverpoint (axi_tr.WREADY);                                         

		 BRESP  : coverpoint (axi_tr.BRESP);
		 BVALID : coverpoint (axi_tr.BVALID);
		 BREADY : coverpoint (axi_tr.BREADY);


		 ARADDR : coverpoint (axi_tr.ARADDR); 
		 ARVALID: coverpoint (axi_tr.ARVALID);
		 ARREADY: coverpoint (axi_tr.ARREADY);

		 RDATA  : coverpoint (axi_tr.RDATA);
		 RRESP  : coverpoint (axi_tr.RRESP);
		 RVALID : coverpoint (axi_tr.RVALID);
		 RREADY : coverpoint (axi_tr.RREADY);


		 // SDRAM Signals
		 RAS    : coverpoint (sdram_tr.RAS); 
		 CAS    : coverpoint (sdram_tr.CAS);
		 WE     : coverpoint (sdram_tr.WE);
		 CS     : coverpoint (sdram_tr.CS);
		 A      : coverpoint (sdram_tr.A);
		 BA     : coverpoint (sdram_tr.BA);
         DQ     : coverpoint (sdram_tr.DQ);
         DQM    : coverpoint (sdram_tr.DQM);

	endgroup

	function new (string name="",uvm_component parent);
			super.new(name,parent);
			analysis_imp_c = new("analysis_imp_c", this);
    		analysis_imp_d = new("analysis_imp_d", this);
			cg_AXI_SDRAM=new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-----------------COVERAGE Bulid Phase---------------------",UVM_NONE)
	endfunction

  	virtual function void write_port_c(AXI_Packet axi_pkt);
    	//`uvm_info(get_type_name(),$sformatf(" Inside write_port_a method. Received axi_pkt On Analysis Imp Port#########################################################################################################"),UVM_LOW)
    	//`uvm_info(get_type_name(),$sformatf(" Printing axi_pkt, \n %s",axi_pkt.sprint()),UVM_LOW)
    	//axi_pkt.print();
		axi_tr = axi_pkt;
	 	// cg_AXI_SDRAM.sample();
  	endfunction
  

  	virtual function void write_port_d(SDRAM_Packet sdram_pkt);
    	// `uvm_info(get_type_name(),$sformatf(" Inside write_port_b method. Received sdram_pkt On Analysis Imp Port$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"),UVM_LOW)
    	// `uvm_info(get_type_name(),$sformatf(" Printing sdram_pkt, \n %s", sdram_pkt.sprint()),UVM_LOW)
    	// sdram_pkt.print();
		sdram_tr =sdram_pkt;
	 	cg_AXI_SDRAM.sample();
  	endfunction

	function void report_phase(uvm_phase phase);
		//`uvm_info(get_type_name(), $sformatf("Received AXI transaction: %s", axi_tr.sprint()), UVM_LOW)
	//	`uvm_info(get_type_name(), $sformatf("Received SDRAM transaction: %s", sdram_tr.sprint()), UVM_LOW)
     	`uvm_info(get_full_name(),$sformatf("Coverage is %0.2f %%", cg_AXI_SDRAM.get_coverage()),UVM_LOW);
     	// `uvm_info(get_full_name(),$sformatf("Coverage is %0.2f %%", ,UVM_LOW);
     	
     	//`uvm_report_coverage();
  	endfunction


endclass
