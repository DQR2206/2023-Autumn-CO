`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:36 11/09/2023 
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
input wire [4:0] shamt,
input wire flowjudge,
output wire equal,
output wire overflow,     
output reg [31:0] result
);
always@(*)begin
case(ALUOp)
4'b0000: result = src_A + src_B;
4'b0001: result = src_A - src_B;
4'b0010: result = {src_B[15:0],16'b0}; //lui
4'b0011: result = (src_A < src_B) ? 32'b1 : 32'b0; //sltu
4'b0100: result = ($signed(src_A) < $signed(src_B)) ? 32'b1 : 32'b0; //slt
4'b0101: result = src_B << shamt;
4'b0110: result = src_A | src_B;
endcase
end
assign overflow = 1'b0;
assign equal = (src_A == src_B) ? 1'b1 : 1'b0;
endmodule

/*
关于verilog中的运算符
按位操作运算符: ~取反 & 与 | 或 ^异或 ~^ 同或
关系运算符: > < >= <= 
移位运算符: >> >>> <<
运算: 乘(*) 除(/) 取模(%) 加(+) 减(-) 求幂(**)
逻辑运算符: 非(!) 与(&&) 或(||)
*/