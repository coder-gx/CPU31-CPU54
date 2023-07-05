module add_8(
    input clk,
    input reset,
    input [15:0] a1,
    input [15:0] a2,
    input [15:0] a3,
    input [15:0] a4,
    input [15:0] a5,
    input [15:0] a6,
    input [15:0] a7,
    output [7:0] cout,//进位
    output [7:0] s,//原位
    output reg ready
);
reg [15:0] a01;
reg [15:0] a23;
reg [15:0] a45;
reg [15:0] a67;
reg [15:0] a0123;
reg [15:0] a4567;
reg [15:0] ans;
assign cout=ans[15:8];
assign s=ans[7:0];
reg [3:0] cnt;
reg[15:0] temp;
//reg[15:0] pre_ans;

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        a01<=0;
        a23<=0;
        a45<=0;
        a67<=0;
        a0123<=0;
        a4567<=0;
        ans<=0;
        //pre_ans<=0;
        cnt<=0;
        temp<=0;
        ready<=0;
    end
    else begin
        if(cnt<3) begin
        a01<=a1;
        a23<=a2+a3;
        a45<=a4+a5;
        a67<=a6+a7;
        a0123<=a01+a23;
        a4567<=a45+a67;
        temp<=a0123+a4567;
        cnt<=cnt+1;
        end
        else if(cnt==3)begin
            ans<=temp;
            cnt<=4;
        end
        else begin
             ready<=1;
        end
    end
end
endmodule


