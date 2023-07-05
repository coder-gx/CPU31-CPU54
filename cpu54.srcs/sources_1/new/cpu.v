module cpu(
    input clk,
    input reset,
    input [31:0] ir,//从imem读取的指令
    input [31:0] idata,//从dmem读取的数据
    output reg [31:0] z_reg,//暂存alu和clz结果
    output [31:0] odata,//写入dmem的数据
    output [31:0] opc,//pc指令地址
    output cs,
    output dm_r,
    output dm_w, //dmem的几个使能端口
    output [1:0] choice//全字，半字，字节
    
    //测试
    //output reg[31:0] hi,
    //output reg[31:0] lo
);
   wire [31:0]pc;
   wire [31:0] omux8,omux7,omux6,omux5,omux4,omux3,omux2,omux1;//所有多路选择器的输出
   
   wire [1:0] m1,m2,m3;
   wire [2:0] m4;
   wire [1:0] m5;
   wire m6,m7,m8;//m1~m8的选择


   wire [31:0] oext5;
   wire [31:0] oext16;
   wire [31:0] oext18;
   wire [31:0] oext;//4个位拓展
   wire sign;//ext16和ext的符号选择

   wire rf_w;//regfile写使能
   wire ir_in;//指令更新
   wire pc_in;//pc更新
   wire z_in;//z更新
   wire temp_in;//rd_temp更新
   wire hi_w;//高位寄存器写
   wire lo_w;//低位寄存器写


   wire cp0_w;//cp0写
   wire cp0_r;//cp0读
   wire eret;//中断返回
   wire exception;//异常
   wire [4:0]cause;//异常原因
   wire [31:0] ocp0;//cp0输出
   wire [31:0] epc;//中断地址

   wire [31:0] status;//状态寄存器

   wire [3:0] aluc;//alu的命令
   wire [31:0] oclz;//clz运算结果
   wire [31:0] oalu;//alu的输出


   wire [3:0] ready;//4个乘法器/除法器计算完成状态
   
   wire [3:0] start;//4个乘法器/除法器开始计算
   wire [31:0] rd;
   wire [31:0] rs;
   wire [31:0] rt;//regfile读出的数据

   


  
  // reg[31:0] ir;//指令寄存器
   reg [31:0] rd_temp;//暂存rd值
   reg [31:0] hi;//高位寄存器
   reg [31:0] lo;//低位寄存器

   wire [1:0] mul_div;
   wire [31:0]divq,divr,divuq,divur,multa,multb,multua,multub;
   wire[31:0] a,b;//乘法的高位和低位或者除法的余数和商
   wire [1:0] busy;
   wire[63:0] multab,multuab;
   assign multa=multab[63:32];
   assign multb=multab[31:0];
   assign multua=multuab[63:32];
   assign multub=multuab[31:0];
   


   
   decoder_control   decoder_control_inst(clk,reset,ir,z_reg,status, ready,rs  ,
   pc_in,pc_out,ir_in,z_in,rf_w,temp_in,hi_w,lo_w,cp0_w,cp0_r,eret,exception,cause,start,
   m1,m2,m3,m4,m5,m6,m7,m8,cs,dm_w,dm_r,choice,sign,aluc,mul_div);
  
   
   pc pc_inst(clk,reset,pc_in,pc_out,omux3,pc,opc);

   
   assign a=mul_div[1]?(mul_div[0]? divur:divr):(mul_div[0] ? multua:multa);
   assign b=mul_div[1]?(mul_div[0]? divuq:divq):(mul_div[0] ? multub:multb);

  //复杂计算集群
   clz clz_inst(rs,oclz);
   mult mult_inst(clk,(~reset)&start[0],rs,rt,ready[0],multab);
   multu multu_inst(clk,(~reset)&start[1],rs,rt,ready[1],multuab);
   div div_inst(rs,rt,start[2],clk,reset,divq,divr,busy[0],ready[2]);
   divu divu_inst( rs,rt,start[3],clk,reset,divuq,divur,busy[1],ready[3]);
  

   assign omux1= m1[1]? rs:(m1[0]? pc:oext5);
   assign omux2= m2[1] ? (m2[0]? 3'd4:oext18) : (m2[0] ? oext16:rt); 
   assign omux3= (m3[1]? (m3[0] ? rs:epc):(m3[0] ? {z_reg[31:28],ir[25:0],2'b00}:z_reg)); 
   assign omux4= m4[2] ? (m4[0]? hi:lo):(m4[1]? (m4[0]? z_reg:oext):(m4[0]? b:ocp0));
   assign omux5= m5[1]? {27'h0,ir[20:16]}:(m5[0] ? {27'h0,ir[15:11]}:32'd31);
   assign omux6= m6? a:rs;
   assign omux7= m7? rs:b;
   assign omux8 =m8? oclz:oalu;


  //位拓展集群
   assign oext5={27'h0,ir[10:6]};
   assign oext16= sign ? ({{16{ir[15]}},ir[15:0]}):({16'h0000,ir[15:0]});
   assign oext18={{14{ir[15]}},ir[15:0],2'b00};
   assign oext=choice[1]? (sign? {{24{idata[7]}},idata[7:0]}:idata):(choice[0] ? (sign? {{16{idata[15]}},idata[15:0]}:idata ):idata);
   
   
   regfile cpu_ref( clk,reset,rf_w,omux4,omux5[4:0],ir[25:21],ir[20:16],rs,rt,rd);

   alu alu_inst( omux1,omux2,aluc,oalu,zero);

   assign odata=rt;


//中间寄存器集群
  /* //ir
   always@(posedge clk)begin
    if(ir_in)begin
        ir<=instr;
    end
   end*/
//z_reg
   always@(posedge clk)begin
     if(z_in)begin
        z_reg<=omux8;
    end
   end
//rd_temp
always@(posedge clk)begin
     if(temp_in)begin
        rd_temp<=ir[15:11];
    end
end
//hi
always@(posedge clk)begin
     if(hi_w)begin
        hi<=omux6;
    end
end

//lo
always@(posedge clk)begin
     if(lo_w)begin
        lo<=omux7;
    end
end

//cp0中断协处理器
cp0 cp0_inst(clk,reset,	cp0_r,cp0_w,eret,exception,cause,rd_temp[4:0],rt,opc,ocp0,status,epc);


endmodule
