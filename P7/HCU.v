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
input wire D_eret,
input wire [4:0] E_A1,
input wire [4:0] E_A2,
input wire [4:0] E_A3,
input wire E_mtc0,
input wire [4:0] E_CP0_addr,
input check_E,  // class extend 
input wire [4:0] M_A2,
input wire [4:0] M_A3,
input wire M_mtc0,
input wire [4:0] M_CP0_addr,
input check_M,  // class extend
input wire [4:0] W_A3,
input wire RegWrite_E,
input wire RegWrite_M,
input wire RegWrite_W,
input wire [1:0] T_rs_use,
input wire [1:0] T_rt_use,
input wire [1:0] T_new_E,
input wire [1:0] T_new_M,
input wire [1:0] T_new_W,
input wire [3:0] MDUOp_D,
input wire start,
input wire busy,
output wire [1:0] FwdCMPD1,
output wire [1:0] FwdCMPD2,
output wire [1:0] FwdALUA,
output wire [1:0] FwdALUB,
output wire FwdDM,
output wire stall
     );
//stall
wire stall_eret = (D_eret)&&((E_mtc0 && E_CP0_addr == 5'd14) | (M_mtc0 && M_CP0_addr == 5'd14));
wire stall_rs_e = (T_rs_use < T_new_E)&&(D_A1 == E_A3)&&(D_A1 != 5'b0)&&(RegWrite_E);
wire stall_rs_m = (T_rs_use < T_new_M)&&(D_A1 == M_A3)&&(D_A1 != 5'b0)&&(RegWrite_M);
wire stall_rs = stall_rs_e | stall_rs_m ;
wire stall_rt_e = (T_rt_use < T_new_E)&&(D_A2 == E_A3)&&(D_A2 != 5'b0)&&(RegWrite_E);
wire stall_rt_m = (T_rt_use < T_new_M)&&(D_A2 == M_A3)&&(D_A2 != 5'b0)&&(RegWrite_M);
wire stall_rt = stall_rt_e | stall_rt_m ;
wire stall_mdu = (MDUOp_D != 4'b0000)&&(busy | start);
assign stall = stall_rs | stall_rt | stall_mdu | stall_eret;
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
