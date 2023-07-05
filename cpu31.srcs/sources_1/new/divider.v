module divider(
    input I_CLK,
    output reg O_CLK
    );
parameter cycle=10_000_000;
reg[31:0] count=0;
initial
O_CLK=0;

always@(posedge I_CLK)
begin 
  if(count<cycle/2)
    count=count+1;
  else
    begin
      count=1;
      O_CLK=~O_CLK;
    end
end    
endmodule
