class SDRAM_Driver extends uvm_driver#(SDRAM_Packet);

    `uvm_component_utils(SDRAM_Driver)

	virtual SDRAM_Interface sdram_intf;

	SDRAM_Packet sdram_pkt;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-------------------------SDRAM_Driver_build-------------------------------",UVM_NONE)
		if(!uvm_config_db#(virtual SDRAM_Interface)::get(this, "", "s_vif", sdram_intf))
       		`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".s_vif"});
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
  		super.run_phase(phase);
    	forever begin
      		seq_item_port.get_next_item(sdram_pkt);
      		`uvm_info(get_full_name(),"-------------------------SDRAM_Driver_packet#####-------------------------------",UVM_NONE)
      		sdram_pkt.print();
      		drive_sdram();
      		`uvm_info(get_full_name(),"---------------------SDRAM_Packet_driven_on_interface#####----------------------------",UVM_NONE)
      		seq_item_port.item_done();
    	end
  	endtask : run_phase

   	virtual task drive_sdram();

        @(posedge sdram_intf.CLK);

 	   // Signal from TB to DUT

       sdram_intf.RAS  <= sdram_pkt.RAS;
	   sdram_intf.CAS  <= sdram_pkt.CAS ;
	   sdram_intf.WE   <= sdram_pkt.WE ;
	   sdram_intf.CS   <= sdram_pkt.CS ;
	   sdram_intf.A    <= sdram_pkt.A ;   
	   sdram_intf.BA   <= sdram_pkt.BA ;
	   sdram_intf.DQ   <= sdram_pkt.DQ ;
	   sdram_intf.DQM  <= sdram_pkt.DQM ;	

         `uvm_info(get_full_name(),"-------------------------Packet_sent-------------------------------",UVM_NONE)
    endtask
	
endclass : SDRAM_Driver
