`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:37 11/15/2023 
// Design Name: 
// Module Name:    regM 
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
module regM(
input clk,
input reset,
input req,
input [31:0] E_AO,
input [31:0] E_V2,
input [4:0] E_A2,
input [4:0] E_A3,
input check_E,
input [31:0] E_pc,
input [31:0] E_pc8,
input [1:0] T_new_E,
input RegWrite_E,
input SelEMout_E,
input [1:0] SelWout_E,
input [3:0] DMOp_E,
input [4:0] E_ExcCode_fixed,
input E_eret,
input CP0_WE_E,
input E_BD,
input [4:0] E_CP0_addr,
input E_mfc0,
input E_mtc0,

output [31:0] M_AO,
output [31:0] M_V2,
output [4:0] M_A2,
output [4:0] M_A3,
output check_M,
output [31:0] M_pc,
output [31:0] M_pc8,
output [1:0] T_new_M,
output RegWrite_M,
output SelEMout_M,
output [1:0] SelWout_M,
output [3:0] DMOp_M,
output [4:0] M_ExcCode,
output M_eret,
output CP0_WE_M,
output M_BD,
output [4:0] M_CP0_addr,
output M_mfc0,
output M_mtc0
    );
reg [31:0] AO;
reg [31:0] V2;
reg [4:0] A2;
reg [4:0] A3;
reg [31:0] pc;
reg [31:0] pc8;
reg [1:0] T_new;
reg RegWrite;
reg SelEMout;
reg [1:0] SelWout;
reg [3:0] DMOp;
reg check;
reg [4:0] ExcCode;
reg eret;
reg CP0_WE;
reg BD;
reg [4:0] CP0_addr;
reg mfc0;
reg mtc0;

always@(posedge clk) begin
	if(reset)begin
	AO <= 32'b0;
	V2 <= 32'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	SelEMout <= 1'b0;
	SelWout <= 2'b0;
	DMOp <= 4'b0;
	check <= 1'b0;
	ExcCode <= 5'b0;
	eret <= 1'b0;
	CP0_WE <= 1'b0;
	BD <= 1'b0;
	CP0_addr <= 5'b0;
	mfc0 <= 1'b0;
	mtc0 <= 1'b0;
	end
	else if(req) begin
	AO <= 32'b0;
	V2 <= 32'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	pc <= 32'h0000_4180;
	pc8 <= 32'h0000_4188;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	SelEMout <= 1'b0;
	SelWout <= 2'b0;
	DMOp <= 4'b0;
	check <= 1'b0;
	ExcCode <= 5'b0;
	eret <= 1'b0;
	CP0_WE <= 1'b0;
	BD <= 1'b0;
	CP0_addr <= 5'b0;
	mfc0 <= 1'b0;
	mtc0 <= 1'b0;
	end
	else begin
	AO <= E_AO;
	V2 <= E_V2;
	A2 <= E_A2;
	A3 <= E_A3;
	check <= check_E;
	pc <= E_pc;
	pc8 <= E_pc8;
	T_new <= (T_new_E > 2'b00) ? (T_new_E - 1'b1) : 2'b00;
	RegWrite <= RegWrite_E;
	SelEMout <= SelEMout_E;
	SelWout <= SelWout_E;
	DMOp <= DMOp_E;
	ExcCode <= E_ExcCode_fixed;
	eret <= E_eret;
	CP0_WE <= CP0_WE_E;
	BD <= E_BD;
	CP0_addr <= E_CP0_addr;
	mfc0 <= E_mfc0;
	mtc0 <= E_mtc0;
	end
end

assign M_AO = AO;
assign M_V2 = V2;
assign M_A2 = A2;
assign M_A3 = A3;
assign check_M = check;
assign M_pc = pc;
assign M_pc8 = pc8;
assign T_new_M = T_new;
assign RegWrite_M = RegWrite;
assign SelEMout_M = SelEMout;
assign SelWout_M = SelWout;
assign DMOp_M = DMOp;
assign M_ExcCode = ExcCode;
assign M_eret = eret;
assign CP0_WE_M = CP0_WE;
assign M_BD = BD;
assign M_CP0_addr = CP0_addr;
assign M_mfc0 = mfc0;
assign M_mtc0 = mtc0;
endmodule
