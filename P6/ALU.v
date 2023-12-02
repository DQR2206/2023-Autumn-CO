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
input wire [4:0] shamt_f,
input wire [3:0] ALUOp,
output reg [31:0] E_AO
    );
localparam op_add = 4'b0000;
localparam op_sub = 4'b0001;
localparam op_or = 4'b0010;
localparam op_and = 4'b0011;
localparam op_lui = 4'b0100;
localparam op_slt = 4'b0101;
localparam op_sltu = 4'b0110;
localparam op_sll = 4'b0111;
always@(*)begin	 
case(ALUOp) 
op_add : E_AO = src_A + src_B;
op_sub : E_AO = src_A - src_B;
op_or : E_AO = src_A | src_B;
op_and : E_AO = src_A & src_B;
op_lui : E_AO = {src_B[15:0],16'b0};
op_slt : E_AO = ($signed(src_A) < $signed(src_B)) ? 32'b0001 : 32'b0000; 
op_sltu : E_AO = (src_A < src_B) ? 32'b0001 : 32'b0000;
op_sll : E_AO = src_B << shamt_f;
default : E_AO = 32'b0;
endcase
end

endmodule
