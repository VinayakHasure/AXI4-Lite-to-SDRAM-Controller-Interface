interface AXI_Interface (input ACLK);

 
   logic ARESETn;
   // Write address channel signals
   //logic   [3:0]   AWID;
   logic   [31:0]  AWADDR;
   // logic   [3:0]   AWLEN;
   // logic   [2:0]   AWSIZE;
   // logic   [1:0]   AWBURST;
   // logic   [1:0]   AWLOCK;
   // logic   [3:0]   AWCACHE; 
   // logic   [2:0]   AWPROT;
   //logic           AWQOS;
   //logic           AWREGION;
   //logic           AWUSER;
   logic           AWVALID;
   logic           AWREADY;

   // Write data channel signals
   // logic   [3:0]   WID;
   logic   [31:0]  WDATA;
   logic   [3:0]   WSTRB;
   // logic           WLAST;
   //logic           WUSER;
   logic           WVALID;
   logic           WREADY;

   // Write response channel signals
   // logic   [3:0]   BID;
   logic   [1:0]   BRESP;
   //logic           BUSER;
   logic           BVALID;
   logic           BREADY;

   // Read address channel signals
   //logic   [3:0]   ARID;
   logic   [31:0]  ARADDR;
   //logic   [3:0]   ARLEN;
   //logic   [2:0]   ARSIZE;
   //logic   [1:0]   ARBURST;
   //logic   [1:0]   ARLOCK;
   // logic   [3:0]   ARCACHE; 
   // logic   [2:0]   ARPROT;
   //logic           ARQOS;
   //logic           ARREGION;
   //logic           ARUSER;
   logic           ARVALID;
   logic           ARREADY;

   // Read data channel signals
   //logic   [3:0]   RID;
   logic   [31:0]  RDATA;
   logic   [1:0]   RRESP;
   //logic           RLAST;
   //logic           RUSER;
   logic           RVALID;
   logic           RREADY;


endinterface : AXI_Interface
