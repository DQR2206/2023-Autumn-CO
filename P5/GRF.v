`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:06 11/15/2023 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
input wire clk,
input wire reset,
input wire [4:0] rs,
input wire [4:0] rt,
input wire [4:0] rd,
input wire [31:0] pc,
input wire [31:0] datawrite,
input wire RegWrite,
output wire [31:0] dataread1,
output wire [31:0] dataread2
    );
reg [31:0] grf [0:31];
integer i = 0;
always@(posedge clk)begin
if(reset)begin
	for(i = 0;i < 32;i = i + 1)begin
		grf[i] <= 32'b0;
	end
end
else if(RegWrite && rd != 5'b0)begin
	$display("%d@%h: $%d <= %h", $time, pc, rd, datawrite);
	grf[rd] <= datawrite;
end
end
//forward
assign dataread1 = (RegWrite) && (rs == rd) && (rs != 5'b0) ? datawrite : grf[rs];
assign dataread2 = (RegWrite) && (rt == rd) && (rt != 5'b0) ? datawrite : grf[rt];
endmodule
