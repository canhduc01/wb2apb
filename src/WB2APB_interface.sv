//-------------------------------------------------------------------------
//            mem_interface - www.verificationguide.com
//-------------------------------------------------------------------------

interface WB2APB_interface(
  input logic clk,
  input reset_n,
// apb input
  output logic  		    pready,
  output logic [31:0] 	prdata,
  output logic 		      pslerr,
// apb output
  input logic [31:0]	paddr,
  input logic  		    psel,
  input logic  		    penable,
  input logic  		    pwrite,
  input logic [31:0] 	pwdata,
  input logic [3:0] 	pstrb
  );
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------

  //WB input
  logic [31:0] 	adr_wb;
  logic [31:0] 	dat_i;
  logic 	    cyc_i;
  logic	[3:0]   sel_i; 
  logic  		stb_i;
  logic			we_i;
  logic [2:0]   cti_i;
  logic [1:0]   bte_i;
	// wb output
  logic  		ack_o;
  logic [31:0] 	dat_o;
  logic  		err_o;
  logic  		rty_o;

// // apb input
//   logic  		pready;
//   logic [31:0] 	prdata;
//   logic 		pslerr;

// // apb output
//   logic [31:0]	paddr;
//   logic  		psel;
//   logic  		penable;
//   logic  		pwrite;
//   logic [31:0] 	pwdata;
//   logic [3:0] 	pstrb;


  //---------------------------------------
  //driver clocking block
  //---------------------------------------
  clocking driver_cb @(posedge clk);
    default input #1 output #1;

  output	adr_wb;
 	output	dat_i;
	output	cyc_i;
	output	sel_i; 
	output	stb_i;
	output	we_i;
	output	cti_i;
	output	bte_i;

	input	ack_o;
 	input	dat_o;
	input	err_o;
  input	rty_o;
  
	output	pready;
 	output	prdata;
	output	pslerr;

  input	paddr;
  input	psel;
  input	penable;
  input	pwrite;
  input	pwdata;
  input	pstrb;

  endclocking
  
  //---------------------------------------
  //monitor clocking block
  //---------------------------------------
  clocking monitor_cb @(posedge clk);
  default input #1 output #1;
  input	adr_wb;
 	input	dat_i;
	input	cyc_i;
	input	sel_i; 
	input	stb_i;
	input	we_i;
	input	cti_i;
	input	bte_i;

	input	ack_o;
 	input	dat_o;
	input	err_o;
  input	rty_o;
  
	input	pready;
 	input	prdata;
	input	pslerr;

  input	paddr;
  input	psel;
  input	penable;
  input	pwrite;
  input	pwdata;
  input	pstrb;
  endclocking
  
  //---------------------------------------
  //driver modport
  //---------------------------------------
  modport DRIVER  (clocking driver_cb,input clk,reset_n);
  
  //---------------------------------------
  //monitor modport  
  //---------------------------------------
  modport MONITOR (clocking monitor_cb,input clk,reset_n);
  
endinterface