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
module cpu(
input clk,
input reset,
input [5:0] HWInt, // interrupt 
//IM
output wire [31:0] i_inst_addr,
input wire [31:0] i_inst_rdata,
//DM
input wire [31:0] m_data_rdata,
output wire [31:0] m_data_addr,
output wire [31:0] m_data_wdata,
output wire [3 :0] m_data_byteen,
output wire [31:0] m_inst_addr,
//GRF output 
output wire w_grf_we,
output wire [4:0] w_grf_addr,
output wire [31:0] w_grf_wdata,
output wire [31:0] w_inst_addr
    );
	 
//main
wire en,stall,clr,req;
assign en = !stall;
wire FwdDM;
wire [1:0] FwdCMPD1,FwdCMPD2,FwdALUA,FwdALUB;
//F 
wire F_BD; // branch delay
wire [4:0] F_ExcCode; //F exception code 
wire [31:0] F_pc,F_pc8;
wire [31:0] F_pc_new,F_pc8_new;
wire [31:0] F_inst_new;
//D
wire RegWrite_D,EXTOp_D,SelEMout_D,SelALUB_D,b_result_D,check_D,RegWrite_D_new,start_D,mf_D;
wire invalid_D,isAriOv_D,D_eret,CP0_WE_D,D_BD,D_syscall,D_mfc0,D_mtc0;
wire [1:0] SelA3_D,SelWout_D,T_new_D,T_rs_use_D,T_rt_use_D;
wire [2:0] CMPOp_D,NPCOp_D;
wire [3:0] ALUOp_D,DMOp_D,MDUOp_D;
wire [4:0] D_A1,D_A2,D_A3,D_ExcCode,D_ExcCode_fixed;//D exception code 
wire [4:0] D_CP0_addr;
wire [5:0] D_opcode,D_funct;
wire [15:0] D_E16;
wire [25:0] D_j_address;
wire [31:0] D_instr,D_pc,D_pc8,D_E32,D_V1,D_V2,D_V1_f,D_V2_f,D_npc,D_RA_f;
//E
wire RegWrite_E,SelALUB_E,SelEMout_E,check_E,start_E,busy_E,mf_E;
wire E_BD,overflow_E,isAriOv_E,E_eret,CP0_WE_E,E_mfc0,E_mtc0;
wire [1:0] SelWout_E,T_new_E;
wire [3:0] ALUOp_E,DMOp_E,MDUOp_E;
wire [4:0] E_A1,E_A2,E_A3,E_ExcCode,E_ExcCode_fixed;// E exception code 
wire [4:0] E_CP0_addr;
wire [31:0] E_V1,E_V2,E_V1_f,E_V2_f,E_E32,E_pc,E_pc8,E_ALU_B,E_AO,E_out,E_MDU_out,E_AO_new;
//M
wire RegWrite_M,SelEMout_M,check_M;
wire M_BD,M_eret,CP0_WE_M,M_mfc0,M_mtc0;
wire [1:0] T_new_M,SelWout_M;
wire [3:0] DMOp_M;
wire [4:0] M_A2,M_A3,M_ExcCode,M_ExcCode_fixed;// M exception code 
wire [4:0] M_CP0_addr;
wire [31:0] M_AO,M_V2,M_pc,M_pc8,M_DR,M_V1_f,M_out,M_DR_new,M_CP0_out,M_EPC_out;
//W
wire RegWrite_W;
wire [1:0] SelWout_W,T_new_W;
wire [4:0] W_A3;
wire [31:0] W_pc,W_pc8,W_AO,W_DR,W_out;
/***************************     Exception code   *****************************************/
localparam INT = 5'b00000;
localparam NONE = 5'b00000;   // the same as interrupt
localparam ADEL = 5'b00100;
localparam ADES = 5'b00101;
localparam SYSCALL = 5'b01000;
localparam RI = 5'b01010;
localparam OV = 5'b01100;

