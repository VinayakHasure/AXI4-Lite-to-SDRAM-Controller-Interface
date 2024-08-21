`timescale 1ns/1ps

`include "AXI_SDRAM_Pkg.sv"

module tb_top;
  
//clock and reset signal declaration
  bit ACLK;
  // bit ARESETn;
  bit CLK;
  bit CKE;
  // bit RESETn;

  wire  [15:0]  DQ_temp;

  //clock generation
  always #1 ACLK = ~ACLK;  // AXI Frequency = 500 Mhz
  always #3 CLK  = ~CLK;   // SD  Frequency = 166 Mhz
  
  //reset Generation
  initial 
  begin
      ACLK    = 0;
      CLK     = 0;
      CKE     = 0;
      axi_intf.ARESETn = 1'b0;
      #5 
      CKE     = 1;
      #10
      axi_intf.ARESETn = 1'b1;
  end

  AXI_Interface   axi_intf(ACLK);     //this clock needs to be changed

  SDRAM_Interface sdram_intf(CLK,CKE);


  AXI2SDRAM DUT(   
    .ACLK(ACLK),                           //Global Clock Signal
    .ARESETn(axi_intf.ARESETn), 
    .SDRAM_CLK(CLK),                         //global reset signal(active low)
    
//AXI Read Address channel signals
    // .ARLEN(axi_intf.ARLEN),
    // .ARID(axi_intf.ARID),
    .ARADDR(axi_intf.ARADDR),
    // .ARSIZE(axi_intf.ARSIZE),
    // .ARBURST(axi_intf.ARBURST),
    .ARVALID(axi_intf.ARVALID),
    .ARREADY(axi_intf.ARREADY),

//AXI Write Address channel signals
    // .AWID(axi_intf.AWID),
    .AWADDR(axi_intf.AWADDR),
    // .AWLEN(axi_intf.AWLEN),
    // .AWSIZE(axi_intf.AWSIZE),
    // .AWBURST(axi_intf.AWBURST),
    .AWVALID(axi_intf.AWVALID),
    .AWREADY(axi_intf.AWREADY),

//AXI Read data channel signals
    // .RID(axi_intf.RID),
    .RDATA(axi_intf.RDATA),
    .RRESP(axi_intf.RRESP),
    // .RLAST(axi_intf.RLAST),
    .RVALID(axi_intf.RVALID),
    .RREADY(axi_intf.RREADY),

//AXI Write data channel signals
    // .WID(axi_intf.WID),
    .WDATA(axi_intf.WDATA),
    .WSTRB(axi_intf.WSTRB),
    // .WLAST(axi_intf.WLAST),
    .WVALID(axi_intf.WVALID),
    .WREADY(axi_intf.WREADY),        

//AXI Write Response channel signals

    // .BID(axi_intf.BID),
    .BRESP(axi_intf.BRESP),
    .BVALID(axi_intf.BVALID),
    .BREADY(axi_intf.BREADY),

//sdram controller output Signals

    .sdram_clk_o(CLK),          //output clock to the sdram
    .sdram_cke_o(CKE),
    .sdram_cs_o(sdram_intf.CS),
    .sdram_cas_o(sdram_intf.CAS),
    .sdram_ras_o(sdram_intf.RAS),
    .sdram_we_o(sdram_intf.WE),
    .sdram_ba_o(sdram_intf.BA),           //two banks
    .sdram_a_o(sdram_intf.A),
    .sdram_dq_io(DQ_temp),          //bidirectional port
    .sdram_dqm_o(sdram_intf.DQM)           //data mask

  ) ;

  mt48lc16m16a2 SIM_Model(
       .Dq(DQ_temp), 
       .Addr(sdram_intf.A), 
       .Ba(sdram_intf.BA), 
       .Clk(CLK), 
       .Cke(CKE), 
       .Cs_n(sdram_intf.CS), 
       .Ras_n(sdram_intf.RAS), 
       .Cas_n(sdram_intf.CAS), 
       .We_n(sdram_intf.WE), 
       .Dqm(sdram_intf.DQM)
       );

assign sdram_intf.DQ = DQ_temp;

  //simulation model needs to integrate here


  initial begin 
  	uvm_config_db#(virtual   AXI_Interface)::set(uvm_root::get(),"uvm_test_top.env.axi_agt.axi_drv",  "a_vif",axi_intf);
  	uvm_config_db#(virtual   AXI_Interface)::set(uvm_root::get(),"uvm_test_top.env.axi_agt.axi_mon",  "a_vif",axi_intf);
    uvm_config_db#(virtual SDRAM_Interface)::set(uvm_root::get(),"uvm_test_top.env.sdram_agt.sdm_drv","s_vif",sdram_intf);
    uvm_config_db#(virtual SDRAM_Interface)::set(uvm_root::get(),"uvm_test_top.env.sdram_agt.sdm_mon","s_vif",sdram_intf);
     //run_test("AXI_Burst_Read_after_Write_Test");
    run_test("AXI_Single_Write_Test");
  end


  initial begin
  		$dumpfile("waveform.vcd");
  		$dumpvars(0, DUT,SIM_Model,axi_intf,sdram_intf);
  end

endmodule