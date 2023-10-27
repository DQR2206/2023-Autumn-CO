module expr (
    input wire clk,
    input wire clr,
    input wire [7:0] in,
    output reg out
);

localparam S0 = 5'b00001,
           S1 = 5'b00010,
           S2 = 5'b00100,
           S3 = 5'b01000,
           S4 = 5'b10000;

reg [4:0] status;
`ifndef SYNTHESIS
  reg [11:0] state_string; // 40 bits = 5 byte
  always @ (*) begin
    case(status)
      5'b00001: state_string = "s0";
      5'b00010: state_string = "s1";
      5'b00100: state_string = "s2";
      5'b01000: state_string = "s3";
      5'b10000: state_string = "s4";
      default: state_string = "?????";
    endcase
  end
`endif
always @(posedge clk or posedge clr) begin
    if(clr)
    begin
        status <=  S0;
        out <= 1'b0;
    end
    else
    begin
        case (status)
        S0:
            begin
                if(in >= "0" && in <= "9")
                begin
                    status <= S1;
                    out <= 1'b1;
                end
                else
                begin
                    status <= S4;
                    out <= 1'b0;
                end
            end
        S1:
            begin
                if(in >= "0" && in <= "9")
                begin
                    status <= S3;
                    out <= 1'b0;
                end
                else 
                begin
                    status <= S2;
                    out <= 1'b0;
                end
            end
        S2:
            begin
                if(in >= "0" && in <= "9")
                begin
                    status <= S1;
                    out <= 1'b1;
                end
                else 
                begin
                    status <= S4;
                    out <= 1'b0;
                end
            end
        S3:
            begin
                status <= S3;
                out <= 1'b0;
            end
        S4:
            begin
                status <= S4;
                out <= 1'b0;
            end
        default: 
            begin
                status <= status;
                out <= out;
            end
        endcase
    end
end

endmodule