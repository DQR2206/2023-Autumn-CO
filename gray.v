module gray (
    input Clk,
    input Reset,
    input En,
    output reg [2:0] Output,
    output reg Overflow 
);
reg [3:0] cnt;
always @(posedge Clk) begin
    if(Reset)
    begin
        cnt <= 4'b0001;
        Output <= 3'b000;
        Overflow <= 1'b0;
    end 
    else 
    begin
        if(En)
        begin
			    if(cnt == 4'b000)
				begin
				cnt <= cnt + 4'b001;
				Output <= 3'b000;
				end
                else if(cnt == 4'b0001)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b001;
                end
                else if(cnt == 4'b0010)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b011;
                end
                else if(cnt == 4'b011)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b010;
                end
                else if(cnt == 4'b100)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b110;
                end
                else if(cnt == 4'b0101)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b111;
                end
                else if(cnt == 4'b0110)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b101;
                end
                else if(cnt == 4'b0111)
                begin
				cnt <= cnt + 4'b001;
                Output <= 3'b100;
                end
				else if(cnt ==4'b1000)
				begin
				cnt <= 4'b0001;
				Overflow <= 1'b1;
				Output <= 3'b000; 
				end
        end
    end
end
endmodule