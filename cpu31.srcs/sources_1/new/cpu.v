module cpu(
    input clk,
    input reset,
    input [31:0] instr,//从imem读取的指令
    input [31:0] idata,//从dmem读取的数据
    output [31:0] oalu,//alu的输出
    output [31:0] odata,//写入dmem的数据
    output [31:0] opc,//pc指令地址
    output cs,
    output dm_r,
    output dm_w//dmem的几个使能端口

    //测试
    //output[31:0] rs,rt,
    //output zero
);

   wire [31:0] omux3;
   wire [31:0] omux5;
   wire [31:0] omux4;
   wire [31:0] omux2;
   wire [31:0] omux1;//mux3的输出
   wire [31:0] onpc;//npc的输出
   wire [31:0] oadd;//add的输出
   wire m1;
   wire m2;//m1,m2的选择
   wire [1:0] m3;
   wire [1:0] m4;
   wire [1:0] m5;//m3,m4,m5的选择
   wire [31:0] oext5;
   wire [31:0] oext16;
   wire [31:0] oext18;//3个位拓展
   wire zero;//alu的zero
   wire rf_w;//regfile写使能
  
   wire sign;//ext16的符号选择
   wire [3:0] aluc;//alu的命令
   wire [31:0] rs;
   wire [31:0] rt;//regfile读出的数据

   decoder_control   decoder_control_inst(instr,zero,rf_w,m1,m2,m3,m4,m5,cs,dm_w,dm_r,sign,aluc);
   //add add_inst(oext18,onpc,oadd);
   assign oadd=oext18+onpc;
   
   pc pc_inst(clk,reset,omux3,opc);

   //npc npc_inst(reset,opc,onpc);
    assign onpc=reset? opc:opc+4;
  // mux41 mux3({onpc[31:28],instr[25:0],2'b00},onpc,oadd,rs,m3,omux3);
   //mux31 mux5( 32'd31,{27'h0,instr[15:11]}, {27'h0,instr[20:16]},m5,omux5);
  // mux21 mux1(oext5,rs,m1,omux1);
  // mux21 mux2(rt,oext16,m2,omux2);
   //mux31 mux4(onpc,idata,oalu,m4,omux4);
   assign omux3= (m3[1]? (m3[0] ? rs:oadd):(m3[0]? onpc: {onpc[31:28],instr[25:0],2'b00})); 
   assign omux5= m5[1]? {27'h0,instr[20:16]}:(m5[0] ? {27'h0,instr[15:11]}:32'd31);
   assign omux1= m1? rs:oext5;
   assign omux4= m4[1]? oalu:(m4[0]? idata:onpc );
   assign omux2= m2 ? oext16 : rt; 

   //ext ext5({11'b0,instr[10:6]},1'b0,oext5);
   //ext ext16(instr[15:0],sign,oext16);

   assign oext5={27'h0,instr[10:6]};
   assign oext16= sign ? ({{16{instr[15]}},instr[15:0]}):({16'h0000,instr[15:0]});

   assign oext18={{14{instr[15]}},instr[15:0],2'b00};//ext18直接写出



   regfile cpu_ref( clk,reset,rf_w,omux4,omux5[4:0],instr[25:21],instr[20:16],rs,rt);

   alu alu_inst( omux1,omux2,aluc,oalu,zero);

   assign odata=rt;

endmodule
