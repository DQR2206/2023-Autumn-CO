module BlockChecker (
    input wire clk,
    input wire reset,
    input wire [7:0] in,
    output reg result
);

reg [31:0] begin_cnt;
reg [15:0] status;

`define S0 16'b0000_0000_0000_0001
`define S1 16'b0000_0000_0000_0010
`define S2 16'b0000_0000_0000_0100
`define S3 16'b0000_0000_0000_1000
`define S4 16'b0000_0000_0001_0000
`define S5 16'b0000_0000_0010_0000
`define S6 16'b0000_0000_0100_0000
`define S7 16'b0000_0000_1000_0000
`define S8 16'b0000_0001_0000_0000
`define S9 16'b0000_0010_0000_0000
`define S10 16'b0000_0100_0000_0000

	
`ifndef SYNTHESIS
  reg [11:0] state_string; // 40 bits = 5 byte
  always @ (*) begin
    case(status)
      2'b00000001: state_string = "s0";
      2'b00000010: state_string = "s1";
      2'b00000100: state_string = "s2";
      2'b00001000: state_string = "s3";
      default: state_string = "?????";
    endcase
  end
`endif

always @(posedge clk or posedge reset) begin
    if(reset)
    begin 
        begin_cnt <= 32'b0;
        status <= `S0;
        result <= 1'b1;
    end
    else 
    begin
        case (status)
            `S0:  //empty
            begin
                if(in == " ")
                begin
                    status <= `S0;
                end
                else if (in == "e"||in == "E")
                begin
                    status <= `S7;
                end
                else if (in == "b"||in == "B")
                begin
                    status <= `S1;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S1:   //b
            begin
                if(in == "e"||in == "E")
                begin
                    status <= `S2;
                end
                else if (in == " ")
                begin
                    status <= `S0;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S2:     //be
            begin
                if(in == "g"||in == "G")
                begin
                    status <= `S3;
                end
                else if (in == " ")
                begin
                    status <= `S0;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S3:   //beg
            begin
                if(in == "i"||in == "I")
                begin
                    status <= `S4;
                end
                 else if (in == " ")
                begin
                    status <= `S0;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S4: //begi
            begin
                if(in == "n"||in == "N")
                begin
                    status <= `S5;
                    result <= 1'b0;
                end
                 else if (in == " ")
                begin
                    status <= `S0;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S5:
            begin
                if(in == " ")
                begin
                    status <= `S0;
                    begin_cnt <= begin_cnt + 1;
                end
                else
                begin
                    status <= `S6;
                    if(begin_cnt == 32'b0000)
                    begin
                    result <= 1'b1;
                    end
                    else
                    begin
                    result <= result;
                    end
                end
            end
            `S6:
            begin
                if(in == " ")
                begin
                    status <= `S0;
                end
                else
                begin
                    status <= `S6;
                end
            end
            `S7:
            begin
                if(in == "n"||in =="N")
                begin
                    status <= `S8;
                end
                else if (in == " ")
                begin
                    status <= `S0;
                end
                else 
                begin
                    status <= `S6;
                end
            end
            `S8:
            begin
                if(in == "d"||in == "D")
                begin
                    if(begin_cnt == 32'b0001)  //只剩余一个begin 可以完成配对
                    begin
                        status <= `S9;
                        result <= 1'b1;
                    end
                    else
                    begin
                        status <= `S9;
                        result <= 1'b0;
                    end
                end
                 else if (in == " ")
                begin
                    status <= `S0;
                end
                else 
                begin
                    status <= `S6;
                end
            end
            `S9:
            begin
                if(in == " ")  //确定匹配到的一定是end
                begin
					if(begin_cnt == 32'b0)  //还没有出现过begin 这种情况无论后便出现什么都是0
                    begin
                        status <= `S10;
                        result <= 1'b0;
                    end
                    else if(begin_cnt == 32'b1)
                    begin
                        status <= `S0;
                        result <= 1'b1;
                        begin_cnt <= 32'b0000;
                    end
                    else if(begin_cnt > 32'b1)
                    begin
                        status <= `S0;
                        result <= 1'b0;
                        begin_cnt <= begin_cnt - 32'b0001;
                    end
                end
                else  //匹配到的不是end
                begin
                    status <= `S6;
                    if(begin_cnt==32'b0)
                    begin
                        result <= 1'b1;
                    end
                    else
                    begin
                        result <= 1'b0;
                    end
                end
            end
            `S10:
            begin
                status <= `S10;
                result <=  1'b0;
            end
            default: 
            begin
                status <= status;
                result <= result;
            end
        endcase
    end
end
endmodule