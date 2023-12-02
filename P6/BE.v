`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:34:04 11/28/2023 
// Design Name: 
// Module Name:    BE 
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
module BE(
input [31:0] address,
input [3:0] DMOp,
input [31:0] WD_in,
output reg [3:0] byteen,
output reg [31:0] WD_out
    );
localparam sw = 4'b0001;
localparam sh = 4'b0010;
localparam sb = 4'b0011;
always@(*)begin
	case(DMOp)
	sw:
	begin
	byteen = 4'b1111;
	WD_out = WD_in;
	end
	sh:
	begin
	case(address[1])
	1'b0:
	begin
	byteen = 4'b0011;
	WD_out = {16'b0,WD_in[15:0]};
	end
	1'b1:
	begin
	byteen = 4'b1100;
	WD_out = {WD_in[15:0],16'b0};
	end
	endcase
	end
	sb:
	begin
	case(address[1:0])
	2'b00:
	begin
	byteen = 4'b0001;
	WD_out = {24'b0,WD_in[7:0]};
	end
	2'b01:
	begin
	byteen = 4'b0010;
	WD_out = {16'b0,WD_in[7:0],8'b0};
	end
	2'b10:
	begin
	byteen = 4'b0100;
	WD_out = {8'b0,WD_in[7:0],16'b0};
	end
	2'b11:
	begin
	byteen = 4'b1000;
	WD_out = {WD_in[7:0],24'b0};
	end
	endcase
	end
	default:
	begin
	byteen = 4'b0000;
	WD_out = 32'b0;
	end
	endcase
end

endmodule
