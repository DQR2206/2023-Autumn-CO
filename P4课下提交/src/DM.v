`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:59:28 11/09/2023 
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
//要求的容量为12KB 3072*32bit
module DM(
input clk,
input reset,
input MemWrite,
input [3:0] LSOp,  //w h b
input [31:0] address,
input [31:0] datawrite,
input [31:0] pc,
output reg [31:0] dataread
);

reg [31:0] RAM [0:3071];

localparam sw = 4'b0000;
localparam sh = 4'b0001;
localparam sb = 4'b0010;
localparam lw = 4'b0011;
localparam lh = 4'b0100;
localparam lb = 4'b0101;

//读出该地址处存储的数据

wire [31:0] tmp = RAM[address[13:2]];

// write to RAM   s
integer i = 0;
always@(posedge clk) begin
    if(reset) begin
        for(i = 0 ; i < 3072 ; i = i + 1) begin
            RAM[i] <= 32'b0;
        end
    end
    else if (MemWrite && !reset) begin
	 case(LSOp)
	 
	 sw : 
	 begin
			RAM[address[13:2]] <= datawrite;
			$display("@%h: *%h <= %h",pc,address,datawrite);
	 end
	 
	 sh :
	 begin
	 case(address[1])
	 1'b1: 
	 begin
			RAM[address[13:2]] <= {datawrite[15:0],tmp[15:0]};
			$display("@%h: *%h <= %h",pc,address,{datawrite[15:0],tmp[15:0]});
	 end
	 default: 
	 begin
			RAM[address[13:2]] <= {tmp[31:16],datawrite[15:0]};
			$display("@%h: *%h <= %h",pc,address,{tmp[31:16],datawrite[15:0]});
	 end
	 endcase
	 end
   
	 default :  
	 begin
	 case(address[1:0])
	 2'b00 : 
	 begin
			RAM[address[13:2]] <= {tmp[31:8],datawrite[7:0]};
			$display("@%h: *%h <= %h",pc,address,{tmp[31:8],datawrite[7:0]});
	 end
	 2'b01:
	 begin
			RAM[address[13:2]] <= {tmp[31:16],datawrite[7:0],tmp[7:0]};
			$display("@%h: *%h <= %h",pc,address,{tmp[31:16],datawrite[7:0],tmp[7:0]});
	 end
	 2'b10 : 
	 begin
			RAM[address[13:2]] <= {tmp[31:24],datawrite[7:0],tmp[15:0]};
			$display("@%h: *%h <= %h",pc,address,{tmp[31:24],datawrite[7:0],tmp[15:0]});
	 end
	 default : 
	 begin
			RAM[address[13:2]] <= {datawrite[7:0],tmp[23:0]};
			$display("@%h: *%h <= %h",pc,address,{datawrite[7:0],tmp[23:0]});
	 end
	 endcase
	 end
	 
	 endcase
	 end
	 
end

//read from RAM  l
always@(*)begin
	case(LSOp)
	lw : dataread = tmp;
	lh : dataread  = (address[1] == 1'b0) ? {{16{tmp[15]}},tmp[15:0]} : {{16{tmp[31]}},tmp[31:16]};
	default : dataread = (address[1:0] == 2'b00) ? {{24{tmp[7]}},tmp[7:0]} :
								(address[1:0] == 2'b01) ? {{24{tmp[15]}},tmp[15:8]} :
								(address[1:0] == 2'b10) ? {{24{tmp[23]}},tmp[23:16]} :
								{{24{tmp[31]}},tmp[31:24]};
	endcase 
end

endmodule