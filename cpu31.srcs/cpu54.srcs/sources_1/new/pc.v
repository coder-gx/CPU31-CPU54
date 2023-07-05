module pc(
    input clk,
    input reset,
    input pc_in,
    input pc_out,
    input[31:0] idata,
    output  reg [31:0] data,
    output reg[31:0] odata
    );
   

    always@(posedge clk or posedge reset)begin
        if(reset==1)begin
             odata<=32'h0040_0000;//数据映射
             data<=32'h0040_0000;
        end
        else begin
            if(pc_in)
               data<=idata;
            if(pc_out)
               odata<=data;
               
        end
    end

endmodule
