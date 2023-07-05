module imem(
    input [10:0] pc,
    output [31:0] instr
);
 dist_mem_gen_0 dist_mem_gen_0_inst(pc,instr);
 //dist_mem_gen_1 dist_mem_gen_1_inst(pc,instr);
  /*reg [31:0] im[128:0];
  //初始化指令集
  initial begin
    $readmemh("E:/vivado_project/test_cpu",im);
  end
  assign instr=im[pc];
*/

endmodule
