`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:33:08 11/15/2023 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
input clk,
input reset,
input en,
input wire [31:0] npc,
output wire [31:0] pc,
output wire [31:0] pc8,
output wire [31:0] instr
    );
reg [31:0] ROM [0:4095];
reg [31:0] tmp = 32'b0;
reg [31:0] PC = 32'b0;
reg [31:0] PC8 = 32'b0;
initial begin
$readmemh("code.txt",ROM);
end

always@(posedge clk)begin
if(reset)begin
	PC <= 32'h0000_3000;
	PC8 <= 32'h0000_3008;
	tmp <= 32'b0;
end
else if (en)begin
	PC <= npc;
	PC8 <= npc + 4'b1000;
	tmp <= npc - 32'h0000_3000;
end
else begin
	PC <= PC;
	PC8 <=PC8;
	tmp <= tmp;
end
end
assign pc = PC;
assign pc8 = PC8;
assign instr = ROM[tmp[13:2]];
endmodule
