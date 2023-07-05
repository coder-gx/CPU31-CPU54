module pc(
    input clk,
    input reset,
    input[31:0] idata,
    output reg[31:0] odata
    );

    always@(negedge clk or posedge reset)begin
        if(reset==1)begin
             odata<=32'h0040_0000;//数据映射
        end
        else begin
            odata<=idata;
        end
    end

endmodule
