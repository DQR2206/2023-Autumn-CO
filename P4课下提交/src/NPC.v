`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:48 11/09/2023 
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
module NPC(
input wire [31:0] pc,
input wire [31:0] offset,
input wire [25:0] j_address,
input wire [31:0] reg_address,
input wire if_branch,
input wire [2:0] NPCOp,
output reg [31:0] npc,
output wire [31:0] PC_Add_Four 
);
// pc + 4
assign PC_Add_Four = pc + 4'b0100;

localparam B = 3'b001;
localparam J = 3'b010;
localparam ra = 3'b011;
always@(*)begin
    if (NPCOp == B && if_branch) begin
         npc = pc + 4'b0100 + (offset << 2'b10);
    end 
    else if (NPCOp == J) begin
         npc = {PC_Add_Four[31:28],j_address,2'b00};
    end
    else if (NPCOp == ra) begin
         npc = reg_address;
    end
    else begin
         npc = PC_Add_Four;
    end
end
endmodule
/*
对于NPCOp的解释:
00 npc = pc + 4
01 npc = b
10 npc = j_address
11 npc = reg_address 
*/