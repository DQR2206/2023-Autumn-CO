`timescale 1ns/1ns

module comparator_4(
	input [3:0] A,
	input [3:0]	B,
 	output wire	Y2, //A>B
	output wire Y1, //A=B
    output wire Y0//A<B
);
reg y2;
reg y1;
reg y0;
always@(*)begin
	y2 = 1'b0;  //此题需要注意的是一定要为寄存器赋初值0，第一次WA就是因为没有将初值设置为0
	y1 = 1'b0;
	y0 = 1'b0;
	if(A[3]>B[3])
	y2 = 1'b1;
	else if (A[3]<B[3])
	y0 = 1'b1;
	else 
	begin
		if(A[2]>B[2])
		y2 = 1'b1;
		else if (A[2]<B[2])
		y0 = 1'b1;
		else
		begin
			if(A[1]>B[1])
			y2 = 1'b1;
			else if(A[1]<B[1])
			y0 = 1'b1;
			else
			begin
				if(A[0]>B[0])
				y2 = 1'b1;
				else if(A[0]<B[0])
				y0 = 1'b1;
				else
				y1 = 1'b1;
			end
		end
	end
end
assign Y2 = y2;
assign Y1 = y1;
assign Y0 = y0;
endmodule