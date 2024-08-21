// Test for Single Write
class AXI_Reset_Test extends uvm_test;

  `uvm_component_utils(AXI_Reset_Test)

  AXI2SDRAM_Environment env;
  AXI_Reset_Sequence axi_seq;

  function new(string name = "AXI_Reset_Test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_build-------------------------------",UVM_NONE)
    env = AXI2SDRAM_Environment::type_id::create("env", this);
    axi_seq = AXI_Reset_Sequence::type_id::create("axi_seq",this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_run_phase-------------------------------",UVM_NONE)
      axi_seq.start(env.axi_agt.axi_seq);
    phase.drop_objection(this);
  endtask : run_phase


endclass : AXI_Reset_Test


 // Test for Single Write
class AXI_Single_Write_Test extends uvm_test;

  `uvm_component_utils(AXI_Single_Write_Test)

  AXI2SDRAM_Environment env;
  AXI_Single_Write_Sequence axi_seq;

  function new(string name = "AXI_Single_Write_Test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_build-------------------------------",UVM_NONE)
    env = AXI2SDRAM_Environment::type_id::create("env", this);
    axi_seq = AXI_Single_Write_Sequence::type_id::create("axi_seq",this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_run_phase-------------------------------",UVM_NONE)
      axi_seq.start(env.axi_agt.axi_seq);
    phase.drop_objection(this);
  endtask : run_phase


endclass : AXI_Single_Write_Test


 // Test for Single Read after write test
class AXI_Single_Read_after_Write_Test extends uvm_test;

  `uvm_component_utils(AXI_Single_Read_after_Write_Test)

  AXI2SDRAM_Environment env;
  AXI_Single_Read_after_Write_Sequence axi_seq;

  function new(string name = "AXI_Single_Read_after_Write_Test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_build-------------------------------",UVM_NONE)
    env = AXI2SDRAM_Environment::type_id::create("env", this);
    axi_seq =AXI_Single_Read_after_Write_Sequence::type_id::create("axi_seq",this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_run_phase-------------------------------",UVM_NONE)
      axi_seq.start(env.axi_agt.axi_seq);
    phase.drop_objection(this);
  endtask : run_phase


endclass : AXI_Single_Read_after_Write_Test


 // Test for Single burst write test
class AXI_Burst_Write_Test extends uvm_test;

  `uvm_component_utils(AXI_Burst_Write_Test)

  AXI2SDRAM_Environment env;
  AXI_Burst_Write_Sequence axi_seq;

  function new(string name = "AXI_Burst_Write_Test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_build-------------------------------",UVM_NONE)
    env = AXI2SDRAM_Environment::type_id::create("env", this);
    axi_seq =AXI_Burst_Write_Sequence::type_id::create("axi_seq",this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_run_phase-------------------------------",UVM_NONE)
      axi_seq.start(env.axi_agt.axi_seq);
    phase.drop_objection(this);
  endtask : run_phase


endclass : AXI_Burst_Write_Test


 // Test for Burst Read after write Test 
class AXI_Burst_Read_after_Write_Test extends uvm_test;

  `uvm_component_utils(AXI_Burst_Read_after_Write_Test)

  AXI2SDRAM_Environment env;
  AXI_Burst_Read_after_Write_Sequence axi_seq;

  function new(string name = "AXI_Burst_Read_after_Write_Test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_build-------------------------------",UVM_NONE)
    env = AXI2SDRAM_Environment::type_id::create("env", this);
    axi_seq =AXI_Burst_Read_after_Write_Sequence::type_id::create("axi_seq",this);
  endfunction : build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info(get_full_name(),"-------------------------AXI_SDRAM_Test_run_phase-------------------------------",UVM_NONE)
      axi_seq.start(env.axi_agt.axi_seq);
    phase.drop_objection(this);
  endtask : run_phase


endclass : AXI_Burst_Read_after_Write_Test



