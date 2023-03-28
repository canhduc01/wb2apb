	/*
	tin hieu ben master thi active thep pclk, do master la apb
	tin hieu ben slave thi active theo clk_i
	*/
module wb_to_apb
#(	
	// Wishbone Slave declare
	parameter WB_ADDR_WIDTH = 32,
	parameter WB_DATA_WIDTH = 32,
	parameter WB_SEL_WIDTH  = 4,
	parameter WB_CTI_WIDTH  = 3,
	parameter WB_BTE_WIDTH  = 2,
	// APB Master declare
	parameter APB_ADDR_WIDTH = 32,
	parameter APB_SEL_WIDTH  = 4,
	parameter APB_DATA_WIDTH = 32,
	parameter APB_STRB_WIDTH = 4
)
(
    // Slave_WishBone
	input logic                    			clk_i,
	input logic                   			rst_i,
	input [WB_ADDR_WIDTH - 1 : 0] 			adr_i,
	input [WB_DATA_WIDTH - 1 : 0] 			dat_i,
	input l                   				cyc_i,
	input [WB_SEL_WIDTH - 1 : 0] 			sel_i,
	input                     				stb_i,
	input                     				we_i,
	input [WB_CTI_WIDTH - 1 : 0]  			cti_i,
	input [WB_BTE_WIDTH - 1 : 0]  			bte_i,
	
	output reg                     			ack_o,
	output reg [WB_DATA_WIDTH - 1 : 0] 		dat_o,
	output reg                     			err_o,
	output reg                     			rty_o,
	
	// Master_APB
	input  logic                     		pclk,
	input  logic                   			preset_n,
	input                       			pready,
	input [APB_DATA_WIDTH - 1: 0]  			prdata,
	input                       			pslverr,
	
	output reg [APB_ADDR_WIDTH - 1: 0] 		paddr,
	output reg [APB_SEL_WIDTH - 1: 0]  		psel,
	output reg                     			penable,
	output reg                      		pwrite,
	output reg [APB_DATA_WIDTH - 1 : 0] 	pwdata,
	output reg [APB_STRB_WIDTH - 1 : 0] 	pstrb
);
		
    localparam CTI_CLASSIC     = 3'b000,   			// classic cycle
               CTI_CONST_ADDR  = 3'b001,   			// constant addr burst cycle
               CTI_INCR_ADDR   = 3'b010,   			// increment burst cycle
               CTI_END_OF_BURST= 3'b111;   			// end of burst

    localparam BTE_LINEAR_BURST     = 2'b00,		
               BTE_4BEAT_WRAP_BURST = 2'b01,
               BTE_8BEAT_WRAP_BURST = 2'b10,
               BTE_16BEAT_WRAP_BURST= 2'b11;


	wire transfer_read = (cyc_i & stb_i) & (!we_i);
	wire transfer_write = (cyc_i & stb_i) & (we_i); 
	 
    wire wb_burst_req = cyc_i & stb_i & (cti_i == CTI_INCR_ADDR);
	
	localparam [2 : 0] 
	           IDLE         = 0,
			   SETUP_READ   = 1,
			   SETUP_WRITE  = 2,
			   ACCESS_READ  = 3,
			   ACCESS_WRITE = 4;		   
	reg [2 : 0] current_state, next_state;

//----- FSM for WishBone2APB -----//	
	
	// Reset			   
    always @(posedge pclk or negedge preset_n)
	    begin
		    if(~preset_n)
			    current_state <= IDLE;
			else 
			    current_state <= next_state;
		end
	always @ (*)
	    begin
		    case(current_state)
			    IDLE:
				    begin
					    if(transfer_read)
						    next_state = SETUP_READ;
						else if(transfer_write)
						    next_state = SETUP_WRITE;
						else
						    next_state = IDLE;
					end
				SETUP_READ:
				    begin
					    next_state = ACCESS_READ;
					end
				SETUP_WRITE:
				    begin
					    next_state = ACCESS_WRITE;
					end
				ACCESS_READ:
				    begin
					    if(transfer_read)
						    begin
                                if(pready) next_state = SETUP_READ;
						        else next_state = ACCESS_READ;
							end
						else next_state = IDLE;
					    
					end
				ACCESS_WRITE:
				    begin
					    if(transfer_write)
						    begin
							    if(pready) next_state = SETUP_WRITE;
                                else next_state = ACCESS_WRITE
							end
						else next_state = IDLE ;   						
					end
				default:
				    next_state = IDLE;
			endcase
					
		end
		
		
