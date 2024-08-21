class AXI_Packet extends uvm_sequence_item;


   rand   bit ARESETn; 
   // Write address channel signals
   // rand   bit [3:0]   AWID;
   rand   bit [31:0]  AWADDR;
   // rand   bit [3:0]   AWLEN;
   // rand   bit [2:0]   AWSIZE;
   // rand   bit [1:0]   AWBURST;
   // rand   bit [1:0]   AWLOCK;
   // rand   bit [3:0]   AWCACHE; 
   // rand   bit [2:0]   AWPROT;
   rand   bit         AWVALID;
   rand   bit         AWREADY;

   // Write data channel signals
   // rand   bit [3:0]   WID;
   rand   bit [31:0]  WDATA;
   rand   bit [3:0]   WSTRB;
   // rand   bit         WLAST;
   rand   bit         WVALID;
   rand   bit         WREADY;

   // Write response channel signals
   // rand   bit [3:0]   BID;
   rand   bit [1:0]   BRESP;
   rand   bit         BVALID;
   rand   bit         BREADY;

   // Read address channel signals
   // rand   bit [3:0]   ARID;
   rand   bit [31:0]  ARADDR;
   // rand   bit [3:0]   ARLEN;
   // rand   bit [2:0]   ARSIZE;
   // rand   bit [1:0]   ARBURST;
   // rand   bit [1:0]   ARLOCK;
   // rand   bit [3:0]   ARCACHE; 
   // rand   bit [2:0]   ARPROT;
   rand   bit         ARVALID;
   rand   bit         ARREADY;

   // Read data channel signals
   // rand   bit [3:0]   RID;
   rand   bit [31:0]  RDATA;
   rand   bit [1:0]   RRESP;
   // rand   bit         RLAST;
   rand   bit         RVALID;
   rand   bit         RREADY;

   
	
	
   `uvm_object_utils_begin(AXI_Packet)

    `uvm_field_int(ARESETn, UVM_HEX)

      // Read address channel signals

	   // `uvm_field_int(ARID, UVM_HEX)
	   `uvm_field_int(ARADDR, UVM_HEX)
	   // `uvm_field_int(ARLEN, UVM_HEX)
	   // `uvm_field_int(ARSIZE, UVM_HEX)
     // `uvm_field_int(ARBURST, UVM_HEX)
     // `uvm_field_int(ARLOCK, UVM_HEX)
     // `uvm_field_int(ARCACHE, UVM_HEX)
     // `uvm_field_int(ARPROT, UVM_HEX)
     `uvm_field_int(ARVALID, UVM_HEX)
     `uvm_field_int(ARREADY, UVM_HEX)

   // Write address channel signals

     // `uvm_field_int(AWID, UVM_HEX)
     `uvm_field_int(AWADDR, UVM_HEX)
     // `uvm_field_int(AWLEN, UVM_HEX)
     // `uvm_field_int(AWSIZE, UVM_HEX)
     // `uvm_field_int(AWBURST, UVM_HEX)
     // `uvm_field_int(AWLOCK, UVM_HEX)
     // `uvm_field_int(AWCACHE, UVM_HEX)
     // `uvm_field_int(AWPROT, UVM_HEX)
     `uvm_field_int(AWVALID, UVM_HEX)
     `uvm_field_int(AWREADY, UVM_HEX)

   // Read data channel signals

     // `uvm_field_int(RID, UVM_HEX)
     `uvm_field_int(RDATA, UVM_HEX)
     `uvm_field_int(RRESP, UVM_HEX)
     // `uvm_field_int(RLAST, UVM_HEX)
     `uvm_field_int(RVALID, UVM_HEX)
     `uvm_field_int(RREADY, UVM_HEX)

   // Write data channel signals

     // `uvm_field_int(WID, UVM_HEX)
     `uvm_field_int(WDATA, UVM_HEX)
     `uvm_field_int(WSTRB, UVM_HEX)
     // `uvm_field_int(WLAST, UVM_HEX)
     `uvm_field_int(WVALID, UVM_HEX)
     `uvm_field_int(WREADY, UVM_HEX)

   // Write response channel signals

     // `uvm_field_int(BID, UVM_HEX)
     `uvm_field_int(BRESP, UVM_HEX)
     `uvm_field_int(BVALID, UVM_HEX)
     `uvm_field_int(BREADY, UVM_HEX)

	 `uvm_object_utils_end

   constraint AWADDR_C { AWADDR[31:24] == 8'h00;}
   constraint ARADDR_C { ARADDR[31:24] == 8'h00;}
   constraint AWADDR_C1 { AWADDR[0] == 0;      }
	
endclass : AXI_Packet