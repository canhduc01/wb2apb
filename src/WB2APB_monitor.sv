//-------------------------------------------------------------------------
//            WB2APB_monitor - www.verificationguide.com 
//-------------------------------------------------------------------------

class WB2APB_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual WB2APB_interface vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(WB2APB_seq_item) item_collected_port;
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  WB2APB_seq_item trans_collected;

  `uvm_component_utils(WB2APB_monitor)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual WB2APB_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    // forever begin
    //   @(posedge vif.clk);
    //   wait(vif.monitor_cb.wr_en || vif.monitor_cb.rd_en);
    //     trans_collected.addr = vif.monitor_cb.addr;
    //   if(vif.monitor_cb.wr_en) begin
    //     trans_collected.wr_en = vif.monitor_cb.wr_en;
    //     trans_collected.wdata = vif.monitor_cb.wdata;
    //     trans_collected.rd_en = 0;
    //     @(posedge vif.clk);
    //   end
    //   if(vif.monitor_cb.rd_en) begin
    //     trans_collected.rd_en = vif.monitor_cb.rd_en;
    //     trans_collected.wr_en = 0;
    //     @(posedge vif.clk);
    //     @(posedge vif.clk);
    //     trans_collected.rdata = vif.monitor_cb.rdata;
    //   end
    // item_collected_port.write(trans_collected);
    //   end 
  endtask : run_phase

endclass : WB2APB_monitor
