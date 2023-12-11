`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:56:16 11/15/2023 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
input wire [31:0] src_A,
input wire [31:0] src_B,
input wire [3:0] ALUOp,
output wire overflow,
output reg [31:0] E_AO
    );
localparam op_add = 4'b0000;
localparam op_sub = 4'b0001;
localparam op_or = 4'b0010;
localparam op_and = 4'b0011;
localparam op_lui = 4'b0100;
localparam op_slt = 4'b0101;
localparam op_sltu = 4'b0110;

reg [32:0] ext_A = 32'b0;
reg [32:0] ext_B = 32'b0;
reg [32:0] ext_AO = 32'b0;

assign overflow = (ALUOp == op_add) && (ext_AO[32] != ext_AO[31]) ? 1'b1 :
						(ALUOp == op_sub) && (ext_AO[32] != ext_AO[31]) ? 1'b1 : 1'b0;

always@(*)begin	 
case(ALUOp) 
op_add : 
begin
	ext_A = {src_A[31],src_A};
	ext_B = {src_B[31],src_B};
	ext_AO = ext_A + ext_B;
	E_AO = ext_AO[31:0];
end
op_sub : 
begin
	ext_A = {src_A[31],src_A};
	ext_B = {src_B[31],src_B};
	ext_AO = ext_A - ext_B;
	E_AO = ext_AO[31:0];
end
op_or : E_AO = src_A | src_B;
op_and : E_AO = src_A & src_B;
op_lui : E_AO = {src_B[15:0],16'b0};
op_slt : E_AO = ($signed(src_A) < $signed(src_B)) ? 32'b0001 : 32'b0000; 
op_sltu : E_AO = (src_A < src_B) ? 32'b0001 : 32'b0000;
default : E_AO = 32'b0;
endcase
end

endmodule
