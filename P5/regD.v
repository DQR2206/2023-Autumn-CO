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
input wire en, //en = ~stall
input wire clr,
input wire [31:0] F_instr,
input wire [31:0] F_pc,
input wire [31:0] F_pc8,
output wire [31:0] D_instr,
output wire [31:0] D_pc,
output wire [31:0] D_pc8
    );
reg [31:0] instr;
reg [31:0] pc;
reg [31:0] pc8;	 
always@(posedge clk)begin
	if(reset | clr)begin
	instr <= 32'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	end
	else begin
	if(en)begin
	instr <= F_instr;
	pc <= F_pc;
	pc8 <= F_pc8;
	end
	else begin   //stall
	instr <= instr;
	pc <= pc;
	pc8 <= pc8;
	end
	end
end
assign D_instr = instr;
assign D_pc = pc;
assign D_pc8 = pc8;
endmodule
