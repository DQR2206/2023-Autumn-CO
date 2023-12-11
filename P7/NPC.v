`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:21 11/15/2023 
// Design Name: 
// Module Name:    NPC 
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
// the point is NPC is in D not in F ; a big error!
module NPC(
input wire [31:0] F_pc,
input wire [31:0] D_pc,
input wire [31:0] b_offset,
input wire [25:0] j_address,
input wire [31:0] reg_address,
input wire [2:0] NPCOp,
input wire [31:0] EPC,
input wire req,
input wire D_eret,
input wire b_result,
output wire [31:0] npc
    );
wire [31:0] ADD4 = D_pc + 4'b0100;

assign npc = (req) ? 32'h0000_4180 : 
				 (D_eret) ? EPC :
				 (NPCOp == 3'b000) ? F_pc + 4'd4 :
				 (NPCOp == 3'b001 && b_result) ? D_pc + 4'd4 + (b_offset << 2'b10) : 
				 (NPCOp == 3'b010) ? {ADD4[31:28],j_address,2'b00} :
				 (NPCOp == 3'b011) ? reg_address :
				 (F_pc + 4'd4); 
				 

endmodule
