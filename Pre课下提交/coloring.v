module coloring (
    input wire clk,
    input wire rst_n,
    input wire [1:0] color,
    output check
);
localparam s0 = 15'b0000_0000_0001;
localparam s1 = 15'b0000_0000_0010;
localparam s2 = 15'b0000_0000_0100;
localparam s3 = 15'b0000_0000_1000;
localparam s4 = 15'b0000_0001_0000;
localparam s5 = 15'b0000_0010_0000;
localparam s6 = 15'b0000_0100_0000;
localparam s7 = 15'b0000_1000_0000;
localparam s8 = 15'b0001_0000_0000;
localparam s9 = 15'b0010_0000_0000;
localparam s10 = 15'b0100_0000_0000;
localparam s11 = 15'b1000_0000_0000;
localparam s12 = 15'b001_0000_0000_0000;
localparam s13 = 15'b010_0000_0000_0000;
localparam s14 = 15'b100_0000_0000_0000;
reg [15:0] state;
reg [15:0] n_state;

`ifndef macro
reg [31:0]string;
always@(*)begin
case(state)
s0: string = "s0";
s1: string = "s1";
s2: string = "s2";
s3: string = "s3";
s4: string = "s4";
s5: string = "s5";
s6: string = "s6";
s7: string = "s7";
s8: string = "s8";
s9: string = "s9";
s10: string = "s10";
s11: string = "s11";
s12: string = "s12";
s13: string = "s13";
s14: string = "s14";
default:string = "?";
endcase
end
`endif 

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)begin
        state <= s0;
    end
    else begin
        state <= n_state;
    end
end

always@(*)begin
    case(state)
    s0:
    begin
        case(color)
        2'b0:n_state = s4;
        2'b1:n_state = s1;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s1:
    begin
        case(color)
        2'b0:n_state = s10;
        2'b1:n_state = s2;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s2:
    begin
        case(color)
        2'b0:n_state = s11;
        2'b1:n_state = s3;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s3:
    begin
         case(color)
        2'b0:n_state = s11;
        2'b1:n_state = s3;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s4:
    begin
        case(color)
        2'b0:n_state = s5;
        2'b1:n_state = s12;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s5:
    begin
        case(color)
        2'b0:n_state = s6;
        2'b1:n_state = s13;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s6:
    begin
        case(color)
        2'b00:n_state = s6;
        2'b01:n_state = s13;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s7:
    begin
        case(color)
        2'b0:n_state = s4;
        2'b1:n_state = s1;
        2'b10:n_state = s8;
        default: n_state = s0;
        endcase
    end
    s8:
    begin
        case(color)
        2'b0:n_state = s4;
        2'b1:n_state = s1;
        2'b10:n_state = s9;
        default: n_state = s0;
        endcase
    end
    s9:
    begin
         case(color)
        2'b0:n_state = s4;
        2'b1:n_state = s1;
        2'b10:n_state = s9;
        default: n_state = s0;
        endcase
    end
    s10:
    begin
        case(color)
        2'b0:n_state = s10;
        2'b1:n_state = s2;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s11:
    begin
       case(color)
        2'b0:n_state = s11;
        2'b1:n_state = s3;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s12:
    begin
        case(color)
        2'b0:n_state = s5;
        2'b1:n_state = s12;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    s13:
    begin
       case(color)
        2'b0:n_state = s6;
        2'b01:n_state = s13;
        2'b10:n_state = s7;
        default: n_state = s0;
        endcase
    end
    default:
    n_state = n_state;
    endcase
end

assign check = (state == s3)?1'b1:
                (state == s6)?1'b1:
                (state == s9)?1'b1:
                (state == s10)?1'b1:
                 (state == s11)?1'b1:
                 (state == s12)?1'b1:
                 (state == s13)?1'b1:
                 1'b0;
endmodule