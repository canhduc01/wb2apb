//-------------------------------------------------------------------------
//            WB2APB_scoreboard - www.verificationguide.com 
//-------------------------------------------------------------------------

class WB2APB_scoreboard extends uvm_scoreboard;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  WB2APB_seq_item pkt_qu[$];
  
  //---------------------------------------
  // sc_WB2APB 
  //---------------------------------------
  bit [7:0] sc_WB2APB [4];

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(WB2APB_seq_item, WB2APB_scoreboard) item_collected_export;
  `uvm_component_utils(WB2APB_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local WB2APBory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
      foreach(sc_WB2APB[i]) sc_WB2APB[i] = 8'hFF;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(WB2APB_seq_item pkt);
    //pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - compare's the read data with the expected data(stored in local WB2APBory)
  // local WB2APBory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    WB2APB_seq_item WB2APB_pkt;
    
  endtask : run_phase
endclass : WB2APB_scoreboard