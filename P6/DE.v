`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:15 11/28/2023 
// Design Name: 
// Module Name:    DE 
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
module DE(
input wire [31:0] address,
input wire [3:0] DMOp,
input wire [31:0] RD_in,
output reg [31:0] RD_out
    );
localparam lw = 4'b1000;
localparam lh = 4'b1001;
localparam lb = 4'b1010;
always@(*)begin
	case(DMOp)
	lw : RD_out = RD_in;
	lh :
	begin
	case(address[1])
	1'b0 : RD_out = {{16{RD_in[15]}},RD_in[15:0]};
	1'b1 : RD_out = {{16{RD_in[31]}},RD_in[31:16]};
	endcase
	end
	lb :
	begin
	case(address[1:0])
	2'b00 : RD_out = {{24{RD_in[7]}},RD_in[7:0]}; 
	2'b01 : RD_out = {{24{RD_in[15]}},RD_in[15:8]};
	2'b10 : RD_out = {{24{RD_in[23]}},RD_in[23:16]};
	2'b11 : RD_out = {{24{RD_in[31]}},RD_in[31:24]};
	endcase
	end
	endcase
end

endmodule
