//-------------------------------------------------------------------------
//            WB2APB_sequencer - www.verificationguide.com
//-------------------------------------------------------------------------

class WB2APB_sequencer extends uvm_sequencer#(WB2APB_seq_item);

  `uvm_component_utils(WB2APB_sequencer) 

  //---------------------------------------
  //constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass