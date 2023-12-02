`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:33:44 11/28/2023 
// Design Name: 
// Module Name:    MDU 
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
module MDU(
input wire clk,
input wire reset,
input wire start,
input wire [3:0] MDUOp,
input wire [31:0] A,
input wire [31:0] B,
output wire [31:0] out,
output reg busy
    );
	 
localparam nop = 4'b0000;
localparam mult = 4'b0001;
localparam multu = 4'b0010;
localparam div = 4'b0011;
localparam divu = 4'b0100;
localparam mfhi = 4'b0101;
localparam mflo = 4'b0110;
localparam mthi = 4'b0111;
localparam mtlo = 4'b1000;

// mult is 5T
// div is 10T
// div : lo is rs div rt 
//       hi is rs mod rt
reg [31:0] HI;
reg [31:0] LO;
reg [31:0] tmpHI;
reg [31:0] tmpLO;
reg [31:0] cnt;
reg [31:0] delay; 


// counter 
always@(posedge clk)begin
	if(reset)begin
		cnt <= 32'b0;
		busy <= 1'b0;
	end
	else if(start)begin   //start claculate
		busy <= 1'b1;
	end
	else if(busy) begin
		if(cnt == delay - 1)begin  //next T : busy = 0
			cnt <= 32'b0;
			busy <= 1'b0;
		end
		else begin
			cnt <= cnt + 1'b1;
		end
	end
end


always@(posedge clk)begin
	if(reset)begin
		tmpHI <= 32'b0;
		tmpLO <= 32'b0;
		HI <= 32'b0;
		LO <= 32'b0;
	end
	else  begin
	if (!busy) begin
		case(MDUOp)
		mult :
		begin
			delay <= 4'b0101; //5
			{tmpHI,tmpLO} <= $signed(A) * $signed(B); 
		end
		multu :
		begin
			delay <= 4'b0101;
			{tmpHI,tmpLO} <= $unsigned(A) * $unsigned(B);
		end
		div :
		begin
			delay <= 4'b1010; //10
			tmpLO <= $signed(A) / $signed(B);
			tmpHI <= $signed(A) % $signed(B);
		end
		divu :
		begin
			delay <= 4'b1010;
			tmpLO <= $unsigned(A) / $unsigned(B);
			tmpHI <= $unsigned(A) % $unsigned(B);
		end
		mthi : HI <= A;
		mtlo : LO <= A;
		endcase
	end
	else begin
		if(cnt == delay - 1'b1)begin  // next T : busy = 0;
			HI <= tmpHI;
			LO <= tmpLO;
		end
		else begin
			HI <= HI;
			LO <= LO;
		end
	end
	end
end

assign out = (MDUOp == mfhi)? HI :
				 (MDUOp == mflo)? LO :
				 32'b0;
endmodule
