class AXI_Monitor extends uvm_monitor;

	`uvm_component_utils(AXI_Monitor)

    virtual AXI_Interface axi_intf;

    AXI_Packet axi_pkt;
    int count=0;
    uvm_analysis_port #(AXI_Packet) item_collected_port;

	function new (string name, uvm_component parent);
		super.new(name, parent);
		item_collected_port = new("item_collected_port", this);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		axi_pkt=new();
		`uvm_info(get_full_name(),"-------------------------AXI_Monitor_build-------------------------------",UVM_NONE)
		if(!uvm_config_db#(virtual AXI_Interface)::get(this, "", "a_vif", axi_intf))
       		`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".a_vif"});
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
    forever begin
          if(count<10)begin
            wait(axi_intf.AWVALID);
            capture_axi_write();
            // wait(axi_intf.ARVALID);
            capture_axi_read();
          end
          else if(count<20)begin
            wait(axi_intf.ARVALID);
            capture_axi_read();
            capture_axi_write();
          end
          else begin
            capture_axi_read();
            capture_axi_write();
          end
    		  //capture_axi_write();
          // wait(axi_intf.ARVALID);
      		//capture_axi_read();
          count++;
      		`uvm_info(get_full_name(),"-------------------------AXI_Monitor_data-------------------------------",UVM_NONE)
        	axi_pkt.print();
	  		item_collected_port.write(axi_pkt);
      	end 
  endtask : run_phase


   virtual task capture_axi_write();
      // wait(axi_intf.AWVALID);
          // IDLE State
       @(posedge axi_intf.ACLK);
         axi_pkt.AWADDR  = axi_intf.AWADDR ;
         axi_pkt.AWVALID = axi_intf.AWVALID;
         axi_pkt.WDATA   = axi_intf.WDATA;
         axi_pkt.WVALID  = axi_intf.WVALID ;
         axi_pkt.BREADY  = axi_intf.BREADY;

         // Address 
       @(posedge axi_intf.ACLK)
   
         axi_pkt.AWADDR   = axi_intf.AWADDR;
         axi_pkt.AWVALID  = axi_intf.AWVALID;
         axi_pkt.WDATA  = axi_intf.WDATA;
         axi_pkt.WVALID = axi_intf.WVALID;
         axi_pkt.BREADY = axi_intf.BREADY;

         // Data
       @(posedge axi_intf.ACLK)

         // axi_pkt.WDATA  = axi_intf.WDATA;
         // axi_pkt.WVALID = axi_intf.WVALID;
         // axi_pkt.BREADY = axi_intf.WVALID;

       @(posedge axi_intf.ACLK)

         // axi_pkt.AWADDR  = axi_intf.AWADDR;
         // axi_pkt.AWVALID = axi_intf.AWVALID;
         // axi_pkt.WDATA   = axi_intf.WDATA;
         // axi_pkt.WVALID  = axi_intf.WVALID;
         // axi_pkt.BREADY  = axi_intf.BREADY;

         `uvm_info(get_full_name(),"-------------------------Write_Packet_sampled-------------------------------",UVM_NONE)

   endtask


   virtual task capture_axi_read();

      // 
       @(posedge axi_intf.ACLK);
        axi_pkt.ARADDR  = axi_intf.ARADDR;
        axi_pkt.ARVALID = axi_intf.ARVALID;
        axi_pkt.RDATA   = axi_intf.RDATA ;
        axi_pkt.RVALID  = axi_intf.RVALID;

       @(posedge axi_intf.ACLK)

        axi_pkt.ARADDR  = axi_intf.ARADDR;
        axi_pkt.ARVALID = axi_intf.ARVALID;

       @(posedge axi_intf.ACLK)

        // axi_pkt.RDATA   = axi_intf.RDATA;
        // axi_pkt.RVALID  = axi_intf.RVALID;
        // axi_pkt.RRESP   = axi_intf.RRESP;

       @(posedge axi_intf.ACLK)
 
        // axi_pkt.ARADDR  = axi_intf.ARADDR;
        // axi_pkt.ARVALID = axi_intf.ARVALID;
        // axi_pkt.RDATA   = axi_intf.RDATA;
        // axi_pkt.RVALID  = axi_intf.RVALID;

        `uvm_info(get_full_name(),"-------------------------Read_Packet_sampled-------------------------------",UVM_NONE)

   endtask



endclass : AXI_Monitor