module mul_8(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output [7:0] hi,//进位
    output [7:0] lo,//原位
    output reg ready
);

   reg [15:0]ans;
   reg [3:0] cnt;
   reg [15:0]temp_a;
   reg [15:0] temp_b;
   reg [15:0]final;

   assign hi=final[15:8];
   assign lo=final[7:0];
   
//循环迭代法,速度慢,节省内存
   always@(posedge clk or negedge reset)begin
    if(!reset)begin
        ans<=0;
        cnt<=0;
        temp_a<=a;
        temp_b<=b;
        final<=0;
        ready<=0;
    end
    else begin
        if(cnt<8)begin
            if(temp_b[cnt]==1)begin
                ans<=ans+temp_a;
            end
            temp_a<=temp_a<<1;
            cnt<=cnt+1;
        end
        else if(cnt<9)begin
            cnt<=9;
           // temp_a<=a;
            //temp_b<=b;
            final<=ans;
        end
        else begin
              //ans<=0;
              ready<=1;
        end
       
       
    end
   end
endmodule
