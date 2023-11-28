`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:12:29 11/13/2023 
// Design Name: 
// Module Name:    HCU 
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
// 
module HCU(
input wire [4:0] D_A1,
input wire [4:0] D_A2,
input wire [4:0] E_A1,
input wire [4:0] E_A2,
input wire [4:0] E_A3,
input check_E,
input wire [4:0] M_A2,
input wire [4:0] M_A3,
input check_M,
input wire [4:0] W_A3,
input wire RegWrite_E,
input wire RegWrite_M,
input wire RegWrite_W,
input wire [1:0] T_rs_use,
input wire [1:0] T_rt_use,
input wire [1:0] T_new_E,
input wire [1:0] T_new_M,
input wire [1:0] T_new_W,
output wire [1:0] FwdCMPD1,
output wire [1:0] FwdCMPD2,
output wire [1:0] FwdALUA,
output wire [1:0] FwdALUB,
output wire FwdDM,
output wire stall
     );
//stall
wire stall_rs0_e2 = (T_rs_use == 2'b00)&&(T_new_E == 2'b10)&&((check_E) ? 1'b1 : D_A1 == E_A3)&&(D_A1 != 5'b0)&&(RegWrite_E);
wire stall_rs0_e1 = (T_rs_use == 2'b00)&&(T_new_E == 2'b01)&&((check_E) ? 1'b1 : D_A1 == E_A3)&&(D_A1 != 5'b0)&&(RegWrite_E);
wire stall_rs0_m1 = (T_rs_use == 2'b00)&&(T_new_M == 2'b01)&&((check_M) ? 1'b1 : D_A1 == M_A3)&&(D_A1 != 5'b0)&&(RegWrite_M);
wire stall_rs1_e2 = (T_rs_use == 2'b01)&&(T_new_E == 2'b10)&&((check_E) ? 1'b1 : D_A1 == E_A3)&&(D_A1 != 5'b0)&&(RegWrite_E);
wire stall_rs = stall_rs0_e2 | stall_rs0_e1 | stall_rs0_m1 | stall_rs1_e2;
wire stall_rt0_e2 = (T_rt_use == 2'b00)&&(T_new_E == 2'b10)&&((check_E) ? 1'b1 : D_A2 == E_A3)&&(D_A2 != 5'b0)&&(RegWrite_E);
wire stall_rt0_e1 = (T_rt_use == 2'b00)&&(T_new_E == 2'b01)&&((check_E) ? 1'b1 : D_A2 == E_A3)&&(D_A2 != 5'b0)&&(RegWrite_E);
wire stall_rt0_m1 = (T_rt_use == 2'b00)&&(T_new_M == 2'b01)&&((check_M) ? 1'b1 : D_A2 == M_A3)&&(D_A2 != 5'b0)&&(RegWrite_M);
wire stall_rt1_e2 = (T_rt_use == 2'b01)&&(T_new_E == 2'b10)&&((check_E) ? 1'b1 : D_A2 == E_A3)&&(D_A2 != 5'b0)&&(RegWrite_E);
wire stall_rt = stall_rt0_e2 | stall_rt0_e1 | stall_rt0_m1 | stall_rt1_e2;
assign stall = stall_rs | stall_rt;
//forward
assign FwdCMPD1 = (T_new_E == 2'b00)&&(E_A3 == D_A1)&&(D_A1 != 5'b0)&&(RegWrite_E) ? 2'b10 :
						(T_new_M == 2'b00)&&(M_A3 == D_A1)&&(D_A1 != 5'b0)&&(RegWrite_M) ? 2'b01 :
						2'b00;
assign FwdCMPD2 = (T_new_E == 2'b00)&&(E_A3 == D_A2)&&(D_A2 != 5'b0)&&(RegWrite_E) ? 2'b10 :
						(T_new_M == 2'b00)&&(M_A3 == D_A2)&&(D_A2 != 5'b0)&&(RegWrite_M) ? 2'b01 :
						2'b00;
assign FwdALUA = (T_new_M == 2'b00)&&(M_A3 == E_A1)&&(E_A1 != 5'b0)&&(RegWrite_M) ? 2'b10 :
					  (T_new_W == 2'b00)&&(W_A3 == E_A1)&&(E_A1 != 5'b0)&&(RegWrite_W) ? 2'b01 :
					   2'b00;
assign FwdALUB = (T_new_M == 2'b00)&&(M_A3 == E_A2)&&(E_A2 != 5'b0)&&(RegWrite_M) ? 2'b10 :
					  (T_new_W == 2'b00)&&(W_A3 == E_A2)&&(E_A2 != 5'b0)&&(RegWrite_W) ? 2'b01 :
					   2'b00;
assign FwdDM = (T_new_W == 2'b00)&&(W_A3 == M_A2)&&(M_A2 != 5'b0)&&(RegWrite_W) ? 1'b1 : 1'b0;
endmodule
