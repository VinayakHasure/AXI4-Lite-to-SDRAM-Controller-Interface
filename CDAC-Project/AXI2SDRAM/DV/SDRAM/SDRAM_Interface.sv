interface SDRAM_Interface (input CLK, input CKE);
	 // SDRAM Signals
	 logic          RAS;
	 logic          CAS;
	 logic          WE;
	 logic 			CS;
	 logic  [12:0]  A;   // needs to be change
	 logic  [1:0 ]  BA;
	 logic  [15:0]  DQ;
	 logic  [1:0 ]  DQM;	
 
endinterface : SDRAM_Interface
