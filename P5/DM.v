`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:05:26 11/15/2023 
// Design Name: 
// Module Name:    DM 
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
module DM(
input wire clk,
input wire reset,
input wire MemWrite_M,
input wire [31:0] address,
input wire [31:0] datawrite,
input wire [31:0] M_pc,
input wire [2:0] DMOp_M,
output reg [31:0] dataread
    );

reg [31:0] RAM [0:3071]; 
wire [31:0] tmp = RAM[address[31:2]];

// DMOp[2] == 0 s_instr  DMOp[2] == 1 l_instr
//write to RAM
integer i = 0;
always@(posedge clk) begin
	if(reset) begin
		for(i = 0;i < 3072;i = i + 1)begin
		RAM[i] <= 32'b0;
		end
	end
	else if(MemWrite_M) begin
	case(DMOp_M)
	3'b000: //sw
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, datawrite);
	RAM[address[13:2]] <= datawrite;
	end
	3'b001: //sh
	begin
	case(address[1])
	1'b0:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {tmp[31:16],datawrite[15:0]});
	RAM[address[13:2]] <= {tmp[31:16],datawrite[15:0]};
	end
	1'b1:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {datawrite[15:0],tmp[15:0]});
	RAM[address[13:2]] <= {datawrite[15:0],tmp[15:0]};
	end
	endcase
	end
	3'b010: //sb
	begin
	case(address[1:0])
	2'b00:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {tmp[31:8],datawrite[7:0]});
	RAM[address[13:2]] <= {tmp[31:8],datawrite[7:0]};
	end
	2'b01:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {tmp[31:16],datawrite[7:0],tmp[7:0]});
	RAM[address[13:2]] <= {tmp[31:16],datawrite[7:0],tmp[7:0]};
	end
	2'b10:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {tmp[31:24],datawrite[7:0],tmp[15:0]});
	RAM[address[13:2]] <= {tmp[31:24],datawrite[7:0],tmp[15:0]};
	end
	2'b11:
	begin
	$display("%d@%h: *%h <= %h", $time, M_pc, address, {datawrite[7:0],tmp[23:0]});
	RAM[address[13:2]] <= {datawrite[7:0],tmp[23:0]};
	end
	endcase
	end
	default : RAM[address[13:2]] <= datawrite;
	endcase
	end
end
//read from RAM
always@(*)begin
	case(DMOp_M)
	3'b100: dataread = tmp;  //lw
	3'b101: // lh
	begin
	case(address[1])
	1'b0: dataread = {{16{tmp[15]}},tmp[15:0]};
	1'b1: dataread = {{16{tmp[31]}},tmp[31:16]};
	endcase
	end
	3'b110: // lb
	begin
	case(address[1:0])
	2'b00: dataread = {{24{tmp[7]}},tmp[7:0]};
	2'b01: dataread = {{24{tmp[15]}},tmp[15:8]};
	2'b10: dataread = {{24{tmp[23]}},tmp[23:16]};
	2'b11: dataread = {{24{tmp[31]}},tmp[31:24]};
	endcase
	end
	default : dataread = tmp;
	endcase
end
endmodule
