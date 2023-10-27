
//WARNING:HDLCompiler:327 - "/opt/application/Grader/testfiles/22373362/557049_ext.v" Line 7: Concatenation with unsized literal; will interpret as 32 bits
module ext (
    input [15:0] imm,
    input [1:0] EOp,
    output [31:0] ext
);
wire [31:0] sign_extend = {{16{imm[15]}} , imm};
wire [31:0] zero_extend = {{16{1'b0}} , imm};
wire [31:0] move_high = {imm, {16{1'b0}}};
wire [31:0] left_shift = sign_extend << 2'b10;

assign ext = (EOp == 2'b00) ? sign_extend:
             (EOp == 2'b01) ? zero_extend:
             (EOp == 2'b10) ? move_high:
             left_shift;
endmodule