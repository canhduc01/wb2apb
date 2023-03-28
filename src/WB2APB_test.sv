//-------------------------------------------------------------------------
//            WB2APB_write_read_test - www.verificationguide.com 
//-------------------------------------------------------------------------
class WB2APB_test extends WB2APB_base_test;

  `uvm_component_utils(WB2APB_test)
  
  //---------------------------------------
  // itemuence instance 
  //--------------------------------------- 
  direct_sequence item;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "WB2APB_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the itemuence
    item = direct_sequence::type_id::create("seq");
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
      item.start(env.WB2APB_agnt.sequencer);
    phase.drop_objection(this);
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase
  
endclass : WB2APB_test