//-------------------------------------------------------------------------
//            WB2APB_seq_item - www.verificationguide.com 
//-------------------------------------------------------------------------

class WB2APB_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  //WB input
  rand	logic [31:0] 	adr_wb;
  rand	logic [31:0] 	dat_i;
  rand	logic 	    	cyc_i;
  rand	logic [3:0]   sel_i; 
  rand	logic  			  stb_i;
  rand	logic			    we_i;
  rand	logic [2:0]	  cti_i;
  rand	logic [1:0]   bte_i;

  // // apb input
	logic  			  pready;
	logic [31:0] 	prdata;
	logic 			  pslerr;

	// adr_wb,
  	// dat_i,
	// cyc_i,
   	// sel_i, 
	// stb_i,
	// we_i,
   	// cti_i,
   	// bte_i,
	// pready,
	// prdata,
	// pslerr,

	// wb output
  logic  				ack_o;
  logic [31:0] 	dat_o;
  logic  				err_o;
  logic  				rty_o;

// apb output
  logic [31:0]	paddr;
  logic  				psel;
  logic  				penable;
  logic  				pwrite;
  logic [31:0] 	pwdata;
  logic [3:0] 	pstrb;


  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(WB2APB_seq_item)

    `uvm_field_int(adr_wb,    UVM_ALL_ON)
    `uvm_field_int(dat_i,     UVM_ALL_ON)
    `uvm_field_int(cyc_i,     UVM_ALL_ON)
    `uvm_field_int(sel_i,     UVM_ALL_ON)
    `uvm_field_int(stb_i,		  UVM_ALL_ON)
    `uvm_field_int(we_i,		  UVM_ALL_ON)
    `uvm_field_int(cti_i,		  UVM_ALL_ON)
    `uvm_field_int(bte_i,		  UVM_ALL_ON)

    // `uvm_field_int(pready,    UVM_ALL_ON)
    // `uvm_field_int(prdata,    UVM_ALL_ON)
    // `uvm_field_int(pslerr,    UVM_ALL_ON)

  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "WB2APB_seq_item");
    super.new(name);
  endfunction
  
  //---------------------------------------
  //constaint, to generate any one among write and read
  //---------------------------------------
// constraint c_close_keep_open { close != keep_open; }; 
//   constraint c_open_close { keep_open == 1 -> close == 0;
//                             close == 1 -> keep_open == 0; };
// constraint c_open_close { pready == 1 -> pslerr == 0;
//                             pslerr == 1 -> pready == 0; };


                            
endclass