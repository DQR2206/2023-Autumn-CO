`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:00 11/09/2023 
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
// top 
module mips (
input clk,
input reset //reset为同步复位信号
);

wire if_branch,MemtoReg,MemWrite,ALUSrc,RegWrite,EXTOp,RegDst,PCtoReg,ralink,shiftvar,flowjudge,Branch;
wire [2:0] branchOp,NPCOp;
wire [3:0] LSOp,ALUOp;
wire [4:0] rs,rt,rd,shamt,r0,RegAddr,shift;
wire [5:0] opcode,funct;
wire [15:0] imm;
wire [25:0] j_address;
wire [31:0] npc,pc,instr,reg_address,offset,PC_Add_Four,data0,RegData,DatatoSrcB,DMdata,readdata1,readdata2,ALUresult;

IS top_is(
    .instr(instr),
    .opcode(opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .shamt(shamt),
    .funct(funct),
    .imm(imm),
    .address(j_address)
);

Controller top_controller(
    .opcode(opcode),
    .funct(funct),
    .MemtoReg(MemtoReg),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .EXTOp(EXTOp),
    .RegDst(RegDst),
    .PCtoReg(PCtoReg),
    .ralink(ralink),
    .shiftvar(shiftvar),
    .flowjudge(flowjudge),
    .Branch(Branch),
    .branchOp(branchOp),
    .NPCOp(NPCOp),
    .ALUOp(ALUOp),
    .LSOp(LSOp)
);

IFU top_ifu(
    .clk(clk),
    .reset(reset),
    .npc(npc),
    .pc(pc),
    .instr(instr)
);


EXT  top_ext(
    .imm(imm),
    .EXTOp(EXTOp),
    .imm_32(offset)
);

NPC top_npc(
    .pc(pc),
    .offset(offset),
    .j_address(j_address),
    .reg_address(readdata1),
    .if_branch(if_branch),
    .NPCOp(NPCOp),
    .npc(npc),
    .PC_Add_Four(PC_Add_Four)
);

//选择寄存器写入地址

selTorD top_selTorD(
    .rt(rt),
    .rd(rd),
    .RegDst(RegDst),
    .r0(r0)
);

selR0orRA top_selR0(
    .r0(r0),
    .ralink(ralink),
    .RegAddr(RegAddr)
);

//选择寄存器写入数据

ALUorDM top_ALUorDM(
    .ALUresult(ALUresult),
    .DMdata(DMdata),
    .MemtoReg(MemtoReg),
    .data0(data0)
);

data0orPC top_data0orPC(
    .data0(data0),
    .pc(PC_Add_Four), //PC+4地址
    .PCtoReg(PCtoReg),
    .RegData(RegData)
);

GRF top_grf(
    .clk(clk),
    .reset(reset),
    .rs(rs),
    .rt(rt),
    .rd(RegAddr),
    .RegWrite(RegWrite),
    .writedata(RegData),
	 .pc(pc),
    .readdata1(readdata1),
    .readdata2(readdata2)
);


//选择ALU src_B

ALUsrc_B top_ALUsrc_B(
    .readdata2(readdata2),
    .offset(offset),
    .ALUSrc(ALUSrc),
    .DatatoSrcB(DatatoSrcB)
);

//选择移位

RegorShamt top_RegorShamt(
    .shamt(shamt),
    .readdata1(readdata1),
    .shiftvar(shiftvar),
    .shift(shift)
);

ALU top_alu(
.src_A(readdata1),
.src_B(DatatoSrcB),
.ALUOp(ALUOp),
.shamt(shift),
.flowjudge(flowjudge),
.equal(equal),
.overflow(overflow),
.result(ALUresult)
);

DM top_dm(
    .clk(clk),
    .reset(reset),
    .MemWrite(MemWrite),
    .LSOp(LSOp),
	 .pc(pc),
    .address(ALUresult),
    .datawrite(readdata2),
    .dataread(DMdata)
);

SelectB top_SelectB(
    .data(readdata1),
    .judge(rt),
    .equal(equal),
    .Branch(Branch),
    .branchOp(branchOp),
    .result(if_branch)
);


endmodule