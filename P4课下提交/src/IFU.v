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
//Ҫ�������Ϊ 16KB 4096*32bit ǧ��ע�⣡��һ��P4����������һ�������
module IFU(
input clk,
input reset,
input [31:0] npc,
output [31:0] pc,
output [31:0] instr
);
reg [31:0] PC; //PC�Ĵ���
reg [31:0] tmp; //����PC����3000���ӦROM�е���ʵ��ַ
reg [31:0] ROM [0:4095];

//��ʼ��ROM������
initial begin
	$readmemh("code.txt",ROM);
end

//PC
always@(posedge clk) //ͬ����λ
begin
    if(reset)begin
        PC <= 32'h0000_3000; //��λ��0x00003000
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