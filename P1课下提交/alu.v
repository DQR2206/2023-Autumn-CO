module alu (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output [31:0] C
);

wire [31:0] add = A + B;
wire [31:0] sub = A - B;
wire [31:0] with = A & B;
wire [31:0] huo = A | B;
wire [31:0] logic_shift = A >> B;
wire [31:0] math_shift = $signed(A) >>> B;

    assign C = (ALUOp == 3'b000) ? add:
               (ALUOp == 3'b001) ? sub:
               (ALUOp == 3'b010) ? with:
               (ALUOp == 3'b011) ? huo:
               (ALUOp == 3'b100) ? logic_shift:
               (ALUOp == 3'b101) ? math_shift:
                32'b000;
endmodule
