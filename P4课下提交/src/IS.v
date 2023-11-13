`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:24 11/09/2023 
// Design Name: 
// Module Name:    IS 
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
//splitter·ÖÏßÆ÷
module IS (
input wire [31:0] instr,
output wire [5:0] opcode,
output wire [4:0] rs,
output wire [4:0] rt,
output wire [4:0] rd,
output wire [4:0] shamt,
output wire [5:0] funct,
output wire [15:0] imm,
output wire [25:0] address
);
assign opcode = instr[31:26];
assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
assign shamt = instr[10:6];
assign funct = instr[5:0];
assign imm = instr[15:0];
assign address = instr[25:0];
endmodule
