`timescale 1ns/1ns
module tb_WBtoAPB();
	// Call all paramter, constant
	// Wishbone
	parameter WB_ADDR_WIDTH = 32;
	parameter WB_DATA_WIDTH = 32;
	parameter WB_SEL_WIDTH  = 4;
	parameter WB_CTI_WIDTH  = 3;
	parameter WB_BTE_WIDTH  = 2;
	// APB
	parameter APB_ADDR_WIDTH = 32;
	parameter APB_SEL_WIDTH  = 4;
	parameter APB_DATA_WIDTH = 32;
	parameter APB_STRB_WIDTH = 4;
	
	// Declare transaction with DUT
	reg                      clk;
	reg                      rstn;
    // WishBone Slave declare
	
	reg [WB_ADDR_WIDTH : 0]   adr_i;
	reg [WB_DATA_WIDTH : 0]   dat_i;
	reg                       cyc_i;
	reg [WB_SEL_WIDTH  : 0]   sel_i;
	reg                       stb_i;
	reg                       we_i;
	reg [WB_CTI_WIDTH : 0]    cti_i;
	reg [WB_BTE_WIDTH : 0]    bte_i;
	
	wire                      ack_o;
	wire [WB_DATA_WIDTH : 0]  dat_o;
	wire                      err_o;
	wire                      rty_o;
	
	// APB Master declare
	
	reg                       pready;
	reg [APB_DATA_WIDTH : 0]  prdata;
	reg                       pslverr;
	
	wire [APB_ADDR_WIDTH : 0] paddr;
	wire [APB_SEL_WIDTH : 0]  psel;
	wire                      penable;
	wire                      pwrite;
	wire [APB_DATA_WIDTH : 0] pwdata;
	wire [APB_STRB_WIDTH : 0] pstrb ;

    // Call DUT
	WB_to_APB DUT
	(
	// connect wishbone signal
	.clk_i(clk),
	.rst_i(~rstn),
	.adr_i(adr_i),
	.dat_i(dat_i),
	.cyc_i(cyc_i),
	.sel_i(sel_i),
	.stb_i(stb_i),
	.we_i(we_i),
	.cti_i(cti_i),
	.bte_i(bte_i),
	.ack_o(ack_o),
	.dat_o(dat_o),
	.err_o(err_o),
	.rty_o(rty_o),
	
	// connect apb signal
	.pclk(clk),
	.preset_n(rstn),
	.pready(pready),
	.prdata(prdata),
	.pslverr(pslverr),
	.paddr(paddr),
	.psel(psel),
	.penable(penable),
	.pwrite(pwrite),
	.pwdata(pwdata),
	.pstrb(pstrb)
	);
	

// initial stimulus
    initial
	    begin
		    clk = 0;
			rstn = 0;
			#10 rstn = 1;
		end
    
	always  begin
	#5 clk = !clk;
	end
	
	
	
//----- READ TRANSFER -----//

//	Wishbone get signal from APB       


	initial
	    begin
           //data 0
            #50;
			@(negedge clk);
			adr_i = 32'd28;
			cti_i = 3'b010;
			bte_i = 2'b00;
			we_i  = 0;
			sel_i = $random;
			stb_i = $random;
			cyc_i = 1;
			// data 1
			@(negedge clk);
			prdata = 32'h0x1238;
			pready = 1;
			pslverr = 0;
			
			
			// data 2
			
			@(negedge clk);
			adr_i = 32'd32;
			
			@(negedge clk);
			prdata = 32'h0x2349;
			pready = 1;
			pslverr = 0;

           // data 3
			@(negedge clk);
			adr_i = 32'd36;
			
			@(negedge clk);
			prdata = 32'h0xAB30;
			pready = 1;
			pslverr = 0;

           // data 4
			@(negedge clk);
			adr_i = 32'd40;
			
			@(negedge clk);
			prdata = 32'h0xCD51;
			cti_i = 3'b111;
			bte_i = 2'b01;
			we_i  = 0;
			cyc_i = 1 ;	
			
            // end 
			@(negedge clk);
			stb_i = 0;
			cyc_i = 0 ;
			
			pready = 0;
			
			
            
		end



   
endmodule