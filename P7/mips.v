`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:29 12/06/2023 
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
// top-mips-system
module mips(
    input clk,                    // ʱ���ź�
    input reset,                  // ͬ����λ�ź�
    input interrupt,              // �ⲿ�ж��ź�
    output [31:0] macroscopic_pc, // ��� PC

    output [31:0] i_inst_addr,    // IM ��ȡ��ַ��ȡָ PC��
    input  [31:0] i_inst_rdata,   // IM ��ȡ����

    output [31:0] m_data_addr,    // DM ��д��ַ
    input  [31:0] m_data_rdata,   // DM ��ȡ����
    output [31:0] m_data_wdata,   // DM ��д������
    output [3 :0] m_data_byteen,  // DM �ֽ�ʹ���ź�

    output [31:0] m_int_addr,     // �жϷ�������д���ַ
    output [3 :0] m_int_byteen,   // �жϷ������ֽ�ʹ���ź�

    output [31:0] m_inst_addr,    // M �� PC

    output w_grf_we,              // GRF дʹ���ź�
    output [4 :0] w_grf_addr,     // GRF ��д��Ĵ������
    output [31:0] w_grf_wdata,    // GRF ��д������

    output [31:0] w_inst_addr     // W �� PC
);

wire IRQ0,IRQ1;
wire [5:0] HWInt = {3'b0,interrupt,IRQ1,IRQ0};

wire T0_WE,T1_WE;
wire [3:0] DM_WE;
wire [31:0] T0_RD,T1_RD;
wire [31:0] Addr_out,WD_out,RD_out;

cpu top_cpu(
.clk(clk),
.reset(reset),
.HWInt(HWInt),
.i_inst_addr(i_inst_addr),
.i_inst_rdata(i_inst_rdata),
.m_data_addr(m_data_addr),
.m_data_rdata(RD_out),
.m_data_wdata(m_data_wdata),
.m_data_byteen(m_data_byteen),
.m_inst_addr(m_inst_addr),
.w_grf_we(w_grf_we),
.w_grf_addr(w_grf_addr),
.w_grf_wdata(w_grf_wdata),
.w_inst_addr(w_inst_addr)
);

assign macroscopic_pc = m_inst_addr;
assign m_int_addr = m_data_addr;
assign m_int_byteen = m_data_byteen;

Bridge top_bridge(
.Addr_in(m_data_addr),
.WD_in(m_data_wdata),
.byteen(m_data_byteen),
.DM_RD(m_data_rdata),
.T0_RD(T0_RD),
.T1_RD(T1_RD),
.Addr_out(Addr_out),
.WD_out(WD_out),
.RD_out(RD_out),
.DM_WE(DM_WE),
.T0_WE(T0_WE),
.T1_WE(T1_WE)
);

TC top_tc0(
.clk(clk),
.reset(reset),
.Addr(Addr_out[31:2]),
.WE(T0_WE),
.Din(WD_out),
.Dout(T0_RD),
.IRQ(IRQ0)
);


TC top_tc1(
.clk(clk),
.reset(reset),
.Addr(Addr_out[31:2]),
.WE(T1_WE),
.Din(WD_out),
.Dout(T1_RD),
.IRQ(IRQ1)
);
endmodule
