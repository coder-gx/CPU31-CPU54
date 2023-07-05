module dmem(
    input clk,
    input reset,
    input cs,
    input dm_w,
    input dm_r,
    input [31:0] idata,
    input [31:0] addr,
    input [1:0] choice,//写全字、半字、字节
    output [31:0] odata
);
wire [31:0] address;

assign address=(addr-32'h1001_0000);//内存地址映射

reg [31:0] mem[256:0];//一个字节对应一个地址，因为一个寄存器存储4个字节，得到32位，因此读出或写入的时候注意可能跨越寄存器
//存储器的深度为32*4共128个地址单元

always @(posedge clk or posedge reset)begin//上升沿写入
    if(reset==1)begin//低电平有效,mem0初始化//dmem寄存器的大小有问题
        mem[0]<=0;mem[1]<=0;mem[2]<=0;mem[3]<=0;mem[4]<=0;mem[5]<=0;mem[6]<=0;mem[7]<=0;
        mem[8]<=0;mem[9]<=0;mem[10]<=0;mem[11]<=0;mem[12]<=0;mem[13]<=0;mem[14]<=0;mem[15]<=0;
        mem[16]<=0;mem[17]<=0;mem[18]<=0;mem[19]<=0;mem[20]<=0;mem[21]<=0;mem[22]<=0;mem[23]<=0;
        mem[24]<=0;mem[25]<=0;mem[26]<=0;mem[27]<=0;mem[28]<=0;mem[29]<=0;mem[30]<=0;mem[31]<=0;
    end
    else begin
        if(cs==1)begin
            if(dm_w==1)begin 
                 case(address[1:0])
                    2'b00://寄存器地址字节余0
                         if(choice==2'b00)//存字
                            mem[address>>2]<=idata;
                         else if(choice==2'b01)//存半字
                            mem[address>>2][31:16]<=idata[15:0];
                        else //存字节
                            mem[address>>2][31:24]<=idata[7:0];
                    2'b11:begin 
                        if(choice==2'b00)begin
                            mem[address>>2][7:0]<=idata[31:24];
                            mem[address>>2+1][31:8]<=idata[23:0];
                        end
                        else if(choice==2'b01)begin
                            mem[address>>2][7:0]<=idata[15:7];
                            mem[address>>2+1][31:24]<=idata[7:0];
                        end
                        else begin
                            mem[address>>2][7:0]<=idata[7:0];
                        end
                    end
                    2'b10:begin
                        if(choice==2'b00)begin
                            mem[address>>2][15:0]<=idata[31:16];
                            mem[address>>2+1][31:16]<=idata[15:0];
                        end
                        else if(choice==2'b01)begin
                             mem[address>>2][15:0]<=idata[15:0];
                        end
                        else
                            mem[address>>2][15:8]<=idata[7:0];
                    end
                    2'b01:begin
                         if(choice==2'b00)begin
                            mem[address>>2][23:0]<=idata[31:8];
                            mem[address>>2+1][31:24]<=idata[7:0];
                        end
                        else if(choice==2'b01)begin
                             mem[address>>2][23:8]<=idata[15:0];
                        end
                        else
                            mem[address>>2][23:16]<=idata[7:0];
                    end

                endcase    
            end
          
        end
    end
end


assign odata=(cs&dm_r)? (address[1] ? 
                              (address[0]? //11
                                    (choice[1]? //choice==2'b10
                                        {24'b0,mem[address>>2][7:0]}:(choice[0]? 
                                                                        {16'b0,mem[address>>2][7:0],mem[address>>2+1][31:24]}:
                                                                        {mem[address>>2][7:0],mem[address>>2+1][31:8]}
                                                                     )
                                    ):
                                    (choice[1]? //10
                                         {24'b0,mem[address>>2][15:8]}:(choice[0]? 
                                                                        {16'b0,mem[address>>2][15:0]}:
                                                                        {mem[address>>2][15:0],mem[address>>2+1][31:16]}
                                                                     )
                                    )
                                ):
                                (
                                    address[0]? //01
                                    (choice[1]? //choice==2'b10
                                        {24'b0,mem[address>>2][23:16]}:(choice[0]? 
                                                                        {16'b0,mem[address>>2][23:8]}:
                                                                        {mem[address>>2][23:0],mem[address>>2+1][31:24]}
                                                                     )
                                    ):
                                    (choice[1]? //00
                                         {24'b0,mem[address>>2][31:24]}:(choice[0]? 
                                                                        {16'b0,mem[address>>2][31:16]}:mem[address>>2]
                                                                     )
                                    )

                                )
                        ):32'bz;
               
            


//assign odata=(cs&&dm_r) ? mem[address>>2] :32'hzzzz_zzzz;

//always @(address or dm_r)begin//读取的数据保持立即改变
     
//end

endmodule
