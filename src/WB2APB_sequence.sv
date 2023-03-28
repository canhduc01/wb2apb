//-------------------------------------------------------------------------
//            WB2APB_sequence's - www.verificationguide.com
//-------------------------------------------------------------------------

//=========================================================================
// WB2APB_sequence - random stimulus 
//=========================================================================
typedef class WB2APB_sequencer;
class WB2APB_sequence extends uvm_sequence#(WB2APB_seq_item);
  WB2APB_seq_item item;
  
  `uvm_object_utils(WB2APB_sequence)
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "WB2APB_sequence");
    super.new(name);
  endfunction
  `uvm_declare_p_sequencer(WB2APB_sequencer)
  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
   repeat(20) begin
    item = WB2APB_seq_item::type_id::create("req");
    wait_for_grant();
    item.randomize();
    send_request(item);
    wait_for_item_done();
   end 
  endtask
endclass

class single_read_sequence extends uvm_sequence#(WB2APB_seq_item);
  
  WB2APB_seq_item item;
  //--------------------------------------- 
  //Declaring sequences
  //---------------------------------------
  `uvm_object_utils(single_read_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "single_read_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
  
    item = WB2APB_seq_item::type_id::create("req");
    `uvm_do_with(item,{ item.adr_wb==8'h12432322;
                        item.dat_i==8'h00000000;
                        item.cyc_i==1;
                        item.sel_i==4'b0001; 
                        item.stb_i==0;
                        item.we_i==1;
                        item.cti_i==3'b000;
                        item.bte_i==2'b00;
                        });
    `uvm_do_with(item,{ item.adr_wb==8'h00000000;
                        item.dat_i==8'h00000000;
                        item.cyc_i==1;
                        item.sel_i==4'b0001; 
                        item.stb_i==0;
                        item.we_i==1;
                        item.cti_i==3'b000;
                        item.bte_i==2'b00;
                        });

  endtask
endclass
//=========================================================================


class direct_sequence extends uvm_sequence#(WB2APB_seq_item);
  
  WB2APB_seq_item item;
  //--------------------------------------- 
  //Declaring sequences
  //---------------------------------------
  `uvm_object_utils(direct_sequence)
   
  //--------------------------------------- 
  //Constructor
  //---------------------------------------
  function new(string name = "direct_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
  
    item = WB2APB_seq_item::type_id::create("req");
    `uvm_do_with(item,{ item.adr_wb==8'h12432322;
                        item.dat_i==8'h00000000;
                        item.cyc_i==1;
                        item.sel_i==4'b0001; 
                        item.stb_i==0;
                        item.we_i==1;
                        item.cti_i==3'b000;
                        item.bte_i==2'b00;
                        });
    `uvm_do_with(item,{ item.adr_wb==8'h00000000;
                        item.dat_i==8'h00000000;
                        item.cyc_i==1;
                        item.sel_i==4'b0001; 
                        item.stb_i==0;
                        item.we_i==1;
                        item.cti_i==3'b000;
                        item.bte_i==2'b00;
                        });

  endtask
endclass
//=========================================================================