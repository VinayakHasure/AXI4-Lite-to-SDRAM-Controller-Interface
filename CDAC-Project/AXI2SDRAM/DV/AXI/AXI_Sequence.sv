
  // Sequence for Reset Test Sequence
class AXI_Reset_Sequence extends AXI_base_Sequence;

	`uvm_object_utils(AXI_Reset_Sequence)

	AXI_Packet trans;	

	//constructor
	function new(string name="AXI_Reset_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(1)
		   begin
			// `uvm_info(get_full_name(),"-------------------------AXI_Sequence_started-------------------------------",UVM_NONE)
			trans=AXI_Packet::type_id::create("trans");
			start_item(trans);
			// assert(trans.randomize());
			reset_test_sequence();
			// single_Read_sequence();
			`uvm_info(get_full_name(),"################################-AXI Generated Packet-############################",UVM_NONE)
			trans.print();
			finish_item(trans);
		end
	endtask : body

	virtual task reset_test_sequence();

		trans.ARESETn = 1'b0;			//active high reset

	endtask
 
endclass : AXI_Reset_Sequence


  // Sequence for Single Write Sequence
class AXI_Single_Write_Sequence extends AXI_base_Sequence;

	`uvm_object_utils(AXI_Single_Write_Sequence)

	AXI_Packet trans;	

	//constructor
	function new(string name="AXI_Single_Write_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(1)
		   begin
			// `uvm_info(get_full_name(),"-------------------------AXI_Sequence_started-------------------------------",UVM_NONE)
			trans=AXI_Packet::type_id::create("trans");
			start_item(trans);
			// assert(trans.randomize());
			//trans.ARESETn = 1'b0;
			Single_Write_sequence();
			// single_Read_sequence();
			`uvm_info(get_full_name(),"################################-AXI Generated Packet-############################",UVM_NONE)
			trans.print();
			finish_item(trans);
		end
	endtask : body

	virtual task Single_Write_sequence();

		trans.AWADDR = 'h001150aa;
		trans.AWVALID = 'b1;

		trans.WDATA = 'haa005511;
		trans.WVALID = 'b1;
		trans.WSTRB = 'hF;

	endtask
 
endclass : AXI_Single_Write_Sequence


   // Sequence for Read after Write Sequence
class AXI_Single_Read_after_Write_Sequence extends AXI_base_Sequence;

	`uvm_object_utils(AXI_Single_Read_after_Write_Sequence)

	AXI_Packet trans;

	integer i=0 ;

	//constructor
	function new(string name="AXI_Single_Read_after_Write_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(10)begin
			// `uvm_info(get_full_name(),"-------------------------AXI_Sequence_started-------------------------------",UVM_NONE)
			trans=AXI_Packet::type_id::create("trans");
			start_item(trans);
			// assert(trans.randomize());
			//trans.ARESETn = 1'b0;
			Single_Write_sequence();
			single_Read_sequence();
			`uvm_info(get_full_name(),"################################-AXI Generated Packet-############################",UVM_NONE)
			trans.print();
			finish_item(trans);
		end
	endtask : body

	virtual task Single_Write_sequence();

		trans.AWADDR = 'h001150aa+i;
		trans.AWVALID = 'b1;

		trans.WDATA = 'haa005511+i;
		trans.WVALID = 'b1;
		trans.WSTRB = 'hF;

	endtask

    virtual task single_Read_sequence();

		trans.ARADDR = 'h001150aa+i;
		trans.ARVALID = 'b1;

		// trans.RDATA = trans.WDATA;
		// trans.RVALID = 'b1;
		i=i+1;
	endtask
endclass : AXI_Single_Read_after_Write_Sequence


    // Sequence for Burst Write Sequence
class AXI_Burst_Write_Sequence extends AXI_base_Sequence;

	`uvm_object_utils(AXI_Burst_Write_Sequence)

	AXI_Packet trans;

	integer i=0 ;

	//constructor
	function new(string name="AXI_Burst_Write_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(100)begin
			// `uvm_info(get_full_name(),"-------------------------AXI_Sequence_started-------------------------------",UVM_NONE)
			trans=AXI_Packet::type_id::create("trans");
			start_item(trans);
			//trans.ARESETn = 1'b0;
			// assert(trans.randomize());
            Single_Write_sequence();
			//`uvm_info(get_full_name(),"################################-AXI Generated Packet-############################",UVM_NONE)
			//trans.print();
			finish_item(trans);
		end
	endtask : body

	virtual task Single_Write_sequence();

		trans.AWADDR = 'h001150aa+i*2;
		trans.AWVALID = 'b1;

		trans.WDATA = 'haa005511+i*3;
		trans.WVALID = 'b1;
		trans.WSTRB = 'hF;

        i=i+1;
	endtask

endclass : AXI_Burst_Write_Sequence


   // Sequence for Burst Read after Write Sequence
class AXI_Burst_Read_after_Write_Sequence extends AXI_base_Sequence;

	`uvm_object_utils(AXI_Burst_Read_after_Write_Sequence)

	AXI_Packet trans;

	integer i=0 ;
	int count=0;

	//constructor
	function new(string name="AXI_Burst_Read_after_Write_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

	virtual task body();
		repeat(300)begin
			// `uvm_info(get_full_name(),"-------------------------AXI_Sequence_started-------------------------------",UVM_NONE)
			trans=AXI_Packet::type_id::create("trans");
			start_item(trans);
			if(count<10)begin
				Single_Write_sequence();
				i++;
				count++;
			end
			else begin
				
				Single_Read_sequence();
				count++;
			end
			`uvm_info(get_full_name(),"################################-AXI Generated Packet-############################",UVM_NONE)
			//trans.print();
			finish_item(trans);
		end
	endtask : body

	virtual task Single_Write_sequence();

		trans.AWADDR = 'h001150aa+i*2;
		if(count < 'hA) begin
			trans.AWVALID = 'b1;
		end
		else begin
			trans.AWVALID = 'b0;
		end


		trans.WDATA = 'haa005511+i*3;
		trans.WVALID = 'b1;
		trans.WSTRB = 'hF;
   

	endtask

    virtual task Single_Read_sequence();

		trans.ARADDR = ('h001150aa+i*2)-20;
		trans.ARVALID = 'b1;

		trans.RREADY = 'b1;

		i=i+1;
	endtask
endclass : AXI_Burst_Read_after_Write_Sequence


