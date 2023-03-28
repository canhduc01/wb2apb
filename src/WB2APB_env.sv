//-------------------------------------------------------------------------
//            WB2APB_env - www.verificationguide.com
//-------------------------------------------------------------------------

class WB2APB_model_env extends uvm_env;
  
  //---------------------------------------
  // agent and scoreboard instance
  //---------------------------------------
  WB2APB_agent      WB2APB_agnt;
  WB2APB_scoreboard WB2APB_scb;
  
  `uvm_component_utils(WB2APB_model_env)
  
  //--------------------------------------- 
  // constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // build_phase - crate the components
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    WB2APB_agnt = WB2APB_agent::type_id::create("WB2APB_agnt", this);
    WB2APB_scb  = WB2APB_scoreboard::type_id::create("WB2APB_scb", this);
  endfunction : build_phase
  
  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    WB2APB_agnt.monitor.item_collected_port.connect(WB2APB_scb.item_collected_export);
  endfunction : connect_phase

endclass : WB2APB_model_env