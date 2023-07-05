module cp0(
input clk,				
input rst,				
input mfc0,				//读cp0
input mtc0,				//写cp0
input eret,				//ָ中断返回
input exception,		//中断异常
input [4:0] cause,		//中断原因
input [4:0] addr,		//cp0寄存器地址
input [31:0]wdata,		//写进cp0的数据
input [31:0]pc,			//pc
output [31:0]rdata,		//Cp0读出的数据
output [31:0]status,	//中断状态
output [31:0]exc_addr	//中断地址
);

parameter
STATUSADDR	=5'd12,
EPCADDR		=5'd14,
CAUSEADDR	=5'd13;

reg [31:0]cp0Reg[31:0];//cp0寄存器

assign exc_addr	=eret?cp0Reg[EPCADDR]+4:32'h00400004;
assign status	=cp0Reg[STATUSADDR];
assign rdata	=mfc0?cp0Reg[addr]:32'bz;


always @(posedge clk or posedge rst)begin
	if(rst)begin
		cp0Reg[STATUSADDR]<={27'd0,5'b11111};
	end
	else begin
		if(mtc0)
			cp0Reg[addr]<=wdata;
		if(exception)begin
			cp0Reg[STATUSADDR]<={cp0Reg[STATUSADDR][26:0],5'd0};//左移5位关中断
			cp0Reg[CAUSEADDR]<={25'd0,cause,2'd0};
			cp0Reg[EPCADDR]<=pc;
		end
		if(eret)begin
			cp0Reg[STATUSADDR]<={5'd0,cp0Reg[STATUSADDR][31:5]};//右移5位开中断
		end
	end
end

endmodule