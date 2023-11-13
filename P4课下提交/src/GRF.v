`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:58:06 11/09/2023 
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
input clk,
input reset,
input [4:0] rs,
input [4:0] rt,
input [4:0] rd,
input RegWrite,
input [31:0] pc,
input [31:0] writedata,
output wire [31:0] readdata1,
output wire [31:0] readdata2
);
reg [31:0] grf[31:0]; //32��ͨ�üĴ���

//write
integer i = 0;
always@(posedge clk) begin
    if(reset)begin
        for(i = 0 ; i <= 5'b11111 ; i = i + 1'b1) begin
            grf[i] <= 32'b0;
        end
    end
    else if (RegWrite) begin   //0�żĴ�������д��   rd && RegWrite
    if(rd != 5'b00000) begin
		  $display("@%h: $%d <= %h", pc, rd, writedata); //���д��Ĵ������
        grf[rd] <= writedata;
    end
    else begin
        grf[rd] <= grf[rd];
    end
    end
end
assign readdata1 = grf[rs];
assign readdata2 = grf[rt];
endmodule

