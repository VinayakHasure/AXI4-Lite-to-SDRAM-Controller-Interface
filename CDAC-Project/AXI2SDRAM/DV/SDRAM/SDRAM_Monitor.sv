class SDRAM_Monitor extends uvm_monitor;

	`uvm_component_utils(SDRAM_Monitor)

    virtual SDRAM_Interface sdram_intf;

    SDRAM_Packet sdram_pkt;
    int i=0;
    int count;

    uvm_analysis_port #(SDRAM_Packet) item_collected_port;

	function new (string name, uvm_component parent);
		super.new(name, parent);
		item_collected_port = new("item_collected_port", this);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sdram_pkt=new();
		`uvm_info(get_full_name(),"-------------------------SDRAM_Monitor_build-------------------------------",UVM_NONE)
		if(!uvm_config_db#(virtual SDRAM_Interface)::get(this, "", "s_vif", sdram_intf))
       		`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".s_vif"});
	endfunction : build_phase

	
	virtual task run_phase(uvm_phase phase);
    forever begin
    		i=0;
    		repeat(2) begin
    			wait(sdram_intf.RAS == 0);
    			capture_sdram();
    			count++;
    		end
    		if(count==13)begin
    			repeat(258)begin
    				@(posedge sdram_intf.CLK);
    			end
    		end
      		`uvm_info(get_full_name(),"-------------------------SDRAM_Monitor_data-------------------------------",UVM_NONE)
        	sdram_pkt.print();
	  		item_collected_port.write(sdram_pkt);
      	end 
  endtask : run_phase

    virtual task capture_sdram();

      @(posedge sdram_intf.CLK);						//Active Command
      sdram_pkt.RAS  			   	= sdram_intf.RAS;
	    sdram_pkt.CAS  		     	= sdram_intf.CAS;
	    sdram_pkt.WE   				 	= sdram_intf.WE;
	    sdram_pkt.CS   				 	= sdram_intf.CS;
	    sdram_pkt.ROW_Addr[i]	 	= sdram_intf.A;   
	    sdram_pkt.Bank_Addr		 	= sdram_intf.BA;
	    sdram_pkt.DQ_Data_H_L[i]= sdram_intf.DQ;
	    sdram_pkt.DQM  				 	= sdram_intf.DQM;
      @(posedge sdram_intf.CLK);						//wait state
      @(posedge sdram_intf.CLK);
      @(posedge sdram_intf.CLK);						//Write command
      sdram_pkt.DQ_Data_H_L[i]= sdram_intf.DQ;
      sdram_pkt.WE   				 	= sdram_intf.WE;
      sdram_pkt.COL_Addr[i]	 	= sdram_intf.A;
      sdram_pkt.CAS  				 	= sdram_intf.CAS;
      repeat(8) begin
      	@(posedge sdram_intf.CLK);
    	end
    	i=i+1;
	  endtask : capture_sdram

endclass : SDRAM_Monitor