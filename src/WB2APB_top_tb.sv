//-------------------------------------------------------------------------
//        www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interfcae and testcase files
// `include "uvm.sv"
// `include "uvm_macros.svh"
// import  uvm_pkg::*;
// `include "WB2APB_interface.sv"
// `include "WB2APB_base_test.sv"
// `include "WB2APB_wr_rd_test.sv"
`include "include.svh"
//---------------------------------------------------------------

module WB2APB_top_tb;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------


module apb_slave ( clk, rstn,paddr, psel,penable, pwrite , pwdata,pstrb, pready,prdata,pslverr); 

input clk,rstn,psel,penable, pwrite; 
input [31:0] paddr; 
input [31:0] pwdata; 
input [3:0] pstrb; 
output pready,pslverr;
output [31:0] prdata; 
logic lpready,lpslverr;
logic [31:0] lprdata; 

logic [31:0] mem [*]; 

always @ (posedge clk)
begin 
    if (rstn == 1'b0)
       begin 
        lpready = 1'b0;
	      lprdata = 31'b0; 
        lpslverr = 1'b0; 
       end 
    else if ((psel == 1) && (penable == 1'b1)) 
    begin 
         lpready = 1'b1; 
         if (pwrite == 1'b1) // write cycle
	 begin 
	   mem[paddr] = pwdata;
    end 
	 else  // read cycle 
	 begin 
	    lprdata = mem[paddr]; 
         end 
    end 	 
    else 
    begin 
	    lpready =1'b0; 
	    lprdata = 31'b0;
    end 	    
end 

assign pready = lpready; 
assign pslverr = lpslverr; 
assign prdata = lprdata; 

endmodule 


  bit clk;
  bit reset_n;

  // apb input
  logic  		    pready;
  logic [31:0] 	prdata;
  logic 		    pslerr;

// apb output
  logic [31:0]	paddr;
  logic  		    psel;
  logic  		    penable;
  logic  		    pwrite;
  logic [31:0] 	pwdata;
  logic [3:0] 	pstrb;

  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    clk = 0;
    reset_n = 1;
    #5 reset_n = 0;
    #5 reset_n = 1;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  apb_slave apb(
  //clk, rstn,paddr, psel,penable
  //pwrite , pwdata,pstrb, pready,prdata,pslverr
  .clk(clk),
	.rstn(reset_n),
	.pready(pready),
	.prdata(prdata),
	.pslverr(pslerr),
	.paddr(paddr),
	.psel(psel),
	.penable(penable),
	.pwrite(pwrite),
	.pwdata(pwdata),
	.pstrb(pstrb)
  ); 

  WB2APB_interface intf(
  .clk(clk),
  .reset_n(reset_n),
  .pready(pready),
  .pslerr(pslerr),
  .paddr(paddr),
  .psel(psel),
  .penable(penable),
  .pwrite(pwrite),
  .pwdata(pwrite),
  .pstrb(pstrb)
  );
  
  //---------------------------------------
  //DUT instance
  //---------------------------------------

WB_to_APB DUT
	(
	// connect wishbone signal
	.clk_i(clk),
	.rst_i(reset_n),
	.adr_i(intf.adr_wb),
	.dat_i(intf.dat_i),
	.cyc_i(intf.cyc_i),
	.sel_i(intf.sel_i),
	.stb_i(intf.stb_i),
	.we_i(intf.we_i),
	.cti_i(intf.cti_i),
	.bte_i(intf.bte_i),
	.ack_o(intf.ack_o),
	.dat_o(intf.dat_o),
	.err_o(intf.err_o),
	.rty_o(intf.rty_o),
	
	// connect apb signal
	.pclk(clk),
	.preset_n(reset_n),
	.pready(pready),
	.prdata(prdata),
	.pslverr(pslerr),
	.paddr(paddr),
	.psel(psel),
	.penable(penable),
	.pwrite(pwrite),
	.pwdata(pwdata),
	.pstrb(pstrb)
	);



  // WB2APB_sva WB2APB_sva(intf);


  // ---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual WB2APB_interface)::set(uvm_root::get(),"*","vif",intf);// get() lay tin hieu tu driver sau do set() se gui vao interface 
    //enable wave dump
    $dumpfile("dump.vcd"); // in ra file wave 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test();
  end
  
endmodule