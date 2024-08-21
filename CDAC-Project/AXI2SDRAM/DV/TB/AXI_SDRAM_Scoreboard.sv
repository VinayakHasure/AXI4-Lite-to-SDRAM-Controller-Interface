
`uvm_analysis_imp_decl(_port_a)
`uvm_analysis_imp_decl(_port_b)
class AXI_SDRAM_Scoreboard extends uvm_component;

	AXI_Packet axi_pkt;
	SDRAM_Packet sdram_pkt;

	bit [31:0] AWADDR[$];
	bit [31:0] ARADDR[$];
	bit [31:0] WDATA[$];
	bit [31:0] RDATA[$];
	bit [23:0] SD_RD_ADDR[$];
	bit [23:0] SD_WR_ADDR[$];
	bit [31:0] SD_WDATA[$];
	bit [31:0] SD_RDATA[$];

	int i=0;
	int count=0,count1=0;
	`uvm_component_utils(AXI_SDRAM_Scoreboard)
	uvm_analysis_imp_port_a #(AXI_Packet,AXI_SDRAM_Scoreboard) analysis_imp_a;  
	uvm_analysis_imp_port_b #(SDRAM_Packet,AXI_SDRAM_Scoreboard) analysis_imp_b;

	function void print_store();
		$display("================================================");
		$display("AWADDR=%0h",AWADDR.pop_front());
		$display("ARADDR=%0h",ARADDR.pop_front());
		$display("WDATA=%0h",WDATA.pop_front());
		$display("RDATA=%0h",RDATA.pop_front());
		$display("SD_RD_ADDR=%0h",SD_RD_ADDR.pop_front());
		$display("SD_WR_ADDR=%0h",SD_WR_ADDR.pop_front());
		$display("SD_WDATA=%0h",SD_WDATA.pop_front());
		$display("SD_RDATA=%0h",SD_RDATA.pop_front());
		$display("================================================");
	endfunction 

	function new (string name="",uvm_component parent);
		super.new(name,parent);
		analysis_imp_a = new("analysis_imp_a", this);
    	analysis_imp_b = new("analysis_imp_b", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		 `uvm_info(get_full_name(),"-----------------SCOREBOARD Bulid Phase---------------------",UVM_NONE)
	endfunction 

  	virtual function void write_port_a(AXI_Packet axi_pkt);
    	`uvm_info(get_type_name(),$sformatf(" Inside write_port_a method. Received axi_pkt On Analysis Imp Port#########################################################################################################"),UVM_LOW)
    	`uvm_info(get_type_name(),$sformatf(" Printing inside scoreboard axi_pkt, \n %s",axi_pkt.sprint()),UVM_LOW)
    	if(axi_pkt.AWVALID) begin
    		AWADDR.push_back(axi_pkt.AWADDR);
    	end
    	if(axi_pkt.ARVALID) begin
			ARADDR.push_back(axi_pkt.ARADDR);
		end
		if(axi_pkt.WVALID) begin
			WDATA.push_back(axi_pkt.WDATA);
		end
		if(axi_pkt.RVALID) begin
			RDATA.push_back(axi_pkt.RDATA);
		end

		//print_store();
  	endfunction
  

  	virtual function void write_port_b(SDRAM_Packet sdram_pkt);
    	`uvm_info(get_type_name(),$sformatf(" Inside write_port_b method. Received sdram_pkt On Analysis Imp Port$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"),UVM_LOW)
    	`uvm_info(get_type_name(),$sformatf(" Printing inside scoreboard sdram_pkt, \n %s", sdram_pkt.sprint()),UVM_LOW)
    	if(sdram_pkt.WE) begin
    		SD_RD_ADDR.push_back({sdram_pkt.Bank_Addr[0],sdram_pkt.ROW_Addr[0],sdram_pkt.COL_Addr[0]});
    		SD_RDATA.push_back(sdram_pkt.DQ_Data_H_L);
    	end
    	if(!sdram_pkt.WE) begin
			SD_WR_ADDR.push_back({sdram_pkt.Bank_Addr[0],sdram_pkt.ROW_Addr[0],sdram_pkt.COL_Addr[0]});
			SD_WDATA.push_back(sdram_pkt.DQ_Data_H_L);
		end
		
		//print_store();
		compare_packet();
  	endfunction

  	function void compare_packet();
  		if(i==0)begin
  			$display("CHANDRAKANT");
  			$display("SD_RD_ADDR=%0h",SD_RD_ADDR.pop_front());
			$display("SD_WR_ADDR=%0h",SD_WR_ADDR.pop_front());
			$display("SD_WDATA=%0h",SD_WDATA.pop_front());
			$display("SD_RDATA=%0h",SD_RDATA.pop_front());
  			i++;
  		end
  		else begin
	  		$display("================================================");
			$display("AWADDR=%0h",AWADDR.pop_front());
			$display("ARADDR=%0h",ARADDR.pop_front());
			$display("WDATA=%0h",WDATA.pop_front());
			$display("RDATA=%0h",RDATA.pop_front());
			$display("SD_RD_ADDR=%0h",SD_RD_ADDR.pop_front());
			$display("SD_WR_ADDR=%0h",SD_WR_ADDR.pop_front());
			$display("SD_WDATA=%0h",SD_WDATA.pop_front());
			$display("SD_RDATA=%0h",SD_RDATA.pop_front());
			$display("================================================");
			// if((AWADDR.pop_front()) == (SD_WR_ADDR.pop_front()))begin

			// 	if((ARADDR.pop_front()) == (SD_RD_ADDR.pop_front()))begin

			// 		if((WDATA.pop_front()) == (SD_WDATA.pop_front()))begin

			// 			if((RDATA.pop_front()) == (SD_RDATA.pop_front()))begin
			// 				count++;
			// 				`uvm_info(get_type_name(),$sformatf("DATA %d MATCHED SUCCESSFULLY!!!",count),UVM_LOW);
			// 			end

			// 		end

			// 	end

			// end
		end
		count1++;	
			
			if(count1>9) begin
			if(count==8) begin
				$write("%c[1;32m",27);
				$display(".########.########..######..########....########.....###.....######...######."); 
				$display("....##....##.......##....##....##.......##.....##...##.##...##....##.##....##"); 
				$display("....##....##.......##..........##.......##.....##..##...##..##.......##......"); 
				$display("....##....######....######.....##.......########..##.....##..######...######."); 
				$display("....##....##.............##....##.......##........#########.......##.......##"); 
				$display("....##....##.......##....##....##.......##........##.....##.##....##.##....##"); 
				$display("....##....########..######.....##.......##........##.....##..######...######.");  
				$write("%c[0m",27);	
			end
			else begin
				$write("%c[1;31m",27);
				$display(".########.########..######..########....########....###....####.##......"); 
				$display("....##....##.......##....##....##.......##.........##.##....##..##......"); 
				$display("....##....##.......##..........##.......##........##...##...##..##......"); 
				$display("....##....######....######.....##.......######...##.....##..##..##......"); 
				$display("....##....##.............##....##.......##.......#########..##..##......"); 
				$display("....##....##.......##....##....##.......##.......##.....##..##..##......"); 
				$display("....##....########..######.....##.......##.......##.....##.####.########"); 
				$write("%c[0m",27);
			end
		end
		
  	endfunction

endclass : AXI_SDRAM_Scoreboard

