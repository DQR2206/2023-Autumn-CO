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
integer i = 0;	 
reg [31:0] cnt = 32'b0;
reg [31:0] temp = 32'b0;
always@(*)begin	 
case(ALUOp) 
4'b0000: E_AO = src_A + src_B;
4'b0001: E_AO = src_A - src_B;
4'b0010: E_AO = src_A | src_B;
4'b0011: E_AO = {src_B[15:0],16'b0};
4'b0100: E_AO = src_B << shamt_f;
4'b0101: E_AO = ($signed(src_A) < $signed(src_B)) ? 32'b0001 : 32'b0000; // slt
4'b0110: E_AO = (src_A < src_B) ? 32'b0001 : 32'b0000;  //sltu
4'b1000: 
begin
	cnt = 32'b0;
	for(i=0;i<32;i=i+1)begin
		if(src_A[i] && src_B[i])begin
			cnt = cnt + 1'b1;
		end
	end
	E_AO = cnt;
end
4'b1001:
begin
	cnt = 32'b0;
	temp = 32'b0;
	for(i=0;i<32;i=i+1)begin
		if(src_A[i])begin
			cnt = cnt + 1'b1;
			if(cnt > temp)begin
			temp = cnt;
			end
		end
		else begin
		cnt = 32'b0;
		end
	end
	E_AO = temp;
end
4'b1010:
begin
	cnt = 32'b0;
	temp = src_A;
	for(i=0;(i<32)&&(cnt < src_B);i=i+1)begin
		if(src_A[i] == 1'b0)begin
			temp[i] = 1'b1;
			cnt = cnt + 1;
		end
	end
	E_AO = temp;
end
default : E_AO = 32'b0;
endcase
end

endmodule
