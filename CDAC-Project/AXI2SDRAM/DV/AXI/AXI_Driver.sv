class AXI_Driver extends uvm_driver#(AXI_Packet);

    `uvm_component_utils(AXI_Driver)

	 virtual AXI_Interface axi_intf;

	 AXI_Packet axi_pkt;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(get_full_name(),"-------------------------AXI_Driver_build-------------------------------",UVM_NONE)
		if(!uvm_config_db#(virtual AXI_Interface)::get(this, "", "a_vif", axi_intf))
       		`uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".a_vif"});
    endfunction : build_phase



    virtual task run_phase(uvm_phase phase);
  		super.run_phase(phase);
  		drive_reset();
    	forever begin
      		seq_item_port.get_next_item(axi_pkt);
      		`uvm_info(get_full_name(),"-------------------------AXI_Driver_packet#####-------------------------------",UVM_NONE)
      		if(axi_pkt.AWVALID || axi_pkt.ARVALID) begin
            axi_pkt.print();
          end
      		// axi_intf.ARESETn <= axi_pkt.ARESETn;
      		// drive_axi_write_read();
      		drive_axi_write();
      		drive_axi_read();
      		//`uvm_info(get_full_name(),"---------------------AXI_Packet_driven_on_interface#####----------------------------",UVM_NONE)
      		seq_item_port.item_done();
    	end
  	endtask : run_phase


   virtual task drive_reset();
      
          // IDLE State
       @(posedge axi_intf.ACLK)
       wait(axi_intf.ARESETn);
         axi_intf.AWADDR  <= 0;
         axi_intf.AWVALID <= 0;
         axi_intf.WDATA   <= 0;
         axi_intf.WVALID  <= 0;
         axi_intf.WSTRB   <= 0;
         axi_intf.BREADY  <= 0;
         axi_intf.ARADDR  <= 0;
         axi_intf.ARVALID <= 0;
         axi_intf.RREADY  <= 0;

   endtask

   // virtual task drive_axi_write_read();
      
   //        // IDLE State
   //     @(posedge axi_intf.ACLK)

   //       axi_intf.AWADDR  <= 0;
   //       axi_intf.AWVALID <= 0;
   //       axi_intf.WDATA   <= 0;
   //       axi_intf.WVALID  <= 0;
   //       axi_intf.BREADY  <= 0;
   //       axi_intf.WSTRB		<= 0;

   //       axi_intf.ARADDR  <= 0;
	 //       axi_intf.ARVALID <= 0;
	// 			 axi_intf.RREADY  <= 0;

   //       // Address 
   //     @(posedge axi_intf.ACLK)
   
   //       axi_intf.AWADDR  <= axi_pkt.AWADDR;
   //       axi_intf.AWVALID <= axi_pkt.AWVALID;

   //       axi_intf.ARADDR  <= axi_pkt.ARADDR;
   //       axi_intf.ARVALID <= axi_pkt.ARVALID;

   //       axi_intf.RREADY  <= 1;

   //       // Data
   //     @(posedge axi_intf.ACLK)

   //       axi_intf.WDATA  <= axi_pkt.WDATA;
   //       axi_intf.WVALID <= axi_pkt.WVALID;
   //       axi_intf.WSTRB  <= axi_pkt.WSTRB;

   //       axi_intf.BREADY <= axi_pkt.WVALID;

         

   //     @(posedge axi_intf.ACLK)

   //       axi_intf.AWADDR  <= 0;
   //       axi_intf.AWVALID <= 0;
   //       axi_intf.WDATA   <= 0;
   //       axi_intf.WVALID  <= 0;
   //       axi_intf.BREADY  <= 0;
   //       axi_intf.WSTRB		<= 0;

   //       axi_intf.ARADDR  <= 0;
	 //       axi_intf.ARVALID <= 0;
	// 			 axi_intf.RREADY  <= 0;

   // endtask


   virtual task drive_axi_write();
      
          // IDLE State
       @(posedge axi_intf.ACLK)

         axi_intf.AWADDR  <= 0;
         axi_intf.AWVALID <= 0;
         axi_intf.WDATA   <= 0;
         axi_intf.WVALID  <= 0;
         axi_intf.BREADY  <= 0;
         axi_intf.RREADY  <= axi_pkt.RREADY;

         // Address 
       @(posedge axi_intf.ACLK)
        if(axi_pkt.AWVALID) begin
           axi_intf.AWADDR  <= axi_pkt.AWADDR;
           axi_intf.AWVALID <= axi_pkt.AWVALID;
        end
         // Data
       @(posedge axi_intf.ACLK)
        if(axi_pkt.WVALID) begin
           axi_intf.WDATA  <= axi_pkt.WDATA;
           axi_intf.WVALID <= axi_pkt.WVALID;
           axi_intf.WSTRB  <= axi_pkt.WSTRB;
           axi_intf.BREADY <= axi_pkt.WVALID;
        end
       @(posedge axi_intf.ACLK)

           axi_intf.AWADDR  <= 0;
           axi_intf.AWVALID <= 0;
           axi_intf.WDATA   <= 0;
           axi_intf.WVALID  <= 0;
           axi_intf.BREADY  <= 0;

   endtask


   virtual task drive_axi_read();
    
       @(posedge axi_intf.ACLK)
   
          axi_intf.ARADDR  <= 0;
          axi_intf.ARVALID <= 0;
          axi_intf.RDATA   <= 0;
          axi_intf.RVALID  <= 0;
          axi_intf.RREADY  <= axi_pkt.RREADY;
       @(posedge axi_intf.ACLK)
        if(axi_pkt.ARVALID) begin
          axi_intf.ARADDR  <= axi_pkt.ARADDR;
          axi_intf.ARVALID <= axi_pkt.ARVALID;
        end
       @(posedge axi_intf.ACLK)
        if(axi_pkt.RVALID && axi_pkt.RDATA) begin
          axi_intf.RREADY  <= axi_pkt.RREADY;
          axi_intf.RRESP   <= axi_pkt.RRESP;
        end
       @(posedge axi_intf.ACLK)
          axi_intf.ARADDR  <= 0;
          axi_intf.ARVALID <= 0;
          axi_intf.RDATA   <= 0;
          axi_intf.RVALID  <= 0;

   endtask

endclass : AXI_Driver

