module code (
    input Clk,
    input Reset,
    input Slt,
    input En,
    output reg [63:0] Output0,
    output reg [63:0] Output1 
);
    reg [2:0] cnt1;//记录register1的时钟周期
    always@(posedge Clk)
    begin
        if(Reset)
        begin
          Output0<=64'b0;
          Output1<=64'b0;
          cnt1<=3'b001;//为什么初值为1而不是0？才想明白 因为清零的周期里也要+1
        end
        else //满足1时不执行2
        begin
        if(En)
        begin
            if(Slt)
            begin
               cnt1<=cnt1+1;
               if(cnt1==3'b100)
               begin
                Output1<=Output1+1;
                cnt1<=3'b001;
               end
               else
               begin
                Output1<=Output1;
               end
            end
            else
            begin
               Output0<=Output0+1;
            end
        end
        else 
        begin
            Output0<=Output0;
            Output1<=Output1;
        end
        end
    end
endmodule