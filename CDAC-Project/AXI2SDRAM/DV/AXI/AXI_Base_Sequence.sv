class AXI_base_Sequence extends uvm_sequence#(AXI_Packet);

	`uvm_object_utils(AXI_base_Sequence)

	AXI_Packet trans;

	//constructor
	function new(string name="AXI_base_Sequence");
		super.new(name);
		`uvm_info(get_full_name(),"-------------------------AXI_base_Sequence_build-------------------------------",UVM_NONE)
	endfunction : new

  task pre_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    phase = starting_phase;
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : AXI_base_Sequence