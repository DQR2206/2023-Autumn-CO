`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:58:46 11/09/2023 
// Design Name: 
// Module Name:    MUX 
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
//mux 文件

//寄存器写入地址选择 rt / rd / ra
module selTorD (
input [4:0] rt,
input [4:0] rd,
input wire RegDst,
output [4:0] r0
);
assign r0 = (RegDst == 1'b1) ? rd : rt;
endmodule

// rtd / ra?
module selR0orRA(
input [4:0] r0,
input ralink,
output [4:0] RegAddr
);
assign RegAddr = (ralink == 1'b1) ? 5'b11111 : r0;
endmodule

//寄存器写入数据选择
module ALUorDM(
input [31:0] ALUresult,
input [31:0] DMdata,
input MemtoReg,
output [31:0] data0
);
assign data0 = (MemtoReg == 1'b1) ? DMdata : ALUresult;
endmodule

module data0orPC(
input [31:0] data0,
input [31:0] pc,
input PCtoReg,
output [31:0] RegData
);
assign RegData = (PCtoReg == 1'b1) ? pc : data0;
endmodule

//ALU移位选择
module RegorShamt(
input [4:0] shamt,
input [31:0] readdata1,
input shiftvar,
output [4:0] shift
);
assign shift = (shiftvar == 1'b1) ? readdata1[4:0] : shamt;
endmodule

//ALU src_B选择
module ALUsrc_B(
input [31:0] readdata2,
input[31:0] offset, //imm_32
input ALUSrc,
output [31:0] DatatoSrcB
);
assign DatatoSrcB = (ALUSrc == 1'b1) ? offset : readdata2;
endmodule