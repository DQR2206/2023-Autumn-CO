`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:28 11/15/2023 
// Design Name: 
// Module Name:    regD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module regD(
input wire clk,
input wire reset, // tongbu reset
input wire req,
input wire en, //en = ~stall
input wire clr,
input wire [4:0] F_ExcCode,
input wire F_BD,
input wire [31:0] F_instr,
input wire [31:0] F_pc,
input wire [31:0] F_pc8,
output wire [4:0] D_ExcCode,
output wire D_BD,
output wire [31:0] D_instr,
output wire [31:0] D_pc,
output wire [31:0] D_pc8
    );
reg [31:0] instr;
reg [31:0] pc;
reg [31:0] pc8;	 
reg [4:0] ExcCode;
reg BD;
always@(posedge clk)begin
	if(reset )begin 
	instr <= 32'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	ExcCode <= 5'b0;
	BD <= 1'b0;
	end
	else if  (req) begin
	instr <= 32'b0;
	pc <= 32'h0000_4180;
	pc8 <= 32'h0000_4188;
	ExcCode <= 5'b0;
	BD <= 1'b0;
	end
	else if (en) begin
	instr <= F_instr;
	pc <= F_pc;
	pc8 <= F_pc8;
	ExcCode <= F_ExcCode;
	BD <= F_BD;
	end
	else begin   //stall
	instr <= instr;
	pc <= pc;
	pc8 <= pc8;
	ExcCode <= ExcCode;
	BD <= BD;
	end
end
assign D_instr = instr;
assign D_pc = pc;
assign D_pc8 = pc8;
assign D_ExcCode = ExcCode;
assign D_BD = BD;
endmodule
