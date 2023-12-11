`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:27:07 12/05/2023 
// Design Name: 
// Module Name:    Bridge 
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
module Bridge(
input wire [31:0] Addr_in,
input wire [31:0] WD_in,
input wire [3:0] byteen,
input wire [31:0] DM_RD,
input wire [31:0] T0_RD,
input wire [31:0] T1_RD,
output wire [31:0] Addr_out,
output wire [31:0] WD_out,
output wire [31:0] RD_out,
output wire [3:0] DM_WE,
output wire T0_WE,
output wire T1_WE
    );

assign Addr_out = Addr_in;
assign WD_out = WD_in;

wire DM_addr = (Addr_in >= 32'h0000 && Addr_in <= 32'h2fff);
wire T0_addr = (Addr_in >= 32'h7f00 && Addr_in <= 32'h7f0b);
wire T1_addr = (Addr_in >= 32'h7f10 && Addr_in <= 32'h7f1b); 

assign DM_WE = (DM_addr) ? byteen : 4'b0;
assign T0_WE = (T0_addr) ? &byteen : 1'b0;
assign T1_WE = (T1_addr) ? &byteen : 1'b0;

assign RD_out = (DM_addr) ? DM_RD :
					 (T0_addr) ? T0_RD :
					 (T1_addr) ? T1_RD :
					 32'b0;
endmodule