//------APB get signal from WishBone-----------|
	
// 	Write mode:
// 	pwdata
    always @(posedge pclk, negedge preset_n)
        begin
		    if(~preset_n) pwdata <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: pwdata <= 0;
						SETUP_WRITE: pwdata <= dat_i;
						ACCESS_WRITE: pwdata <= dat_i;
						default pwdata <= 0;
					endcase		
				end
        end	
// paddr
    always @(posedge pclk, negedge preset_n)
        begin
		    if(~preset_n) paddr <= 0;
            else
			    begin
				    if(transfer_read)
					    begin
                            case(current_state)
                            IDLE: paddr <= 0;			
						    SETUP_READ: paddr <= adr_i;
                            ACCESS_READ: paddr <= adr_i;
                            default: paddr <= 0;
				            endcase						
						end
					else if(transfer_write)
					    begin
                            case(current_state)
                            IDLE: paddr <= 0;
                            SETUP_WRITE: paddr <= adr_i;
                            ACCESS_WRITE: paddr <= adr_i;
                            default: paddr <= 0;
				            endcase
						end
				end	
        end	
//	psel
    always @(posedge pclk, negedge preset_n)
	    begin
		    if(~preset_n) psel <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: psel <= 0;
						SETUP_WRITE: psel <= stb_i;
						ACCESS_WRITE: psel <= stb_i;
						default: psel <= 0;
					endcase
				end
		end
//	pwrite
	always @(posedge pclk, negedge preset_n)
	    begin
		    if(~preset_n) pwrite <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: pwrite <= 0;
						SETUP_WRITE: pwrite <= we_i;
						ACCESS_WRITE: pwrite <= we_i;
						default: pwrite <= 0;
					endcase
				end
		end
// penable
    always @(posedge pclk, negedge preset_n)
	    begin
		    if(~preset_n) penable <= 0;
			else
			    begin
				    if(transfer_write)
					    begin		
				        case(current_state)
					    IDLE: penable <= 0;
						SETUP_WRITE: penable <= 0;
						ACCESS_WRITE: penable <= 1;
						default: penable <= 0;
					    endcase
						end
					else if(transfer_read)
					    begin		
				        case(current_state)
					    IDLE: penable <= 0;
						SETUP_WRITE: penable <= 0;
						ACCESS_WRITE: penable <= 1;
						default: penable <= 0;
					    endcase
						end    
				end	
		end
// pstrb
    always @(posedge pclk, negedge preset_n)
	    begin
		    if(~preset_n) pstrb <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: pstrb <= 0;
						SETUP_WRITE: pstrb <= sel_i;
						ACCESS_WRITE: pstrb <= sel_i;
						default: pstrb <= 0;
					endcase
				end
		end
	
	
	                                                           
//----- Wishbone get signal from APB -----//
	
	
// ack_o
	always @(posedge clk_i or negedge rst_i)
	    begin
		    if(rst_i) ack_o <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: ack_o <= 0;
						SETUP_READ: ack_o <= pready;
						ACCESS_WRITE: ack_o <= pready;
						default: ack_o <= 0;
					endcase
				end    
		end
// dat_o
	always @(posedge clk_i or negedge rst_i)
	    begin
		    if(rst_i) dat_o <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: dat_o <= 0;
						SETUP_READ: dat_o <= prdata;
						ACCESS_READ: dat_o <= prdata;
						default: dat_o <= 0;
					endcase
				end
		end
// err_o
	always @(posedge clk_i or negedge rst_i)
	    begin
		    if(rst_i) err_o <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: err_o <= 0;
						SETUP_READ: err_o <= 0;
						ACCESS_READ: err_o <= 0;
						default: err_o <= 0;
					endcase
				end
		end
//rty_o
	always @(posedge clk_i or negedge rst_i)	
	    begin
		    if(rst_i) rty_o <= 0;
			else
			    begin
				    case(current_state)
					    IDLE: rty_o <= 0;
						SETUP_READ: rty_o <= 0;
						ACCESS_READ: rty_o <= 0;
						default: rty_o <= 0;
					endcase
				end
	    end	
		      
endmodule
	