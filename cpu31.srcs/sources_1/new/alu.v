module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output zero
    //output reg carry,
   // output reg negative,
    //output reg overflow
    );
    /*reg [32:0]a2,b2,r2;
    reg signed[31:0]sb;
    reg signed[31:0]sa;
    reg [31:0]temp;
    */
    always@(*)
    begin
      case(aluc)
         //a2=a;
         //b2=b;
         //sb=b;
         //sa=a;
        4'b0000://无符号相加
           begin
              r=a+b;
              //r2=a2+b2;
             // if(r2[32]==1)
               //  carry<=1;
           end
         4'b0010://有符号相加
           begin 
             r=a+b;
             /*if(a[31]==0&&b[31]==0&&r[31]==1)
                overflow<=1;  
              else 
                overflow<=0;*/                    
           end
         4'b0001://无符号相减
           begin
             r=a-b;
             /*if(a<b)
               carry<=1;*/
           end
         4'b0011://有符号相减
           begin
               r=a-b;
              /* if(a[31]==1&&b[31]==0&&r[31]==0)
                   overflow<=1; 
               else 
                  overflow<=0;*/ 
           end
           4'b0100://与运算
              r=a&b;
           4'b0101://或运算
              r=a|b;
           4'b0110://异或运算
              r=a^b;
           4'b0111://或非运算
              r=~(a|b);
           4'b1000://置高位立即数
              r={b[15:0],16'h0000};
            4'b1001:
               r={b[15:0],16'h0000};
            4'b1011://有符号比较
              if((a[31]==1 && b[31]==0)||(a[31]==1 && b[31]==1 && a<b)||(a[31]==0 &&b[31]==0&&a<b) )
                  r=1;
              else
                  r=0;
           4'b1010://无符号比较
           begin
               r=(a<b)? 1:0;
               /*if(a<b)
                  carry<=1;*/
           end
           4'b1100://算术右移
           begin
             r=($signed(b))>>>a;
             //temp=sb>>>(a-1);
           //  carry<=temp[0];
           end
           4'b1111://逻辑左移
           begin
             r=b<<a;
            // temp=b<<(a-1);
             //carry<=temp[31];
           end
           4'b1110:
              r=b<<a; 
           4'b1101://逻辑右移
           begin
             r=b>>a;
             //temp=b>>(a-1);
             //carry<=temp[0];
           end
      endcase
          /* //zero置位
           if(aluc==4'b1011||aluc==4'b1010)
           begin
               if(a-b==0)
                  zero<=1;
               else 
                 zero<=0;
            end
           else
              begin
              if(r==0)
                  zero<=1;
               else
                  zero<=0; 
              end
              
              //negative置位
            if(aluc==4'b1011)
            begin
              if(a<b)
                 negative<=1;
              else  
                 negative<=0;
            end
            else 
            begin
             if(r[31]==1)
                   negative<=1;
              else  
                   negative<=0; 
            end*/
                   
    end
    assign zero=((a-b)==0);
       
endmodule
