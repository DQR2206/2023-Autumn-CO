`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:57:35 11/09/2023 
// Design Name: 
// Module Name:    SelectB 
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
module SelectB(
input [31:0] data,
input [4:0] judge, //实际上只用最后一位
input equal,
input Branch,
input [2:0] branchOp,
output reg result
);
localparam beq = 3'b000;
localparam bne = 3'b001;
localparam bgtz = 3'b010;
always@(*)begin
    case(branchOp)
    beq : result = equal & Branch;
    bne : result = (~equal) & Branch;
    bgtz : result = ($signed(data) > 32'b0) & Branch; 
    endcase
end
endmodule

//在always或initial中只能对寄存器类型的变量进行赋值，不能使用assign语句
//可以考虑将输出端口修改为reg类型或新增reg类型临时变量最后assign