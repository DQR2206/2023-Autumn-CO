`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:52 11/15/2023 
// Design Name: 
// Module Name:    regW 
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
module regW(
input clk,
input reset,

input [31:0] M_AO,
input [31:0] M_DR,
input [4:0] M_A3,
input [31:0] M_pc,
input [31:0] M_pc8,
input [1:0] SelWout_M,
input [1:0] T_new_M,
input RegWrite_M,

output [31:0] W_AO,
output [31:0] W_DR,
output [4:0] W_A3,
output [31:0] W_pc,
output [31:0] W_pc8,
output [1:0] SelWout_W,
output [1:0] T_new_W,
output RegWrite_W

    );
reg [31:0] AO;
reg [31:0] pc;
reg [31:0] pc8;
reg [31:0] DR;
reg [4:0] A3;
reg RegWrite;
reg [1:0] SelWout;
reg [1:0] T_new;
always@(posedge clk)begin
	if(reset)begin
	AO <= 32'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	DR <= 32'b0;
	A3 <= 5'b0;
	RegWrite <= 1'b0;
	SelWout <= 2'b0;
	T_new <= 2'b0;
	end
	else begin
	AO <= M_AO;
	DR <= M_DR;
	pc <= M_pc;
	pc8 <= M_pc8;
	RegWrite <= RegWrite_M;
	A3 <= M_A3;
	SelWout <= SelWout_M; 
	T_new <= (T_new_M > 2'b0) ? (T_new_M -1) : 2'b0;
	end
end

assign W_AO = AO;
assign W_DR = DR;
assign W_pc = pc;
assign W_pc8 = pc8;
assign W_A3 = A3;
assign RegWrite_W = RegWrite;
assign SelWout_W = SelWout;
assign T_new_W = T_new;
endmodule
