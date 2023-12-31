//对于空格的处理:保持原状态 
//公共状态 
`define S0    8'b0000_0000//无效片段
`define S1    8'b0000_0001// ^
`define S2    8'b0000_0010// time(d,e_0) time&(a-1)(a为2的正整数次幂)只在freq为2的整数倍时生效
`define S3    8'b0000_0011// @
`define S4    8'b0000_0100//pc(h,e_1) 0x0000_3000 ~ 0x0000_4fff，且必须字对齐，即必须为4的整数倍
`define S5    8'b0000_0101//: 
`define S6    8'b0000_0110//<
`define S7    8'b0000_0111// =
`define S8    8'b0000_1000//data(h)
`define S9    8'b0000_1001//#
//寄存器状态
`define R0    8'b0000_1010//$
`define R1    8'b0000_1011//grf(d,e_2) 0 ~ 31
//存储器状态
`define D0    8'b0000_1100// 8'd42
`define D1    4'b0000_1101//addr(h,e_3) 0x0000_0000 ~ 0x0000_2fff，且必须字对齐，即必须为4的整数倍
module cpu_checker (
    input wire clk,
    input wire reset,
    input [7:0] char,
    input [15:0] freq,
    output reg [1:0] format_type,
    output reg [3:0] error_code //4位独热编码,哪位有错误哪位是1
);
    reg [7:0] status;
    reg [3:0] counter_d;//十进制1-4位
    reg [3:0] counter_h;//十六进制必须满足8位 
    reg [1:0] flag;
    reg [1:0] flag_TIME;
    reg [1:0] flag_PC;
    reg [1:0] flag_GRF;
    reg [1:0] flag_ADDR;
    reg [63:0] TIME;
    reg [63:0] PC;
    reg [63:0] GRF;
    reg [63:0] ADDR;
    always @(posedge clk) begin
        if(reset)
        begin
           status<= `S0;
           format_type<=2'b00;
           error_code<=4'b0000;
           counter_d<=4'b0000;
           counter_h<=4'b0000;
           flag<=2'b00;
           TIME<=64'b0000;
           GRF<=64'b0000;
           ADDR<=64'b0000;
           PC<=64'b0000;
           flag_ADDR<=2'b00;
           flag_GRF<=2'b00;
           flag_PC<=2'b00;
           flag_TIME<=2'b00;
        end
        else
        begin
            case (status)
                `S0:begin  //无效序列
                    if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                end
                `S1:begin  //^+time(d)1-4
                    if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else if(char>="0"&&char<="9")
                    begin
                        status<=`S2;
                        TIME<=TIME<<3+TIME<<1+char;//10
                        counter_d<=counter_d+1;//十进制计数
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end  
                end
                 `S2:begin // time(d)1-4+@
                    if(char>="0"&&char<="9")
                    begin
                        if(counter_d==4)
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            counter_d<=4'b0000;//发生状态转移时都要将计数器清0
                            TIME<=64'b0000;
                            error_code<=4'b0000;
                        end
                        else
                        begin
                            status<=`S2;
                            TIME<=TIME<<3+TIME<<1+char;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_d<=counter_d+1;
                        end
                    end
                    else if(char=="@")
                    begin
                        if(counter_d>=1)//十进制数至少有1位
                        begin
                            status<=`S3;
                            format_type<=2'b00;
                            if(TIME&(freq>>1-1)==0)
                            begin
                                flag_TIME<=2'b00;
                            end
                            else 
                            begin
                                flag_TIME<=2'b01;
                            end
                            counter_d<=4'b0000;
                            TIME<=64'b0000;
                        end
                        else
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_d<=4'b0000;
                            TIME<=64'b0000;
                        end
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        TIME<=64'b0000;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        TIME<=64'b0000;
                    end
                 end
                 `S3:begin //@+pc(h)8
                    if((char>="0"&&char<="9")||(char>="a"&&char<="f"))//符合十六进制数
                    begin
                       status<=`S4;
                       counter_h<=counter_h+1;//十六进制开始计数
                       PC<=PC<<4+char;
                       format_type<=2'b00;
                       error_code<=error_code;//error_code继承性问题 除了回到S0 S1 其他均为error<=error
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S4:begin //pc(h)8+:
                    if((char>="0"&&char<="9")||(char>="a"&&char<="f"))
                    begin
                       if(counter_h==8)
                       begin
                        counter_h<=4'b0000;
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        PC<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                       end
                       else
                       begin
                        status<=`S4;
                        counter_h<=counter_h+1;
                        PC<=PC<<4+char;
                        format_type<=2'b00;
                        error_code<=error_code;
                       end
                    end
                    else if(char==":")
                    begin
                        if(counter_h==8)//符合八位进行状态转移
                        begin
                            status<=`S5;
                            counter_h<=4'b0000;
                            format_type<=2'b00;
                            if(((PC>=8'h0000_3000)&&(PC<=8'h0000_4fff))&&(PC&(64'b0011)==0))
                            begin
                                flag_PC<=2'b00;
                            end
                            else 
                            begin
                                flag_PC<=2'b01;
                            end
                              PC<=64'b0000;
                        end
                        else
                        begin
                            status<=`S0;
                            counter_h<=4'b0000;
                            error_code<=4'b0000;
                            format_type<=2'b00;
                            PC<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        counter_h<=4'b0000;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        PC<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else 
                    begin
                        status<=`S0;
                        counter_h<=4'b0000;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        PC<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S5:begin //分叉
                    if(char==" ")//吃空格
                    begin
                        status<=`S5;
                        format_type<=2'b00;
                        error_code<=error_code;
                    end
                    else if(char=="$")//寄存器R
                    begin
                        status<=`R0;
                        format_type<=2'b00;
                        error_code<=error_code;
                    end
                    else if(char==8'd42)//存储器D
                    begin
                        status<=`D0;
                        format_type<=2'b00;
                        error_code<=error_code;
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `R0:begin
                    flag<=2'b01;
                    if(char>="0"&&char<="9")
                    begin
                       status<=`R1;
                       counter_d<=counter_d+1;
                       GRF<=GRF<<3+GRF<<1+char;
                       format_type<=2'b00;
                       error_code<=error_code;
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        GRF<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        GRF<=64'b0000;
                       flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `R1:begin
                    if(char>="0"&&char<="9")
                    begin
                        if(counter_d==4)
                        begin
                            counter_d<=4'b0000;
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            GRF<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                        else
                        begin
                            counter_d<=counter_d+1;
                            status<=`R1;
                            GRF<=GRF<<3+GRF<<1+char;
                            format_type<=2'b00;
                            error_code<=error_code;
                        end
                    end
                    else if(char==" ")
                    begin
                        if(counter_d>=1)//至少一位
                        begin
                            status<=`R1;
                            format_type<=2'b00;
                            if(GRF>=0&&GRF<=31)
                            begin
                               flag_GRF<=2'b00;
                            end
                            else
                            begin
                                flag_GRF<=2'b01;
                            end
                        end
                        else
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_d<=4'b0000;
                            GRF<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end

                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        GRF<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else if(char=="<")
                     if(counter_d>=1)//至少一位
                        begin
                            status<=`S6;
                            format_type<=2'b00;
                            if(GRF>=0&&GRF<=31)
                            begin
                                flag_GRF<=2'b00;
                            end
                            else
                            begin
                                flag_GRF<=2'b01;
                            end
                            GRF<=64'b0000;
                            counter_d<=4'b0000;
                        end
                        else
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_d<=4'b0000;
                            GRF<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_d<=4'b0000;
                        GRF<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `D0:begin
                    flag<=2'b00;
                    if((char>="0"&&char<="9")||(char>="a"&&char<="f"))//十六进制
                    begin
                        status<=`D1;
                        format_type<=2'b00;
                        ADDR<=ADDR<<4+char;
                        error_code<=error_code;
                        counter_h<=counter_h+1;
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_h<=4'b0000;
                        ADDR<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_h<=4'b0000;
                        ADDR<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `D1:begin
                    if((char>="0"&&char<="9")||(char>="a"&&char<="f"))
                    begin
                        if(counter_h==8)
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_h<=4'b0000;
                            ADDR<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                        else 
                        begin
                            status<=`D1;
                            ADDR<=ADDR<<4+char;
                            format_type<=2'b00;
                            error_code<=error_code;
                            counter_h<=counter_h+1;
                        end
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_h=4'b0000;
                        ADDR<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else if(char==" ")//出现空格时也需要判断是否8位
                    begin
                        if(counter_h==8)
                        begin
                            status<=`D1;
                            format_type<=2'b00;
                            if(((ADDR>=8'h0000_0000)&&(ADDR<=8'h0000_2fff))&&(ADDR&(64'b0011)==0))
                            begin
                                flag_ADDR<=2'b00;
                            end
                            else
                            begin
                                flag_ADDR<=2'b01;
                            end
                        end
                        else 
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_h<=4'b0000;
                            ADDR<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                        end
                    end
                     else if(char=="<")
                    begin
                        if(counter_h==8)
                        begin
                            status<=`S6;
                            format_type<=2'b00;
                            if(((ADDR>=8'h0000_0000)&&(ADDR<=8'h0000_2fff))&&(ADDR&(64'b0011)==0))
                            begin
                                flag_ADDR<=2'b00;
                            end
                            else
                            begin
                                flag_ADDR<=2'b01;
                            end
                            counter_h<=4'b0000;
                            ADDR<=64'b0000;
                        end
                        else
                        begin
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            counter_h<=4'b0000;
                            ADDR<=64'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        counter_h<=4'b0000;
                        ADDR<=64'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S6:begin//<
                    if(char=="=")
                    begin
                        status<=`S7;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                         flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                         flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S7:begin  //<=
                    if(char==" ")
                    begin
                        status<=`S7;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                         flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else if((char>="0"&&char<="9")||(char>="a"&&char<="f"))
                    begin
                        status<=`S8;
                        counter_h<=counter_h+1;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                    end
                    else 
                    begin
                        status<=`S0;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                         flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S8:begin
                    if((char>="0"&&char<="9")||(char>="a"&&char<="f"))
                    begin
                        if(counter_h==8)
                        begin
                            counter_h<=4'b0000;
                            status<=`S0;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                             flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                        else
                        begin
                            counter_h<=counter_h+1;
                            status<=`S8;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                        end
                    end
                    else if(char=="#")
                    begin
                        if(counter_h==8)
                        begin
                            status<=`S9;
                            counter_h<=4'b0000;
                            if(flag==2'b01)//标记是哪一种符合
                            begin
                                format_type<=2'b01;
                                error_code<={flag_GRF[0],flag_ADDR[0],flag_PC[0],flag_TIME[0]};
                            end
                            else 
                            begin
                                format_type<=2'b10;
                                error_code<={flag_GRF[0],flag_ADDR[0],flag_PC[0],flag_TIME[0]};
                            end
                        end
                        else 
                        begin
                            status<=`S0;
                            counter_h<=4'b0000;
                            format_type<=2'b00;
                            error_code<=4'b0000;
                            flag_ADDR<=2'b00;
                            flag_GRF<=2'b00;
                            flag_PC<=2'b00;
                            flag_TIME<=2'b00;
                        end
                    end
                    else if(char=="^")
                    begin
                        status<=`S1;
                        counter_h<=4'b0000;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                    else
                    begin
                        status<=`S0;
                        counter_h<=4'b0000;
                        format_type<=2'b00;
                        error_code<=4'b0000;
                        flag_ADDR<=2'b00;
                        flag_GRF<=2'b00;
                        flag_PC<=2'b00;
                        flag_TIME<=2'b00;
                    end
                 end
                 `S9:begin
                  if(char=="^")
                  begin
                    status<=`S1;
                    format_type<=2'b00;
                    error_code<=4'b0000;
                    flag_ADDR<=2'b00;
                    flag_GRF<=2'b00;
                    flag_PC<=2'b00;
                    flag_TIME<=2'b00;
                  end
                  else 
                  begin
                    status<=`S0;
                    format_type<=2'b00;
                    error_code<=4'b0000;
                    flag_ADDR<=2'b00;
                    flag_GRF<=2'b00;
                    flag_PC<=2'b00;
                    flag_TIME<=2'b00;
                  end
                 end
            endcase
        end
    end
endmodule