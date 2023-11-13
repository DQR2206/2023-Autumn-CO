`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:57 11/09/2023 
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
//要求的容量为 16KB 4096*32bit 千万注意！第一次P4课上有人这一块出锅！
module IFU(
input clk,
input reset,
input [31:0] npc,
output [31:0] pc,
output [31:0] instr
);
reg [31:0] PC; //PC寄存器
reg [31:0] tmp; //代表PC减掉3000后对应ROM中的真实地址
reg [31:0] ROM [0:4095];

//初始化ROM中内容
initial begin
	$readmemh("code.txt",ROM);
end

//PC
always@(posedge clk) //同步复位
begin
    if(reset)begin
        PC <= 32'h0000_3000; //复位到0x00003000
        tmp <= 32'h0000_0000;
    end
    else begin
        PC <= npc;
        tmp <= npc - 32'h0000_3000;
    end
end
assign pc = PC;

//read from ROM
assign instr = ROM[tmp[13:2]];
endmodule