/************************************     F     ******************************************/
IFU top_ifu(
.clk(clk),
.reset(reset),
.req(req),
.en(en),
.npc(D_npc),
.pc(F_pc),
.pc8(F_pc8)
);
//assign F_pc_new = (D_eret) ? M_EPC_out : F_pc;
//assign F_pc8_new = (D_eret) ? (M_EPC_out + 4'd8) : F_pc8;
assign F_pc_new =  F_pc;
assign F_pc8_new =  F_pc8;
assign F_inst_new = (F_ExcCode) ? 32'b0 : (D_eret) ? 32'b0 : i_inst_rdata;
assign i_inst_addr = F_pc_new;
/////////////////////////////////////////////////////////////////////////////////////////
// class extend : if not branch then NullifyCurrentInstruction()
// assign clr = (~stall)&&(check_D)&&(!b_result_D);
////////////////////////////////////////////////////////////////////////////////////////
assign clr = 1'b0;
assign F_BD = (NPCOp_D != 3'b000) ; // is jump
// F exception //////////////////////////////////////////////////////////////////////////////////////////////
assign F_ExcCode = (!D_eret) && (F_pc_new[1:0] != 2'b00) || (F_pc_new < 32'h0000_3000) || (F_pc_new > 32'h0000_6ffc) ? ADEL : NONE;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*************************************      D      **************************************/
regD top_regD(
.clk(clk),
.reset(reset),
.req(req),
.clr(clr),
.en(en),
.F_ExcCode(F_ExcCode),
.F_BD(F_BD),
.F_instr(F_inst_new),
.F_pc(F_pc),
.F_pc8(F_pc8),
.D_instr(D_instr),
.D_ExcCode(D_ExcCode),
.D_BD(D_BD),
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
.req(req),
.D_eret(D_eret),
.EPC(M_EPC_out),
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
.D_rs(D_A1),
.SelA3_D(SelA3_D),
.RegWrite_D(RegWrite_D),
.EXTOp_D(EXTOp_D),
.SelEMout_D(SelEMout_D),
.SelWout_D(SelWout_D),
.SelALUB_D(SelALUB_D),
.start_D(start_D),
.mf_D(mf_D),
.invalid_D(invalid_D),
.isAriOv_D(isAriOv_D),
.D_eret(D_eret),
.D_syscall(D_syscall),
.D_mfc0(D_mfc0),
.D_mtc0(D_mtc0),
.CP0_WE_D(CP0_WE_D),
.check_D(check_D),
.ALUOp_D(ALUOp_D),
.NPCOp_D(NPCOp_D),
.CMPOp_D(CMPOp_D),
.DMOp_D(DMOp_D),
.MDUOp_D(MDUOp_D),
.T_rs_use_D(T_rs_use_D),
.T_rt_use_D(T_rt_use_D),
.T_new_D(T_new_D)
);

//////////////  D exception   //////////////////////////////////////////////////////
assign D_ExcCode_fixed = (D_ExcCode) ? D_ExcCode : 
								 (invalid_D) ? RI :
								 (D_syscall) ? SYSCALL :
								 NONE;
////////////////////////////////////////////////////////////////////////////////////

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
/////////////////////////////////////////////////////////////////////
// GRF tb output 
assign w_grf_addr = W_A3;
assign w_grf_we = RegWrite_W;
assign w_grf_wdata = W_out;
assign w_inst_addr = W_pc;
//////////////////////////////////////////////////////////////////////
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

////////////////////////////////////////////////////////////////////////////////////////
// class extend : condition link
// assign RegWrite_D_new = (check_D) ? ((b_result_D) ? 1'b1 : 1'b0) : RegWrite_D;
////////////////////////////////////////////////////////////////////////////////////////
assign RegWrite_D_new = RegWrite_D;


/***********************************    E    ***************************************/
assign D_CP0_addr = D_instr[15:11];
regE top_regE(
.clk(clk),
.reset(reset),
.req(req),
.clr(stall),
.D_V1(D_V1),
.D_V2(D_V2),
.D_A1(D_A1),
.D_A2(D_A2),
.D_A3(D_A3),
.D_CP0_addr(D_CP0_addr), // mtc0 mfc0 -> rd
.check_D(check_D),
.mf_D(mf_D),
.D_E32(D_E32),
.D_pc(D_pc),
.D_pc8(D_pc8),
.T_new_D(T_new_D),
.start_D(start_D),
.RegWrite_D(RegWrite_D_new),
.SelEMout_D(SelEMout_D),
.SelWout_D(SelWout_D),
.SelALUB_D(SelALUB_D),
.ALUOp_D(ALUOp_D),
.DMOp_D(DMOp_D),
.MDUOp_D(MDUOp_D),
.D_ExcCode_fixed(D_ExcCode_fixed),
.isAriOv_D(isAriOv_D),
.D_eret(D_eret),
.CP0_WE_D(CP0_WE_D),
.D_BD(D_BD),
.D_mfc0(D_mfc0),
.D_mtc0(D_mtc0),

.E_V1(E_V1),
.E_V2(E_V2),
.E_A1(E_A1),
.E_A2(E_A2),
.E_A3(E_A3),
.check_E(check_E),
.mf_E(mf_E),
.E_E32(E_E32),
.E_pc(E_pc),
.E_pc8(E_pc8),
.T_new_E(T_new_E),
.start_E(start_E),
.RegWrite_E(RegWrite_E),
.SelEMout_E(SelEMout_E),
.SelWout_E(SelWout_E),
.SelALUB_E(SelALUB_E),
.ALUOp_E(ALUOp_E),
.DMOp_E(DMOp_E),
.MDUOp_E(MDUOp_E),
.E_ExcCode(E_ExcCode),
.isAriOv_E(isAriOv_E),
.E_eret(E_eret),
.CP0_WE_E(CP0_WE_E),
.E_BD(E_BD),
.E_CP0_addr(E_CP0_addr),
.E_mfc0(E_mfc0),
.E_mtc0(E_mtc0)
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


ALU top_alu(
.src_A(E_V1_f),
.src_B(E_ALU_B),
.ALUOp(ALUOp_E),
.E_AO(E_AO),
.overflow(overflow_E)
);
////////////  E exception ///////////////////////////////////////////////////
localparam sw = 4'b0001;
localparam sh = 4'b0010;
localparam sb = 4'b0011;
localparam lw = 4'b1000;
localparam lh = 4'b1001;
localparam lb = 4'b1010;
assign E_ExcCode_fixed = (E_ExcCode) ? E_ExcCode : 
								 (overflow_E && (DMOp_E == sw || DMOp_E == sh || DMOp_E == sb)) ? ADES :
								 (overflow_E && (DMOp_E == lw || DMOp_E == lh || DMOp_E == lb)) ? ADEL :
								 (overflow_E && isAriOv_E) ? OV : NONE;
///////////////////////////////////////////////////////////////////////////////
MDU top_mdu(
.clk(clk),
.reset(reset),
.req(req),
.MDUOp(MDUOp_E),
.start(start_E),
.A(E_V1_f),
.B(E_V2_f),
.busy(busy_E),
.out(E_MDU_out)
);


MUX_E_out top_mux_e_out(
.E_E32(E_E32),
.E_pc8(E_pc8),
.SelEMout_E(SelEMout_E),
.E_out(E_out)
);

MUX_MDU_ALU top_mux_mdu_alu(
.ALU_out(E_AO),
.MDU_out(E_MDU_out),
.mf_E(mf_E),
.E_AO_new(E_AO_new)
);
/***********************************       M       ***********************************/
regM top_regM(
.clk(clk),
.reset(reset),
.req(req),
.E_AO(E_AO_new),
.E_V2(E_V2_f),
.E_A2(E_A2),
.E_A3(E_A3),
.check_E(check_E),
.E_pc(E_pc),
.E_pc8(E_pc8),
.T_new_E(T_new_E),
.RegWrite_E(RegWrite_E),
.SelEMout_E(SelEMout_E),
.SelWout_E(SelWout_E),
.DMOp_E(DMOp_E),
.E_ExcCode_fixed(E_ExcCode_fixed),
.E_eret(E_eret),
.CP0_WE_E(CP0_WE_E),
.E_BD(E_BD),
.E_CP0_addr(E_CP0_addr),
.E_mfc0(E_mfc0),
.E_mtc0(E_mtc0),

.M_AO(M_AO),
.M_V2(M_V2),
.M_A2(M_A2),
.M_A3(M_A3),
.check_M(check_M),
.M_pc(M_pc),
.M_pc8(M_pc8),
.T_new_M(T_new_M),
.RegWrite_M(RegWrite_M),
.SelEMout_M(SelEMout_M),
.SelWout_M(SelWout_M),
.DMOp_M(DMOp_M),
.M_ExcCode(M_ExcCode),
.M_eret(M_eret),
.CP0_WE_M(CP0_WE_M),
.M_BD(M_BD),
.M_CP0_addr(M_CP0_addr),
.M_mfc0(M_mfc0),
.M_mtc0(M_mtc0)
);
////////////// M exception ////////////////////////////////////////////////////////////
wire lhlb_tag = (DMOp_M == lh || DMOp_M == lb);
wire load_tag = (DMOp_M == lw || DMOp_M == lh || DMOp_M == lb);
wire shsb_tag = (DMOp_M == sh || DMOp_M == sb);
wire store_tag = (DMOp_M == sw || DMOp_M == sh || DMOp_M == sb);
wire timer_addr = (M_AO >= 32'h7f00 && M_AO <= 32'h7f0b) || (M_AO >= 32'h7f10 && M_AO <= 32'h7f1b);
wire dm_addr = (M_AO >= 32'h0000 && M_AO <= 32'h2fff);
wire interrupt_addr = (M_AO >= 32'h7f20 && M_AO <= 32'h7f23);

assign M_ExcCode_fixed = (M_ExcCode) ? M_ExcCode :
								 (DMOp_M == lw && (M_AO[1:0] != 2'b00)) ? ADEL :
								 (DMOp_M == lh && (M_AO[0] != 1'b0)) ? ADEL :
								 (lhlb_tag && timer_addr) ? ADEL :
								 (load_tag && !dm_addr && !timer_addr && !interrupt_addr) ? ADEL :
								 (DMOp_M == sw && (M_AO[1:0] != 2'b00)) ? ADES :
								 (DMOp_M == sh && (M_AO[0] != 1'b0)) ? ADES :
								 (shsb_tag && timer_addr) ? ADES :
								 (store_tag && timer_addr && M_AO[3:0] == 4'h8) ? ADES : 
								 (store_tag && !dm_addr && !timer_addr && !interrupt_addr) ? ADES : NONE;
								 
///////////////////////////////////////////////////////////////////////////////////////
HMUX_DM top_hmux_dm(
.M_V2(M_V2),
.W_out(W_out),
.FwdDM(FwdDM),
.M_V1_f(M_V1_f)
);
// save
BE top_be(
.address(M_AO),
.WD_in(M_V1_f),
.req(req),
.DMOp(DMOp_M),
.WD_out(m_data_wdata),
.byteen(m_data_byteen)
);
//load
DE top_de(
.address(M_AO),
.RD_in(m_data_rdata),
.DMOp(DMOp_M),
.RD_out(M_DR)
);

assign m_data_addr = M_AO;
assign m_inst_addr = M_pc;

MUX_M_out top_hux_m_out(
.M_AO(M_AO),
.M_pc8(M_pc8),
.SelEMout_M(SelEMout_M),
.M_out(M_out)
);

CP0 top_cp0 (
.clk(clk),
.reset(reset),
.WE(CP0_WE_M), // mtc0
.EXLClr(M_eret), // eret
.M_pc(M_pc), // global pc
.M_ExcCode(M_ExcCode_fixed),
.M_BD(M_BD),
.D_in(M_V1_f),
.A1(M_CP0_addr),
.A2(M_CP0_addr),
.req(req),
.D_out(M_CP0_out),
.HWInt(HWInt),
.EPC_out(M_EPC_out)
);

MUX_DM_CP0 top_mux_dm_cp0 (
.CP0_out(M_CP0_out),
.RD_out(M_DR),
.mfc0(M_mfc0),
.M_DR_new(M_DR_new)
);

///////////////////////////////////////////////////////////////////////////////////////
// class extend : condition load
//  wire [4:0] M_A3_new = (check_M) ? ((condition)? reg1 : reg2 ) : M_A3_new;
///////////////////////////////////////////////////////////////////////////////////////
wire [4:0] M_A3_new = M_A3;


/***********************************     W     ******************************************/
regW top_regW(
.clk(clk),
.reset(reset),
.req(req),
.M_AO(M_AO),
.M_DR(M_DR_new),
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
.D_eret(D_eret),
.E_A1(E_A1),
.E_A2(E_A2),
.E_A3(E_A3),
.E_mtc0(E_mtc0),
.E_CP0_addr(E_CP0_addr),
.check_E(check_E),
.M_A2(M_A2),
.M_A3(M_A3_new),
.check_M(check_M),
.M_mtc0(M_mtc0),
.M_CP0_addr(M_CP0_addr),
.W_A3(W_A3),
.RegWrite_E(RegWrite_E),
.RegWrite_M(RegWrite_M),
.RegWrite_W(RegWrite_W),
.T_rs_use(T_rs_use_D),
.T_rt_use(T_rt_use_D),
.T_new_E(T_new_E),
.T_new_M(T_new_M),
.T_new_W(T_new_W),
.MDUOp_D(MDUOp_D),
.start(start_E),
.busy(busy_E),
.FwdCMPD1(FwdCMPD1),
.FwdCMPD2(FwdCMPD2),
.FwdALUA(FwdALUA),
.FwdALUB(FwdALUB),
.FwdDM(FwdDM),
.stall(stall)
);

endmodule
