module regfile(
    input rf_clk,
    input reset,//复位信号，高电平有效
    input rf_w,
    input [31:0] rd,//rd的数值
    input [4:0] rdc,//rd的地址
    input [4:0] rsc,//rs的地址
    input [4:0] rtc,//rt的地址
    output [31:0] rs,
    output [31:0] rt

    );
    reg [31:0] array_reg[31:0];
    assign rs= reset? 0:array_reg[rsc];
    assign rt= reset ? 0:array_reg[rtc]; 

    always @(posedge rf_clk or posedge reset )begin
        if(reset ==1)begin//低电平有效,初始化32个寄存器
            array_reg[0]<=0;array_reg[1]<=0;array_reg[2]<=0;array_reg[3]<=0;
            array_reg[4]<=0;array_reg[5]<=0;array_reg[6]<=0;array_reg[7]<=0;
            array_reg[8]<=0;array_reg[9]<=0;array_reg[10]<=0;array_reg[11]<=0;
            array_reg[12]<=0;array_reg[13]<=0;array_reg[14]<=0;array_reg[15]<=0;
            array_reg[16]<=0;array_reg[17]<=0;array_reg[18]<=0;array_reg[19]<=0;
            array_reg[20]<=0;array_reg[21]<=0;array_reg[22]<=0;array_reg[23]<=0;
            array_reg[24]<=0;array_reg[25]<=0;array_reg[26]<=0;array_reg[27]<=0;
            array_reg[28]<=0;array_reg[29]<=0;array_reg[30]<=0;array_reg[31]<=0;
        end
        else begin
         if(rf_w&&rdc!=0)begin//0号寄存器不能变
                array_reg[rdc]<=rd;
        end
        end  
    end

   // always@(negedge rf_clk)begin//下降沿写入
       
    //end
    
   
    






endmodule
