`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:42 12/05/2023 
// Design Name: 
// Module Name:    CP0 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: coprocessor
//
//////////////////////////////////////////////////////////////////////////////////
module CP0(
input clk,
input reset,
input [4:0] A1,
input [4:0] A2,
input [31:0] D_in,
input [31:0] M_pc,
input [4:0] M_ExcCode,
input M_BD,
input [5:0] HWInt,
input WE,
input EXLClr, // eret
output req,
output [31:0] EPC_out,
output [31:0] D_out
    );

reg [31:0] SR;
reg [31:0] Cause;
reg [31:0] EPC;
`define IM SR[15:10] // 6 outside interrupt
`define EXL SR[1]  // is in interrupt?
`define IE SR[0]   // enable to interrupt
`define BD Cause[31] // branch dalay 
`define IP Cause[15:10] // interrupt pending 
`define ExcCode Cause[6:2] // ExcCode

/*******************    interrupt   **********************/
wire int_req = (|(HWInt & `IM)) & (!`EXL) & (`IE);
wire exc_req = (| M_ExcCode) & (!`EXL);
assign req = int_req | exc_req; // request

always@(posedge clk)begin
	if(reset)begin
		SR <= 32'b0;
		Cause <= 32'b0;
		EPC <= 32'b0;
	end
	else begin
		`IP <= HWInt; // interrupt state
		if(EXLClr) `EXL <= 1'b0;
		if (req) begin
			`EXL <= 1'b1;
			EPC <= (M_BD) ? (M_pc - 4) : M_pc;
			`ExcCode <= (int_req) ? 5'd0 : M_ExcCode; // interrupt's exccode is 5'd0
			`BD <= M_BD;
		end
		else if (WE) begin
			if(A2 == 12) 
			begin
				`IM <= D_in[15:10];
				`EXL <= D_in[1];
				`IE <= D_in[0];
			end
			else if (A2 == 14) EPC <= D_in;
		end
	end
end


assign EPC_out = EPC; 

assign D_out = (A1 == 12) ? SR : 
			   (A1 == 13) ? Cause :
			   (A1 == 14) ? EPC :
				32'b0;
endmodule
