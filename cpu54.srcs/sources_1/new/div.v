
module div(
    input [31:0] dividend,//被除数
    input [31:0] divisor,//除数
    input start,
    input clock,
    input reset,
    output [31:0] q,
    output [31:0] r,
    output reg busy,
    output ready
    );
   // wire ready;
    reg [4:0] cnt;
    reg [31:0] reg_q;
    reg [31:0] reg_r;
    reg [31:0] reg_b;
    reg busy2;
    reg r_sign;//余数的符号
    wire [31:0] r1,r2;
    wire [31:0] q1,q2;
    wire[32:0] add;
    assign add=r_sign? ({reg_r,q1[31]}+{1'b0,reg_b}):({reg_r,q1[31]}-{1'b0,reg_b});
    assign r1=r_sign? reg_r+reg_b: reg_r;//恢复余数
    assign q1=reg_q;
    assign q=(dividend[31]^divisor[31])? (~q1+1):q1;
    assign r=(dividend[31]? ~r1+1:r1);
    /*assign q=(dividend[31]^divisor[31]&&r2!=0)?q2-1:q2;
    assign r=(dividend[31]^divisor[31]&&r2!=0)?(r2+divisor):r2;*/
    assign ready=~busy&busy2;


    always@(posedge clock or negedge reset)begin
        if(reset==1)begin
            cnt<=0;
            busy<=0;
            busy2<=0;
        end
        else begin
            busy2<=busy;//延迟一个周期再结束
            if(start)begin
                reg_r<=0;
                r_sign<=0;
                reg_q<=dividend[31]? ~dividend+1:dividend;
                reg_b<=divisor[31]? ~divisor+1:divisor;
                busy<=1;
                cnt<=0;
            end
            else if(busy)begin
                reg_r<=add[31:0];
                r_sign<=add[32];
                reg_q<={reg_q[30:0],~add[32]};
                cnt<=cnt+1;
                if(cnt==5'h1f)begin
                    busy<=0;
                end
            end

        end
        
    end

endmodule
