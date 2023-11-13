`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:57:55 11/09/2023 
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
input [15:0] imm,
input wire EXTOp,
output reg [31:0] imm_32
);
always@(*)begin
    if(EXTOp)begin
        imm_32 = {{16{imm[15]}},imm};
    end
    else begin
        imm_32 = {16'b0,imm};
    end
end
endmodule