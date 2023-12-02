`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:36:25 11/15/2023 
// Design Name: 
// Module Name:    MUX 
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

module MUX_MDU_ALU(
input wire [31:0] ALU_out,
input wire [31:0] MDU_out,
input wire mf_E,
output [31:0] E_AO_new
);
assign E_AO_new = (mf_E)? MDU_out : ALU_out;
endmodule

module MUX_A3(
input wire [4:0] D_instr_rt,
input wire [4:0] D_instr_rd,
input wire [1:0] SelA3_D,
output wire [4:0] D_A3
    );
assign D_A3 = (SelA3_D == 2'b10) ? 5'b11111 :
				  (SelA3_D == 2'b01) ? D_instr_rd :
				  D_instr_rt;
endmodule

module MUX_ALU_B(
input [31:0] E_V2_f,
input [31:0] E_E32,
input wire SelALUB_E,
output wire [31:0] E_ALU_B 
);
assign E_ALU_B = (SelALUB_E) ? E_E32 : E_V2_f;
endmodule

module MUX_ALU_S(
input [4:0] E_shamt,
input [4:0] E_V1_f_shamt,
input SelALUS_E, 
output [4:0] E_shamt_f
);
assign E_shamt_f = (SelALUS_E == 1'b1) ? E_V1_f_shamt : E_shamt;
endmodule

module MUX_E_out(
input [31:0] E_E32,
input [31:0] E_pc8,
input wire SelEMout_E,
output wire [31:0] E_out
);
assign E_out = (SelEMout_E) ? E_pc8 : E_E32;
endmodule

module MUX_M_out(
input [31:0] M_AO,
input [31:0] M_pc8,
input wire SelEMout_M,
output wire [31:0] M_out
);
assign M_out = (SelEMout_M) ? M_pc8 : M_AO;
endmodule

module MUX_W_out(
input [31:0] W_AO,
input [31:0] W_DR,
input [31:0] W_pc8,
input [1:0] SelWout_W,
output [31:0] W_out
);
assign W_out = (SelWout_W == 2'b10) ? W_pc8 :
					(SelWout_W == 2'b01) ? W_DR :
					W_AO;
endmodule

module HMUX_CMP_D1(
input [31:0] GRF_RD1,
input [31:0] M_out,
input [31:0] E_out,
input [1:0] FwdCMPD1,
output [31:0] D_V1_f
);
assign D_V1_f = (FwdCMPD1 == 2'b10) ? E_out :
					 (FwdCMPD1 == 2'b01) ? M_out :
					 GRF_RD1;
endmodule

module HMUX_CMP_D2(
input [31:0] GRF_RD2,
input [31:0] M_out,
input [31:0] E_out,
input [1:0] FwdCMPD2,
output [31:0] D_V2_f
);
assign D_V2_f = (FwdCMPD2 == 2'b10) ? E_out :
					 (FwdCMPD2 == 2'b01) ? M_out :
					 GRF_RD2;
endmodule

module HMUX_ALU_A(
input [31:0] E_V1,
input [31:0] W_out,
input [31:0] M_out,
input [1:0] FwdALUA,
output [31:0] E_V1_f
);
assign E_V1_f = (FwdALUA == 2'b10) ? M_out :
					 (FwdALUA == 2'b01) ? W_out :
					 E_V1;
endmodule

module HMUX_ALU_B(
input [31:0] E_V2,
input [31:0] W_out,
input [31:0] M_out,
input [1:0] FwdALUB,
output [31:0] E_V2_f
);
assign E_V2_f = (FwdALUB == 2'b10) ? M_out :
					  (FwdALUB == 2'b01) ? W_out :
					  E_V2;
endmodule


module HMUX_DM(
input [31:0] M_V2,
input [31:0] W_out,
input FwdDM,
output [31:0] M_V1_f
);
assign M_V1_f = (FwdDM) ? W_out : M_V2;	
endmodule

module HMUX_NPC(
input [31:0] GRF_RD1,
input [31:0] M_out,
input [31:0] E_out,
input [1:0] FwdCMPD1,
output [31:0] D_RA_f
);
assign D_RA_f  = (FwdCMPD1 == 2'b10) ? E_out :
					 (FwdCMPD1 == 2'b01) ? M_out :
					 GRF_RD1;
endmodule
