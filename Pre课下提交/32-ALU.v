`timescale 1ns/1ps
module 32-ALU (
  input [31:0] a,
  input [31:0] b,
  input [1:0] op,
  input clk,
  input ena,
  output reg [31:0] ans 
);
wire [31:0] d;
assign d = (op == 0) ? a + b :
           (op == 1) ? a-b :
           (op == 2) ? a&b :
                      a | b;
always @(posedge clk) begin
  if(ena)
  begin
    c<=d;
  end
  else 
  begin
    c<=c;
  end
end
endmodule