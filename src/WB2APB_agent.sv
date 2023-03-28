//-------------------------------------------------------------------------
//            WB2APB_agent - www.verificationguide.com 
//-------------------------------------------------------------------------

class WB2APB_agent extends uvm_agent;

  //---------------------------------------
  // component instances
  //---------------------------------------
  WB2APB_driver    driver;
  WB2APB_sequencer sequencer;
  WB2APB_monitor   monitor;

  `uvm_component_utils(WB2APB_agent)
  
  //---------------------------------------
  // constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = WB2APB_monitor::type_id::create("monitor", this);

    //creating driver and sequencer only for ACTIVE agent
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = WB2APB_driver::type_id::create("driver", this);
      sequencer = WB2APB_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase
  
  //---------------------------------------  
  // connect_phase - connecting the driver and sequencer port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : WB2APB_agent