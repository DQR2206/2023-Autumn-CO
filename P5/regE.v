`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:59:18 11/15/2023 
// Design Name: 
// Module Name:    regE 
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
module regE(
input clk,
input reset,//tongbu reset
input clr, // stall
input [31:0] D_V1,
input [31:0] D_V2,
input [4:0] D_A1,
input [4:0] D_A2,
input [4:0] D_A3,
input check_D,
input [4:0] D_shamt,
input [31:0] D_E32,
input [31:0] D_pc,
input [31:0] D_pc8,
input [1:0] T_new_D,
input RegWrite_D,
input MemWrite_D,
input [1:0] SelWout_D,
input SelEMout_D,
input SelALUB_D,
input SelALUS_D,
input [3:0] ALUOp_D,
input [2:0] DMOp_D,
output [31:0] E_V1,
output [31:0] E_V2,
output [4:0] E_A1,
output [4:0] E_A2,
output [4:0] E_A3,
output check_E,
output [4:0] E_shamt,
output [31:0] E_E32,
output [31:0] E_pc,
output [31:0] E_pc8,
output [1:0] T_new_E,
output RegWrite_E,
output MemWrite_E,
output SelEMout_E,
output [1:0] SelWout_E,
output SelALUB_E,
output SelALUS_E,
output [3:0] ALUOp_E,
output [2:0] DMOp_E
    );
reg [31:0] V1;
reg [31:0] V2;
reg [4:0] A1;
reg [4:0] A2;
reg [4:0] A3;
reg [4:0] shamt;
reg [31:0] E32;
reg [31:0] pc;
reg [31:0] pc8;
reg [1:0] T_new;
reg RegWrite;
reg MemWrite;
reg [1:0] SelWout;
reg SelEMout;
reg SelALUB;
reg SelALUS;
reg [3:0] ALUOp;
reg [2:0] DMOp;
reg check;
always@(posedge clk) begin
	if(reset | clr) begin
	V1 <= 32'b0;
	V2 <= 32'b0;
	A1 <= 5'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	shamt <= 5'b0;
	E32 <= 32'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	MemWrite <= 1'b0;
	SelWout <= 2'b0;
	SelEMout <= 1'b0;
	SelALUB <= 1'b0;
	SelALUS <= 1'b0;
	ALUOp <= 3'b0;
	DMOp <= 3'b0;
	check <= 1'b0;
	end
	else begin
	V1 <= D_V1;
	V2 <= D_V2;
	A1 <= D_A1;
	A2 <= D_A2;
	A3 <= D_A3;
	check <= check_D;
	shamt <= D_shamt;
	E32 <= D_E32;
	pc <= D_pc;
	pc8 <= D_pc8;
	T_new <= (T_new_D > 2'b00) ? (T_new_D - 2'b01) : 2'b00;
	RegWrite <= RegWrite_D;
	MemWrite <= MemWrite_D;
	SelWout <= SelWout_D;
	SelEMout <= SelEMout_D;
	SelALUB <= SelALUB_D;
	SelALUS <= SelALUS_D;
	ALUOp <= ALUOp_D;
	DMOp <= DMOp_D;
	end
end
assign E_V1 = V1;
assign E_V2 = V2;
assign E_A1 = A1;
assign E_A2 = A2;
assign E_A3 = A3;
assign check_E = check;
assign E_shamt = shamt;
assign E_E32 = E32;
assign E_pc = pc;
assign E_pc8 = pc8;
assign T_new_E = T_new;
assign RegWrite_E = RegWrite;
assign MemWrite_E = MemWrite;
assign SelWout_E = SelWout;
assign SelEMout_E = SelEMout;
assign SelALUB_E = SelALUB;
assign SelALUS_E = SelALUS;
assign ALUOp_E = ALUOp;
assign DMOp_E = DMOp;
endmodule
