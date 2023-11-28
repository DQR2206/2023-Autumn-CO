`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:01:00 11/13/2023 
// Design Name: 
// Module Name:    mips 
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
module mips(
input clk,
input reset
    );
//main
wire en,stall,clr;
assign en = !stall;
wire FwdDM;
wire [1:0] FwdCMPD1,FwdCMPD2,FwdALUA,FwdALUB;
//F 
wire [31:0] F_pc,F_pc8,F_instr;
//D
wire RegWrite_D,MemWrite_D,EXTOp_D,SelEMout_D,SelALUB_D,SelALUS_D,b_result_D,check_D,RegWrite_D_new;
wire [1:0] SelA3_D,SelWout_D,T_new_D,T_rs_use_D,T_rt_use_D;
wire [2:0] CMPOp_D,NPCOp_D,DMOp_D;
wire [3:0] ALUOp_D;
wire [4:0] D_A1,D_A2,D_A3,D_shamt;
wire [5:0] D_opcode,D_funct;
wire [15:0] D_E16;
wire [25:0] D_j_address;
wire [31:0] D_instr,D_pc,D_pc8,D_E32,D_V1,D_V2,D_V1_f,D_V2_f,D_npc,D_RA_f;
//E
wire RegWrite_E,MemWrite_E,SelALUB_E,SelEMout_E,SelALUS_E,check_E;
wire [1:0] SelWout_E,T_new_E;
wire [2:0] DMOp_E;
wire [3:0] ALUOp_E;
wire [4:0] E_A1,E_A2,E_A3,E_shamt,E_shamt_f,E_V1_f_shamt;
wire [31:0] E_V1,E_V2,E_V1_f,E_V2_f,E_E32,E_pc,E_pc8,E_ALU_B,E_AO,E_out;
//M
wire RegWrite_M,MemWrite_M,SelEMout_M,check_M;
wire [1:0] T_new_M,SelWout_M;
wire [2:0] DMOp_M;
wire [4:0] M_A2,M_A3;
wire [31:0] M_AO,M_V2,M_pc,M_pc8,M_DR,M_V1_f,M_out;
//W
wire RegWrite_W;
wire [1:0] SelWout_W,T_new_W;
wire [4:0] W_A3;
wire [31:0] W_pc,W_pc8,W_AO,W_DR,W_out;

IFU top_ifu(
.clk(clk),
.reset(reset),
.en(en),
.npc(D_npc),
.pc(F_pc),
.pc8(F_pc8),
.instr(F_instr)
);

assign clr = (~stall)&&(check_D)&&(!b_result_D);
regD top_regD(
.clk(clk),
.reset(reset),
.clr(clr),
.en(en),
.F_instr(F_instr),
.F_pc(F_pc),
.F_pc8(F_pc8),
.D_instr(D_instr),
.D_pc(D_pc),
.D_pc8(D_pc8)
);

HMUX_NPC top_hmux_npc(
.GRF_RD1(D_V1),
.E_out(E_out),
.M_out(M_out),
.FwdCMPD1(FwdCMPD1),
.D_RA_f(D_RA_f)
);


assign D_j_address = D_instr[25:0];
NPC top_npc(
.F_pc(F_pc),
.D_pc(D_pc),
.b_offset(D_E32),
.j_address(D_j_address),
.reg_address(D_RA_f),
.NPCOp(NPCOp_D),
.b_result(b_result_D),
.npc(D_npc)
);


assign D_opcode = D_instr[31:26];
assign D_funct = D_instr[5:0];
MCU top_mcu(
.D_opcode(D_opcode),
.D_funct(D_funct),
.SelA3_D(SelA3_D),
.RegWrite_D(RegWrite_D),
.MemWrite_D(MemWrite_D),
.EXTOp_D(EXTOp_D),
.SelEMout_D(SelEMout_D),
.SelWout_D(SelWout_D),
.SelALUB_D(SelALUB_D),
.SelALUS_D(SelALUS_D),
.check_D(check_D),
.ALUOp_D(ALUOp_D),
.NPCOp_D(NPCOp_D),
.CMPOp_D(CMPOp_D),
.DMOp_D(DMOp_D),
.T_rs_use_D(T_rs_use_D),
.T_rt_use_D(T_rt_use_D),
.T_new_D(T_new_D)
);

GRF top_grf(
.clk(clk),
.reset(reset),
.pc(W_pc),
.rs(D_A1),
.rt(D_A2),
.rd(W_A3),
.datawrite(W_out),
.RegWrite(RegWrite_W),
.dataread1(D_V1),
.dataread2(D_V2)
);

assign D_E16 = D_instr[15:0];
EXT top_ext(
.imm(D_E16),
.EXTOp(EXTOp_D),
.imm_32(D_E32)
);  

HMUX_CMP_D1 top_hmux_cmp_d1(
.GRF_RD1(D_V1),
.M_out(M_out),
.E_out(E_out),
.FwdCMPD1(FwdCMPD1),
.D_V1_f(D_V1_f)
);

HMUX_CMP_D2 top_hmux_cmp_d2(
.GRF_RD2(D_V2),
.M_out(M_out),
.E_out(E_out),
.FwdCMPD2(FwdCMPD2),
.D_V2_f(D_V2_f)
);

CMP top_cmp(
.D_V1(D_V1_f),
.D_V2(D_V2_f),
.CMPOp(CMPOp_D),
.b_result(b_result_D)
);


assign D_A1 = D_instr[25:21];
assign D_A2 = D_instr[20:16];

MUX_A3 top_mux_a3(
.D_instr_rt(D_A2),
.D_instr_rd(D_instr[15:11]),
.SelA3_D(SelA3_D),
.D_A3(D_A3)
);

assign D_shamt = D_instr[10:6];
assign RegWrite_D_new = RegWrite_D;
regE top_regE(
.clk(clk),
.reset(reset),

.clr(stall),
.D_V1(D_V1),
.D_V2(D_V2),
.D_A1(D_A1),
.D_A2(D_A2),
.D_A3(D_A3),
.check_D(check_D),
.D_shamt(D_shamt),
.D_E32(D_E32),
.D_pc(D_pc),
.D_pc8(D_pc8),
.T_new_D(T_new_D),
.RegWrite_D(RegWrite_D_new),
.MemWrite_D(MemWrite_D),
.SelEMout_D(SelEMout_D),
.SelWout_D(SelWout_D),
.SelALUB_D(SelALUB_D),
.SelALUS_D(SelALUS_D),
.ALUOp_D(ALUOp_D),
.DMOp_D(DMOp_D),

.E_V1(E_V1),
.E_V2(E_V2),
.E_A1(E_A1),
.E_A2(E_A2),
.E_A3(E_A3),
.check_E(check_E),
.E_shamt(E_shamt),
.E_E32(E_E32),
.E_pc(E_pc),
.E_pc8(E_pc8),
.T_new_E(T_new_E),
.RegWrite_E(RegWrite_E),
.MemWrite_E(MemWrite_E),
.SelEMout_E(SelEMout_E),
.SelWout_E(SelWout_E),
.SelALUB_E(SelALUB_E),
.SelALUS_E(SelALUS_E),
.ALUOp_E(ALUOp_E),
.DMOp_E(DMOp_E)
);

HMUX_ALU_A top_hmux_alu_a(
.E_V1(E_V1),
.W_out(W_out),
.M_out(M_out),
.FwdALUA(FwdALUA),
.E_V1_f(E_V1_f)
);

HMUX_ALU_B top_hmux_alu_b(
.E_V2(E_V2),
.W_out(W_out),
.M_out(M_out),
.FwdALUB(FwdALUB),
.E_V2_f(E_V2_f)
);

MUX_ALU_B top_mux_alu_b(
.E_V2_f(E_V2_f),
.E_E32(E_E32),
.SelALUB_E(SelALUB_E),
.E_ALU_B(E_ALU_B)
);

assign E_V1_f_shamt = E_V1_f[4:0];
MUX_ALU_S top_mux_alu_s(
.E_V1_f_shamt(E_V1_f_shamt),
.E_shamt(E_shamt),
.SelALUS_E(SelALUS_E),
.E_shamt_f(E_shamt_f)
);

ALU top_alu(
.src_A(E_V1_f),
.src_B(E_ALU_B),
.shamt_f(E_shamt_f),
.ALUOp(ALUOp_E),
.E_AO(E_AO)
);

MUX_E_out top_mux_e_out(
.E_E32(E_E32),
.E_pc8(E_pc8),
.SelEMout_E(SelEMout_E),
.E_out(E_out)
);

regM top_regM(
.clk(clk),
.reset(reset),

.E_AO(E_AO),
.E_V2(E_V2_f),
.E_A2(E_A2),
.E_A3(E_A3),
.check_E(check_E),
.E_pc(E_pc),
.E_pc8(E_pc8),
.T_new_E(T_new_E),
.RegWrite_E(RegWrite_E),
.MemWrite_E(MemWrite_E),
.SelEMout_E(SelEMout_E),
.SelWout_E(SelWout_E),
.DMOp_E(DMOp_E),

.M_AO(M_AO),
.M_V2(M_V2),
.M_A2(M_A2),
.M_A3(M_A3),
.check_M(check_M),
.M_pc(M_pc),
.M_pc8(M_pc8),
.T_new_M(T_new_M),
.RegWrite_M(RegWrite_M),
.MemWrite_M(MemWrite_M),
.SelEMout_M(SelEMout_M),
.SelWout_M(SelWout_M),
.DMOp_M(DMOp_M)
);

HMUX_DM top_hmux_dm(
.M_V2(M_V2),
.W_out(W_out),
.FwdDM(FwdDM),
.M_V1_f(M_V1_f)
);

DM top_dm(
.clk(clk),
.reset(reset),
.MemWrite_M(MemWrite_M),
.M_pc(M_pc),
.address(M_AO),
.datawrite(M_V1_f),
.DMOp_M(DMOp_M),
.dataread(M_DR)
);

wire [4:0] M_A3_new =  M_A3;
MUX_M_out top_hux_m_out(
.M_AO(M_AO),
.M_pc8(M_pc8),
.SelEMout_M(SelEMout_M),
.M_out(M_out)
);

regW top_regW(
.clk(clk),
.reset(reset),

.M_AO(M_AO),
.M_DR(M_DR),
.M_A3(M_A3_new),
.M_pc(M_pc),
.M_pc8(M_pc8),
.SelWout_M(SelWout_M),
.RegWrite_M(RegWrite_M),
.T_new_M(T_new_M),

.W_AO(W_AO),
.W_DR(W_DR),
.W_A3(W_A3),
.W_pc(W_pc),
.W_pc8(W_pc8),
.SelWout_W(SelWout_W),
.RegWrite_W(RegWrite_W),
.T_new_W(T_new_W)

);

MUX_W_out top_mux_w_out(
.W_AO(W_AO),
.W_DR(W_DR),
.W_pc8(W_pc8),
.SelWout_W(SelWout_W),
.W_out(W_out)
);


HCU top_hcu(
.D_A1(D_A1),
.D_A2(D_A2),
.E_A1(E_A1),
.E_A2(E_A2),
.E_A3(E_A3),
.check_E(check_E),
.M_A2(M_A2),
.M_A3(M_A3_new),
.check_M(check_M),
.W_A3(W_A3),
.RegWrite_E(RegWrite_E),
.RegWrite_M(RegWrite_M),
.RegWrite_W(RegWrite_W),
.T_rs_use(T_rs_use_D),
.T_rt_use(T_rt_use_D),
.T_new_E(T_new_E),
.T_new_M(T_new_M),
.T_new_W(T_new_W),
.FwdCMPD1(FwdCMPD1),
.FwdCMPD2(FwdCMPD2),
.FwdALUA(FwdALUA),
.FwdALUB(FwdALUB),
.FwdDM(FwdDM),
.stall(stall)
);

endmodule
