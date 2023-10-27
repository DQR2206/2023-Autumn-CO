`timescale 1ns / 1ps
module dotProduct (
    input [31:0] vector_a,
    input [31:0] vector_b,
    output [5:0] result
);
integer  i;
reg [5:0] Result;
always@(*)begin
    Result = 6'b0;
    for(i = 0;i<32;i=i+1)begin
        Result = Result + vector_a[i]*vector_b[i];
    end
end
assign result = Result;
endmodule
