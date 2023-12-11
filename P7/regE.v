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
input req,
input [31:0] D_V1,
input [31:0] D_V2,
input [4:0] D_A1,
input [4:0] D_A2,
input [4:0] D_A3,
input [4:0] D_ExcCode_fixed,
input isAriOv_D,
input D_eret,
input D_BD,
input D_mfc0,
input D_mtc0,
input [4:0] D_CP0_addr,
input CP0_WE_D,
input check_D,
input start_D,
input mf_D,
input [31:0] D_E32,
input [31:0] D_pc,
input [31:0] D_pc8,
input [1:0] T_new_D,
input RegWrite_D,
input [1:0] SelWout_D,
input SelEMout_D,
input SelALUB_D,
input [3:0] ALUOp_D,
input [3:0] DMOp_D,
input [3:0] MDUOp_D,
output [31:0] E_V1,
output [31:0] E_V2,
output [4:0] E_A1,
output [4:0] E_A2,
output [4:0] E_A3,
output [4:0] E_ExcCode,
output isAriOv_E,
output E_eret,
output E_BD,
output CP0_WE_E,
output [4:0] E_CP0_addr,
output E_mfc0,
output E_mtc0,
output check_E,
output start_E,
output mf_E,
output [31:0] E_E32,
output [31:0] E_pc,
output [31:0] E_pc8,
output [1:0] T_new_E,
output RegWrite_E,
output SelEMout_E,
output [1:0] SelWout_E,
output SelALUB_E,
output [3:0] ALUOp_E,
output [3:0] DMOp_E,
output [3:0] MDUOp_E
    );
reg [31:0] V1;
reg [31:0] V2;
reg [4:0] A1;
reg [4:0] A2;
reg [4:0] A3;
reg [31:0] E32;
reg [31:0] pc;
reg [31:0] pc8;
reg [1:0] T_new;
reg RegWrite;
reg [1:0] SelWout;
reg SelEMout;
reg SelALUB;
reg [3:0] ALUOp;
reg [3:0] DMOp;
reg [3:0] MDUOp;
reg check;
reg start;
reg mf;
reg [4:0] ExcCode;
reg isAriOv;
reg eret;
reg CP0_WE;
reg BD;
reg [4:0] CP0_addr;
reg mfc0;
reg mtc0;

always@(posedge clk) begin
	if(reset) begin
	V1 <= 32'b0;
	V2 <= 32'b0; 
	A1 <= 5'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	E32 <= 32'b0;
	pc <= 32'b0;
	pc8 <= 32'b0;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	SelWout <= 2'b0;
	SelEMout <= 1'b0;
	SelALUB <= 1'b0;
	ALUOp <= 3'b0;
	DMOp <= 4'b0;
	MDUOp <= 4'b0;
	check <= 1'b0;
	start <= 1'b0;
	mf <= 1'b0;
	ExcCode <= 5'b0;
	isAriOv <= 1'b0;
	eret <= 1'b0;
	CP0_WE <= 1'b0; 
	BD <= 32'h0;
	CP0_addr <= 5'b0;
	mfc0 <= 1'b0;
	mtc0 <= 1'b0;
	end
	else if(req) begin
	V1 <= 32'b0;
	V2 <= 32'b0; 
	A1 <= 5'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	E32 <= 32'b0;
	pc <=  32'h0000_4180 ;
	pc8 <=  32'h0000_4188 ;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	SelWout <= 2'b0;
	SelEMout <= 1'b0;
	SelALUB <= 1'b0;
	ALUOp <= 3'b0;
	DMOp <= 4'b0;
	MDUOp <= 4'b0;
	check <= 1'b0;
	start <= 1'b0;
	mf <= 1'b0;
	ExcCode <= 5'b0;
	isAriOv <= 1'b0;
	eret <= 1'b0;
	CP0_WE <= 1'b0; 
	BD <=  1'b0;
	CP0_addr <= 5'b0;
	mfc0 <= 1'b0;
	mtc0 <= 1'b0;
	end
	else if(clr)begin
	V1 <= 32'b0;
	V2 <= 32'b0; 
	A1 <= 5'b0;
	A2 <= 5'b0;
	A3 <= 5'b0;
	E32 <= 32'b0;
	pc <=  D_pc ;
	pc8 <=  D_pc8 ;
	T_new <= 2'b0;
	RegWrite <= 1'b0;
	SelWout <= 2'b0;
	SelEMout <= 1'b0;
	SelALUB <= 1'b0;
	ALUOp <= 3'b0;
	DMOp <= 4'b0;
	MDUOp <= 4'b0;
	check <= 1'b0;
	start <= 1'b0;
	mf <= 1'b0;
	ExcCode <= 5'b0;
	isAriOv <= 1'b0;
	eret <= 1'b0;
	CP0_WE <= 1'b0; 
	BD <=  D_BD;
	CP0_addr <= 5'b0;
	mfc0 <= 1'b0;
	mtc0 <= 1'b0;	
	end
	else begin
	V1 <= D_V1;
	V2 <= D_V2;
	A1 <= D_A1;
	A2 <= D_A2;
	A3 <= D_A3;
	check <= check_D;
	start <= start_D;
	mf <= mf_D;
	E32 <= D_E32;
	pc <= D_pc;
	pc8 <= D_pc8;
	T_new <= (T_new_D > 2'b00) ? (T_new_D - 2'b01) : 2'b00;
	RegWrite <= RegWrite_D;
	SelWout <= SelWout_D;
	SelEMout <= SelEMout_D;
	SelALUB <= SelALUB_D;
	ALUOp <= ALUOp_D;
	DMOp <= DMOp_D;
	MDUOp <= MDUOp_D;
	ExcCode <= D_ExcCode_fixed; 
	isAriOv <= isAriOv_D;
	eret <= D_eret;
	CP0_WE <= CP0_WE_D;
	BD <= D_BD;
	CP0_addr <= D_CP0_addr;
	mfc0 <= D_mfc0; 
	mtc0 <= D_mtc0;
	end
end
assign E_V1 = V1;
assign E_V2 = V2;
assign E_A1 = A1;
assign E_A2 = A2;
assign E_A3 = A3;
assign check_E = check;
assign start_E = start;
assign mf_E = mf;
assign E_E32 = E32;
assign E_pc = pc;
assign E_pc8 = pc8;
assign T_new_E = T_new;
assign RegWrite_E = RegWrite;
assign SelWout_E = SelWout;
assign SelEMout_E = SelEMout;
assign SelALUB_E = SelALUB;
assign ALUOp_E = ALUOp;
assign DMOp_E = DMOp;
assign MDUOp_E = MDUOp;
assign E_ExcCode = ExcCode;
assign isAriOv_E = isAriOv;
assign E_eret = eret;
assign CP0_WE_E = CP0_WE;
assign E_BD = BD;
assign E_CP0_addr = CP0_addr;
assign E_mfc0 = mfc0;
assign E_mtc0 = mtc0;
endmodule
