`timescale 1ns / 1ps

module sccomp_dataflow(
    input clk_in,
    input reset, 
    output [31:0] inst, 
    output [31:0] pc

    //output [31:0] oalu,rs,rt,//idmem,odmem
    //output zero
);
wire[31:0] odmem;
wire [31:0] oalu;
wire [31:0] idmem;
wire[31:0] a;
wire cs;
wire dm_r;
wire dm_w;
wire pc_out;
wire [1:0] choice;//全字，半字，字节

//wire[31:0]hi,lo;

assign a=pc-32'h0040_0000;

cpu sccpu( clk_in,reset,inst,odmem,oalu,idmem,pc,cs, dm_r,dm_w,choice);

dmem dmem_inst(clk_in,reset,cs,dm_w,dm_r,idmem,oalu,choice,odmem);

imem imem_inst(a[12:2],inst);


endmodule
