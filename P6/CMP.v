`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:02 11/16/2023 
// Design Name: 
// Module Name:    CMP 
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
// B class compare
module CMP(
input wire [31:0] D_V1,
input wire [31:0] D_V2,
input wire [2:0] CMPOp,  // beq firstly other instructions are waiting to be added
output reg b_result
    );
localparam beq = 3'b000;
localparam bne = 3'b001;
always@(*)begin
	case(CMPOp)
	beq : b_result = (D_V1 == D_V2) ? 1'b1 : 1'b0; 
	bne : b_result = (D_V1 != D_V2) ? 1'b1 : 1'b0;
	default : b_result = 1'b0;
	endcase
end
endmodule
