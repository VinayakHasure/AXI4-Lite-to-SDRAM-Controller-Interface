class SDRAM_Packet extends uvm_sequence_item;

     bit         RAS;
     bit         CAS;
     bit         CS;
     bit         WE;
     bit [12:0]  A;   // needs to be change
     bit [1:0 ]  BA;
     bit [1:0]   DQM;
     bit [15:0]  DQ;
     bit [1:0][12:0]  ROW_Addr;
     bit [1:0][8:0]  COL_Addr;
     bit [1:0][15:0]  DQ_Data_H_L;


     bit [1:0]   Bank_Addr;

    `uvm_object_utils_begin(SDRAM_Packet)

    // SDRAM Signals

     `uvm_field_int(RAS, UVM_HEX)
     `uvm_field_int(CAS, UVM_HEX)
     `uvm_field_int(CS, UVM_HEX)
     `uvm_field_int(WE, UVM_HEX)
     `uvm_field_int(A, UVM_HEX)
     `uvm_field_int(BA, UVM_HEX)
     `uvm_field_int(DQ, UVM_HEX)
     `uvm_field_int(DQM, UVM_HEX)
     `uvm_field_int(ROW_Addr, UVM_HEX)
     `uvm_field_int(COL_Addr, UVM_HEX)
     `uvm_field_int(Bank_Addr, UVM_HEX)
     `uvm_field_int(DQ_Data_H_L, UVM_HEX)

	`uvm_object_utils_end
	
endclass : SDRAM_Packet