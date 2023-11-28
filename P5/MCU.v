`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:11:41 11/13/2023 
// Design Name: 
// Module Name:    MCU 
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
// main controller 
// instructions : add sub ori lui sw lw beq jal jr nop   
// add instructions : slt sltu / sb sh lb lh / jalr  / sll sllv                                                                              
//
module MCU(
input wire [5:0] D_opcode,
input wire [5:0] D_funct,
output wire [1:0] SelA3_D,
output wire RegWrite_D,
output wire MemWrite_D,
output wire EXTOp_D,
output wire SelEMout_D,
output wire [1:0] SelWout_D,
output wire SelALUB_D,
output wire SelALUS_D,   // shiftvar
output wire check_D,
output wire [2:0] CMPOp_D,
output wire [2:0] NPCOp_D,
output wire [3:0] ALUOp_D,
output wire [2:0] DMOp_D,
output wire [1:0] T_rs_use_D,
output wire [1:0] T_rt_use_D,
output wire [1:0] T_new_D
    );

localparam R = 6'b000000;
localparam add = 6'b100000;
localparam sub = 6'b100010;
localparam sll = 6'b000000;
localparam sllv = 6'b000100;
localparam jr = 6'b001000;
localparam slt = 6'b101010;
localparam sltu = 6'b101011;
localparam jalr = 6'b001001; 
localparam cco = 6'b111111;
localparam cmco = 6'b111110;
localparam fz = 6'b111100;

localparam ori = 6'b001101;
localparam lui = 6'b001111;
localparam sw = 6'b101011;
localparam sh = 6'b101001;
localparam sb = 6'b101000;
localparam lw = 6'b100011;
localparam lh = 6'b100001;
localparam lb = 6'b100000;
localparam jal = 6'b000011;
localparam beq = 6'b000100;
localparam bgezall = 6'b111111;
localparam blezalc = 6'b111110;
localparam lrm = 6'b111100;
localparam bsveall = 6'b111000;

wire op_add = (D_opcode == R && D_funct == add);
wire op_sub = (D_opcode == R && D_funct == sub);
wire op_jr = (D_opcode == R && D_funct == jr);
wire op_sll = (D_opcode == R) && (D_funct == sll);
wire op_sllv = (D_opcode == R) && (D_funct == sllv);
wire op_slt = (D_opcode == R) && (D_funct == slt);
wire op_sltu = (D_opcode == R) && (D_funct == sltu);
wire op_jalr = (D_opcode == R) && (D_funct == jalr);
wire op_cco = (D_opcode == R) && (D_funct == cco);
wire op_cmco = (D_opcode == R) && (D_funct == cmco);
wire op_fz = (D_opcode == R) && (D_funct == fz);
wire op_ori = (D_opcode == ori);
wire op_lui = (D_opcode == lui);
wire op_sw = (D_opcode == sw); 
wire op_sh = (D_opcode == sh);
wire op_sb = (D_opcode == sb);
wire op_lw = (D_opcode == lw);
wire op_lh = (D_opcode == lh);
wire op_lb = (D_opcode == lb);
wire op_beq = (D_opcode == beq);
wire op_jal = (D_opcode == jal);
wire op_bgezall = (D_opcode == bgezall);
wire op_blezalc = (D_opcode == blezalc);
wire op_lrm = (D_opcode == lrm);
wire op_bsveall = (D_opcode == bsveall);

assign check_D = op_bgezall | op_blezalc | op_lrm | op_bsveall;
//SelA3
assign SelA3_D[1] = op_jal | op_bgezall | op_blezalc | op_bsveall;
assign SelA3_D[0] = op_add | op_sub | op_sll | op_sllv | op_slt | op_sltu | op_jalr | op_cco | op_cmco | op_fz;
//SelEMout
assign SelEMout_D = op_jal | op_jalr | op_bgezall | op_blezalc | op_bsveall;
//SelWout
assign SelWout_D[1] = op_jal | op_jalr | op_bgezall | op_blezalc | op_bsveall;
assign SelWout_D[0] = op_lw | op_lh | op_lb | op_lrm;
assign RegWrite_D = op_add | op_sub | op_ori | op_lui | op_lw | op_lh | op_lb | op_jal | op_sll | op_sllv | op_slt | op_sltu | op_jalr | op_cco | op_bgezall | op_cmco | op_blezalc | op_lrm | op_fz | op_bsveall;
assign MemWrite_D = op_sw | op_sh | op_sb;
//ALU
assign SelALUB_D = op_ori | op_lui | op_lw | op_sw | op_sh | op_sb | op_lh | op_lb | op_lrm;
assign SelALUS_D = op_sllv;
assign EXTOp_D = op_beq | op_lw | op_sw | op_lh | op_lb | op_sh | op_sb | op_bgezall | op_blezalc | op_lrm | op_bsveall;
//NPCOp
assign NPCOp_D[2] = 1'b0;
assign NPCOp_D[1] = op_jal | op_jr | op_jalr;
assign NPCOp_D[0] = op_jr | op_beq | op_jalr | op_bgezall | op_blezalc | op_bsveall;
//ALUOp
assign ALUOp_D[3] = op_cco | op_cmco | op_fz;
assign ALUOp_D[2] = op_sll | op_sllv | op_slt | op_sltu;
assign ALUOp_D[1] = op_ori | op_lui | op_sltu | op_fz;
assign ALUOp_D[0] = op_sub | op_lui | op_slt | op_cmco;
//CMPOp beq = 000
assign CMPOp_D[2] = op_bsveall; 
assign CMPOp_D[1] = op_blezalc;
assign CMPOp_D[0] = op_bgezall;
//DMOp  sw = 000 lw = 100    
assign DMOp_D[2] = op_lw | op_lh | op_lb; //s_instr is 0 and l_instr is 1
assign DMOp_D[1] = op_sb | op_lb;
assign DMOp_D[0] = op_sh | op_lh ;
// if rs or rt is not used T_use = 3
//T_rs_use
assign T_rs_use_D[0] = op_add | op_sub | op_ori | op_lui | op_sw | op_sh | op_sb | op_lw | op_lh | op_lb | op_jal | op_sll | op_sllv | op_slt | op_sltu | op_cco | op_cmco | op_lrm | op_fz; 
assign T_rs_use_D[1] = op_jal | op_sll;
//T_rt_use
assign T_rt_use_D[0] = op_add | op_sub | op_ori | op_lui | op_lw | op_lh | op_lb | op_jal | op_jr | op_sll | op_sllv | op_slt | op_sltu | op_cco | op_bgezall | op_cmco | op_blezalc | op_lrm | op_fz;
assign T_rt_use_D[1] = op_sw | op_sh | op_sb | op_ori | op_lui | op_lw | op_lh | op_lb | op_jal | op_jr | op_bgezall | op_cmco | op_blezalc | op_lrm;
//T_new_D
assign T_new_D[0] = op_lw | op_lh | op_lb | op_lrm;
assign T_new_D[1] = op_lw | op_lh | op_lb | op_lrm | op_add | op_sub | op_ori | op_lui | op_sll | op_sllv | op_slt | op_sltu | op_cco | op_cmco | op_fz; 
endmodule
