module Module_WB (
	input	logic  			clk_i,
	input 	logic 			rst_i,

	input 	logic	[31:0]	dat_o,
	input	logic			ack_o,
	input	logic			err_o,
	input	logic			rty_o,

	output	logic	[2:0]	cti_i,
	output	logic	[1:0]	bte_i,
	output	logic	[31:0]	adr_i,
	output	logic	[31:0]	dat_i,
	output	logic			we_i,
	output	logic	[3:0]	sel_i,
	output	logic			stb_i,
	output	logic			cyc_i,
);


	
endmodule