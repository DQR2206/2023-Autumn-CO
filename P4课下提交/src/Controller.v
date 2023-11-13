`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:58:31 11/09/2023 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
input [5:0] opcode,
input [5:0] funct,
output reg MemtoReg,
output reg MemWrite,
output reg ALUSrc,
output reg RegWrite,
output reg EXTOp,
output reg RegDst,
output reg PCtoReg,
output reg ralink,
output reg shiftvar,  
output reg Branch,
output reg flowjudge,
output wire [2:0] branchOp,
output wire [2:0] NPCOp,
output wire [3:0] ALUOp,
output wire [3:0] LSOp
);

reg op_add;
reg op_sub;
reg op_sll;
reg op_sllv;
reg op_slt;
reg op_sltu;
reg op_jr;
reg op_jalr;
reg op_j;
reg op_jal;
reg op_lui;
reg op_ori;
reg op_beq;
reg op_bne;
reg op_bgtz;
reg op_sw;
reg op_sh;
reg op_sb;
reg op_lw;
reg op_lh;
reg op_lb;

localparam R = 6'b000000;
localparam _add = 6'b100000;
localparam _sub = 6'b100010;
localparam _sll = 6'b000000;
localparam _sllv = 6'b000100;
localparam _slt = 6'b101010;
localparam _sltu = 6'b101011;
localparam _jr = 6'b001000;
localparam _jalr = 6'b001001;
localparam _j = 6'b000010;
localparam _jal = 6'b000011;
localparam _lui = 6'b001111;
localparam _ori = 6'b001101;
localparam _beq = 6'b000100;
localparam _bne = 6'b000101;
localparam _bgtz = 6'b000111;
localparam _sw = 6'b101011;
localparam _sh = 6'b101001;
localparam _sb = 6'b101000;
localparam _lw = 6'b100011;
localparam _lh = 6'b100001;
localparam _lb = 6'b100000;

reg branchOp2 = 1'b0;
reg branchOp1 = 1'b0;
reg branchOp0 = 1'b0;
reg ALUOp3 = 1'b0;
reg ALUOp2 = 1'b0;
reg ALUOp1 = 1'b0;
reg ALUOp0 = 1'b0;
reg NPCOp2 = 1'b0;
reg NPCOp1 = 1'b0;
reg NPCOp0 = 1'b0;
reg LSOp3 = 1'b0;
reg LSOp2 = 1'b0;
reg LSOp1 = 1'b0;
reg LSOp0 = 1'b0;

always@(*) begin
op_add = 1'b0;
op_sub = 1'b0;
op_sll = 1'b0;
op_sllv = 1'b0;
op_slt = 1'b0;
op_sltu = 1'b0;
op_jr = 1'b0;
op_jalr = 1'b0;
op_j = 1'b0;
op_jal = 1'b0;
op_lui = 1'b0;
op_ori = 1'b0;
op_beq = 1'b0;
op_bne = 1'b0;
op_bgtz = 1'b0;
op_sw = 1'b0;
op_sh = 1'b0;
op_sb = 1'b0;
op_lw = 1'b0;
op_lh = 1'b0;
op_lb = 1'b0;

case(opcode)

R :
begin
case(funct)
_add : op_add = 1'b1;
_sub : op_sub = 1'b1;
_sll : op_sll = 1'b1;
_sllv : op_sllv = 1'b1;
_slt : op_slt = 1'b1;
_sltu : op_sltu = 1'b1;
_jr : op_jr = 1'b1;
_jalr : op_jalr = 1'b1;
endcase
end

_j : op_j = 1'b1;
_jal : op_jal = 1'b1;
_lui : op_lui = 1'b1;
_ori : op_ori = 1'b1;
_beq : op_beq = 1'b1;
_bne : op_bne = 1'b1;
_bgtz : op_bgtz = 1'b1;
_sw : op_sw = 1'b1;
_sh : op_sh = 1'b1;
_sb : op_sb = 1'b1;
_lw : op_lw = 1'b1;
_lh : op_lh = 1'b1;
_lb : op_lb = 1'b1;
endcase

MemtoReg = op_lw | op_lh | op_lb ;
RegDst =  op_add | op_sub | op_sll | op_sllv | op_slt | op_sltu | op_jr | op_jalr ;
ALUSrc = op_sw | op_lw | op_sh | op_sb | op_lh | op_lb | op_lui | op_ori;   
RegWrite = op_slt | op_sltu |  op_add | op_sub | op_lui | op_ori | op_lw | op_lh | op_lb | op_jal | op_jalr | op_sll | op_sllv ;
MemWrite = op_sw | op_sb | op_sh ;
shiftvar = op_sllv ;
ralink = op_jal ;
PCtoReg = op_jal | op_jalr ;
EXTOp =  op_sw | op_sh | op_sb | op_lw | op_lh | op_lb | op_beq | op_bne | op_bgtz ;
Branch = op_beq | op_bne | op_bgtz ; 
//branchop
branchOp2 = 1'b0;
branchOp1 = op_bgtz ;
branchOp0 = op_bne;
//NPCOp
NPCOp2 = 1'b0;
NPCOp1 = op_jalr | op_jr | op_j | op_jal;
NPCOp0 = op_jalr | op_jr | op_beq | op_bne | op_bgtz ;
//ALUOp  
ALUOp3 = 1'b0;
ALUOp2 = op_slt | op_sll | op_sllv | op_ori;
ALUOp1 = op_lui | op_sltu | op_ori;
ALUOp0 = op_sub | op_sltu | op_sll | op_sllv;
//LSOp
LSOp3 = 1'b0;
LSOp2 = op_lh | op_lb ;
LSOp1 = op_sb | op_lw ;
LSOp0 = op_sh | op_lw | op_lb ;
end

assign branchOp = {branchOp2,branchOp1,branchOp0};
assign ALUOp ={ALUOp3,ALUOp2,ALUOp1,ALUOp0};
assign NPCOp = {NPCOp2,NPCOp1,NPCOp0};
assign LSOp = {LSOp3,LSOp2,LSOp1,LSOp0};

endmodule
