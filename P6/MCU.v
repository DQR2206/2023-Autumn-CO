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
output wire EXTOp_D,
output wire SelEMout_D,
output wire [1:0] SelWout_D,
output wire SelALUB_D,
output wire SelALUS_D,   // shiftvar
output wire check_D,
output wire mf_D,
output wire start_D,
output wire [2:0] CMPOp_D,
output wire [2:0] NPCOp_D,
output wire [3:0] ALUOp_D,
output wire [3:0] MDUOp_D,
output wire [3:0] DMOp_D,
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
localparam _and = 6'b100100;
localparam _or = 6'b100101;
localparam mult = 6'b011000;
localparam multu = 6'b011001;
localparam div = 6'b011010;
localparam divu = 6'b011011;
localparam mfhi = 6'b010000;
localparam mflo = 6'b010010;
localparam mthi = 6'b010001;
localparam mtlo = 6'b010011;

localparam addi = 6'b001000;
localparam andi = 6'b001100;
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
localparam bne = 6'b000101;


wire op_add = (D_opcode == R && D_funct == add);
wire op_sub = (D_opcode == R && D_funct == sub);
wire op_jr = (D_opcode == R && D_funct == jr);
wire op_sll = (D_opcode == R) && (D_funct == sll);
wire op_sllv = (D_opcode == R) && (D_funct == sllv);
wire op_slt = (D_opcode == R) && (D_funct == slt);
wire op_sltu = (D_opcode == R) && (D_funct == sltu);
wire op_jalr = (D_opcode == R) && (D_funct == jalr);
wire op_and = (D_opcode == R) && (D_funct == _and);
wire op_or = (D_opcode == R) && (D_funct == _or);
wire op_mult = (D_opcode == R) && (D_funct == mult);
wire op_multu = (D_opcode == R) && (D_funct == multu);
wire op_div = (D_opcode == R) && (D_funct == div);
wire op_divu = (D_opcode == R) && (D_funct == divu);
wire op_mfhi = (D_opcode == R) && (D_funct == mfhi);
wire op_mflo = (D_opcode == R) && (D_funct == mflo);
wire op_mthi = (D_opcode == R) && (D_funct == mthi);
wire op_mtlo = (D_opcode == R) && (D_funct == mtlo);

wire op_andi = (D_opcode == andi);
wire op_addi = (D_opcode == addi);
wire op_ori = (D_opcode == ori);
wire op_lui = (D_opcode == lui);
wire op_sw = (D_opcode == sw); 
wire op_sh = (D_opcode == sh);
wire op_sb = (D_opcode == sb);
wire op_lw = (D_opcode == lw);
wire op_lh = (D_opcode == lh);
wire op_lb = (D_opcode == lb);
wire op_beq = (D_opcode == beq);
wire op_bne = (D_opcode == bne);
wire op_jal = (D_opcode == jal);

// classify instructions
// cal_R cal_I shift shiftv load store 
// branch lui md mf mt
assign cal_R = op_add | op_sub | op_or | op_and | op_slt | op_sltu;
assign cal_I = op_addi | op_andi | op_ori | op_lui;
assign shift = op_sll;
assign shiftv = op_sllv;
assign branch = op_beq | op_bne;
assign load = op_lw | op_lh | op_lb;
assign store = op_sw | op_sh | op_sb;
assign md = op_mult | op_multu | op_div | op_divu;
assign mf = op_mfhi | op_mflo;//rs
assign mt = op_mthi | op_mtlo;//rs

assign mf_D = mf;
assign start_D = md;
assign check_D = 1'b0; // class new instruction 
//SelA3
assign SelA3_D[1] = op_jal ;
assign SelA3_D[0] = cal_R | shift | shiftv | op_jalr | mf;
//SelEMout
assign SelEMout_D = op_jal | op_jalr ;
//SelWout
assign SelWout_D[1] = op_jal | op_jalr ;
assign SelWout_D[0] = load;
assign RegWrite_D = cal_R | cal_I | op_jal | shift | shiftv | op_jalr | mf | load;
//ALU
assign SelALUB_D = cal_I| load | store ;
assign SelALUS_D = shiftv;
assign EXTOp_D = branch | load | store | op_addi;
//NPCOp
assign NPCOp_D[2] = 1'b0;
assign NPCOp_D[1] = op_jal | op_jr | op_jalr;
assign NPCOp_D[0] = op_jr | op_beq | op_jalr | op_bne;
//ALUOp
assign ALUOp_D[3] = 1'b0;
assign ALUOp_D[2] = op_sll | op_sllv | op_slt | op_sltu | op_lui;
assign ALUOp_D[1] = op_sll | op_sllv | op_ori | op_or | op_sltu | op_and | op_andi;
assign ALUOp_D[0] = op_sll | op_sllv | op_sub | op_slt | op_and | op_andi;
//CMPOp beq = 000
assign CMPOp_D[2] = 1'b0; 
assign CMPOp_D[1] = 1'b0;
assign CMPOp_D[0] = op_bne;
//DMOp  
assign DMOp_D[3] = op_lw | op_lh | op_lb;   
assign DMOp_D[2] = 1'b0;
assign DMOp_D[1] = op_sh | op_sb | op_lb;
assign DMOp_D[0] = op_sw | op_sb | op_lh;

//MDUOp
assign MDUOp_D[3] = op_mtlo;
assign MDUOp_D[2] = op_divu | op_mfhi | op_mflo | op_mthi;
assign MDUOp_D[1] = op_multu | op_div | op_mflo | op_mthi;
assign MDUOp_D[0] = op_mult | op_div | op_mfhi | op_mthi;
// if rs or rt is not used T_use = 3
assign T_rs_use_D = (branch | op_jr | op_jalr) ? 2'b00 :
						  (cal_R | cal_I | load | store | shiftv | md | mt) ? 2'b01 :
						  2'b11;
assign T_rt_use_D = (branch) ? 2'b00 :
						  (cal_R | shift | shiftv | md) ? 2'b01 :
						  2'b11;
assign T_new_D = (load) ? 2'b11 :
					  (cal_R | cal_I | shift | shiftv | mf) ? 2'b10 :
					  2'b00;
endmodule
