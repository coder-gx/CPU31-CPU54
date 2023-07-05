module top(
  input clk_in,
  input reset,
  output [7:0]o_seg,
  output [7:0] o_sel

  //测试
 // output [31:0] pc,
  //output [31:0] inst

);
    wire [31:0]inst;
    wire [31:0]pc;
    wire clk_out;
    divider divider_inst(clk_in,clk_out);
    sccomp_dataflow scc(.clk_in(clk_out),.reset(reset),.inst(inst),.pc(pc));
    seg7x16 seg(clk_in, reset, 1'b1,pc, o_seg, o_sel);

 

endmodule
