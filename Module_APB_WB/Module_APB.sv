
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
    else if ((psel == 1) && (penable == 1'b1)  ) 
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


 
