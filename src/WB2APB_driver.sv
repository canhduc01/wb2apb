//-------------------------------------------------------------------------
//            WB2APB_driver - www.verificationguide.com
//-------------------------------------------------------------------------

`define DRIV_IF vif.driver_cb

class WB2APB_driver extends uvm_driver #(WB2APB_seq_item);

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual WB2APB_interface vif;
  `uvm_component_utils(WB2APB_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual WB2APB_interface)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    WB2APB_seq_item item;
    forever begin
      seq_item_port.get_next_item(item);
      drive(item);
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive(WB2APB_seq_item item);// tư xây dựng 
    
// driver nhận được là các data chưa rõ input or output 
    @(negedge vif.clk);
    // sườn âm 
    vif.driver_cb.sel_i <= item.sel_i;
    vif.driver_cb.dat_i <= item.dat_i;
    vif.driver_cb.cyc_i <= item.cyc_i;
    vif.driver_cb.sel_i <= item.sel_i;
    vif.driver_cb.stb_i <= item.stb_i;
    vif.driver_cb.we_i  <= item.we_i;
    vif.driver_cb.cti_i <= item.cti_i;
	  vif.driver_cb.adr_wb <= item.adr_wb;
    vif.driver_cb.bte_i  <= item.bte_i;

    // vif.driver_cb.pready <= item.pready;
    // vif.driver_cb.prdata <= item.prdata;
    // vif.driver_cb.pslerr <= item.pslerr;
  endtask : drive
endclass : WB2APB_driver