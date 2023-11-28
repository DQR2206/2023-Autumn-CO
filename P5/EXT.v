`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:08:43 11/15/2023 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
input wire [15:0] imm,
input wire EXTOp,
output wire [31:0] imm_32
    );
assign imm_32 = (EXTOp == 1'b1) ? {{16{imm[15]}},imm} : {16'b0,imm};
endmodule
