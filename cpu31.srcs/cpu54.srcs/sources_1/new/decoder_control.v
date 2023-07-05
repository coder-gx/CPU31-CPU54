module decoder_control(
    input clk,
    input reset,
    input[31:0] instr,//指令
    input[31:0] z_reg, //暂存oalu
    input[31:0] status,//cp0状态寄存器
    input [3:0] ready, //乘除法完成寄存器
    input [31:0] rs,

    output pc_in,//pc内部更新信号
    output pc_out,//pc外部更新信号
    output ir_in,//指令寄存器更新信号
    output z_in,//z寄存器更新
    output rf_w, 
    output temp_in,//rd暂存寄存器更新
    output hi_w,//高位寄存器写
    output lo_w,//低位寄存器写
    output cp0_w,//cp0寄存器写
    output cp0_r,//cp0寄存器读
    output eret,//中断返回信号
    output exception,//异常中断信号
    output[4:0] cause,//中断原因
    output [3:0] start,//乘除法器开始信号
    output [1:0] m1,m2,m3,
    output [2:0] m4,
    output [1:0] m5,
    output m6,m7,m8,//m1~m8的选择
    output cs,
    output dm_w,//存储器写
    output dm_r,//存储器读
    output [1:0] choice,//全字、半字、字节
    output sign,//符号位
    output [3:0] aluc,//各种运算操作
    output [1:0] mul_div//乘除法选择
    );
  
//指令译码器部分

   //r型指令
    assign _add=(instr[31:26]==0)&&(instr[5:0]==6'b10_0000);
    assign _addu=(instr[31:26]==0)&&(instr[5:0]==6'b10_0001);
    assign _sub=(instr[31:26]==0)&&(instr[5:0]==6'b10_0010);
    assign _subu=(instr[31:26]==0)&&(instr[5:0]==6'b10_0011);
    assign _and=(instr[31:26]==0)&&(instr[5:0]==6'b10_0100);
    assign _or=(instr[31:26]==0)&&(instr[5:0]==6'b10_0101);
    assign _xor=(instr[31:26]==0)&&(instr[5:0]==6'b10_0110);
    assign _nor=(instr[31:26]==0)&&(instr[5:0]==6'b10_0111);
    assign _slt=(instr[31:26]==0)&&(instr[5:0]==6'b10_1010);
    assign _sltu=(instr[31:26]==0)&&(instr[5:0]==6'b10_1011);
    assign _sll=(instr[31:26]==0)&&(instr[5:0]==6'b00_0000);
    assign _srl=(instr[31:26]==0)&&(instr[5:0]==6'b00_0010);
    assign _sra=(instr[31:26]==0)&&(instr[5:0]==6'b00_0011);
    assign _sllv=(instr[31:26]==0)&&(instr[5:0]==6'b00_0100);
    assign _srlv=(instr[31:26]==0)&&(instr[5:0]==6'b00_0110);
    assign _srav=(instr[31:26]==0)&&(instr[5:0]==6'b00_0111);
    assign _jr=(instr[31:26]==0)&&(instr[5:0]==6'b00_1000);
    
    assign _divu=(instr[31:26]==0)&&(instr[5:0]==6'b01_1011);
    assign _div=(instr[31:26]==0)&&(instr[5:0]==6'b01_1010);
    assign _mul=(instr[31:26]==6'b01_1100)&&(instr[5:0]==6'b00_0010);
    assign _multu=(instr[31:26]==0)&&(instr[5:0]==6'b01_1001);
    assign _eret=(instr[31:26]==6'b01_0000)&&(instr[5:0]==6'b01_1000);
    assign _syscall=(instr[31:26]==0)&&(instr[5:0]==6'b00_1100);
    assign _teq=(instr[31:26]==0)&&(instr[5:0]==6'b11_0100);
    assign _break=(instr[31:26]==0)&&(instr[5:0]==6'b00_1101);
    assign _jalr=(instr[31:26]==0)&&(instr[5:0]==6'b00_1001);

    assign _mfc0=(instr[31:26]==6'b01_0000)&&(instr[25:21]==0)&&(instr[5:0]==0);
    assign _mfhi=(instr[31:26]==0)&&(instr[5:0]==6'b01_0000);
    assign _mflo=(instr[31:26]==0)&&(instr[5:0]==6'b01_0010);
    assign _mtc0=(instr[31:26]==6'b01_0000)&&(instr[25:21]==5'b00100)&&(instr[5:0]==0);
    assign _mthi=(instr[31:26]==0)&&(instr[5:0]==6'b01_0001);
    assign _mtlo=(instr[31:26]==0)&&(instr[5:0]==6'b01_0011);
    
    assign _lb= (instr[31:26]==6'b10_0000);
    assign _lbu=(instr[31:26]==6'b10_0100);
     assign _lh= (instr[31:26]==6'b10_0001);
    assign _lhu= (instr[31:26]==6'b10_0101);
     assign _sb=(instr[31:26]==6'b10_1000);
    assign _sh=(instr[31:26]==6'b10_1001);
    assign _bgez=(instr[31:26]==6'b00_0001);

    assign _clz=(instr[31:26]==6'b01_1100)&&(instr[5:0]==6'b10_0000);
     

    //i型操作指令
    assign _addi=(instr[31:26]==6'b00_1000);
    assign _addiu=(instr[31:26]==6'b00_1001);
    assign _andi=(instr[31:26]==6'b00_1100);
    assign _ori=(instr[31:26]==6'b00_1101);
    assign _xori=(instr[31:26]==6'b00_1110);
    assign _lui=(instr[31:26]==6'b00_1111);
    assign _lw=(instr[31:26]==6'b10_0011);
    assign _sw=(instr[31:26]==6'b10_1011);
    assign _beq=(instr[31:26]==6'b00_0100);
    assign _bne=(instr[31:26]==6'b00_0101);
    assign _slti=(instr[31:26]==6'b00_1010);
    assign _sltiu=(instr[31:26]==6'b00_1011);

    //j型操作指令
    assign _j=(instr[31:26]==6'b00_0010);
    assign _jal=(instr[31:26]==6'b00_0011);
    
//控制器部分 

reg [2:0] state;


//时序控制
   always @(negedge clk or posedge reset) begin
      if(reset)begin
        state<=0;
      end
      else begin
        case (state)
           3'd0:
              state<=1;
           3'd1:
              state<=2;
           3'd2:
              if(_j|_jal|_jr|_syscall|_break|_eret)begin
                state<=1;
              end 
              else if(_mul|_multu|_div|_divu)begin
                state<=6;
              end
              else if(_bgez)begin
                if(rs[31]==0)
                    state<=3;
                else
                    state<=1;
              end
              else begin
                state<=3;
              end
            3'd3:
             if(_beq)begin
                if(z_reg==0)begin
                    state<=4;
                end
                else begin
                    state<=1;
                end
              end
              else if(_bne)begin
                if(z_reg==0)begin
                    state<=1;
                end
                else begin
                    state<=4;
                end
              end
              else if(_teq)begin
                if(z_reg==0&&status[0]&&status[3])begin
                    state<=4;
                end
                else begin
                    state<=1;
                end
              end
              else if(_jalr|_mfhi|_mflo|_mthi|_mtlo) begin
                  state<=1;
              end
              else begin
                state<=4;
              end
            3'd4:
              if(_beq|_bne|_teq)begin
                state<=5;
              end
              else begin
                state<=1;
              end
            3'd5:
               state<=1;
            3'd6:
               if((_mul&&ready[0])||(_multu&&ready[1])||(_div&&ready[2])||(_divu&&ready[3]))begin
                  state<=7;
               end
               else begin
                  state<=6;
               end
            3'd7:
                state<=1;
        endcase
      end
    
   end


//组合逻辑控制
    //aluc
    assign aluc[3]=(state==3)&(_lui|_slt|_slti|_sltu|_sltiu|_sll|_sllv|_sra|_srav|_srl|_srlv);
    assign aluc[2]=(state==3)&(_and|_andi|_or|_ori|_xor|_xori|_nor|_sll|_sllv|_sra|_srav|_srl|_srlv);
    assign aluc[1]=((state==3)&(_add|_addi|_lw|_lh|_lhu|_lb|_lbu| _sw|_sh|_sb|_sub|_xor|_xori|_nor|_sllv|_slt|_slti|_sltu|_sltiu|_sll|_bgez))|
                   (state==1)|((state==4)&(_bne|_beq));
    assign aluc[0]=(state==3)&(_subu|_beq|_bne|_teq|_sub|_or|_ori|_nor|_slt|_slti|_srl|_srlv);
    //pc
    assign pc_in=(state==2)|((_beq|_bne|_teq)&(state==5))|((_eret|_bgez)&(state==4))|((state==3)&_jalr);
    assign pc_out=(state==1);
    //ir
    assign ir_in=(state==1);
    //z
    assign z_in=(state==1)|((state==3)&(_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|
                _srlv|_srav|_sll|_srl|_sra|_addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|
                 _sw|_sh|_sb|_beq|_bne|_teq|_clz|_eret|_bgez))|((state==4)&((_beq&z_reg==0)|(_bne&z_reg!=0)));
    //rd_temp
    assign temp_in=((state==3)&(_mfc0|_mtc0));
    //regfile
    assign rf_w=((state==4)&(_addu|_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|
                _srlv|_srav|_sll|_srl|_sra|_addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|_mfc0|_clz))
                |((state==2)&(_jal|_jalr))|((state==3)&(_mfhi|_mflo))|((state==7)&_mul);
   //hi,ho
    assign hi_w=((state==3)&_mthi)|((state==7)&((_multu&&ready[1])|(_div&&ready[2])|(_divu&&ready[3])));
    assign lo_w=((state==3)&_mtlo)|((state==7)&((_multu&&ready[1])|(_div&&ready[2])|(_divu&&ready[3])));

   //cp0
    assign cp0_w=(state==4)&_mtc0;
    assign cp0_r=(state==4)&_mfc0;
    assign eret=(state==2)&_eret;
    assign exception=status[0]&((((_break&status[2])|(_syscall&status[1])))|((_teq&status[3])&(state>3)));//异常中断信号
    assign cause=_syscall?5'b01000:(_break? 5'b01001 :(_teq ? 5'b01101:5'bz));

  //乘除法器
   assign mul_div=_mul? 2'd0:(_multu? 2'd1:(_div? 2'd2 :2'd3));//乘除法选择
   assign start[0]=_mul&(state>2);
   assign start[1]=_multu&(state>2);
   assign start[2]=(state==2)&_div;
   assign start[3]=(state==2)&_divu;

   //dmem
    assign cs=(state==4)&(_lw|_lh|_lhu|_lb|_lbu| _sw|_sh|_sb);
    assign dm_w=(state==4)&(_sw|_sh|_sb);
    assign dm_r=(state==4)&(_lw|_lh|_lhu|_lb|_lbu);
    assign choice=(_lw|_sw)? 2'b00:((_lh|_lhu|_sh)?2'b01:2'b10) ;

    //选择器控制
    assign m1[1]=(state==3)&(_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|_srlv|_srav|
                   _addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|_sw|_sh|_sb|
                   _beq|_bne|_teq);
    assign m1[0]=(state==1)|((state==4)&(_beq|_bne))|((state==3)&(_bgez));
    assign m2[1]=(state==1)|((state==4)&(_beq|_bne))|((state==3)&(_bgez));
    assign m2[0]=(state==1)|((state==3)&(_addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|_sw|_sh|_sb
                    ));
    assign m3[1]=((state==2)&(_jr|_eret|((_syscall|_break)&exception)))|((state==5)&(_teq))|((state==3)&_jalr);               
    assign m3[0]=((state==2)&(_j|_jal|_jr))|((state==3)&_jalr);
    assign m4[2]=(state==3)&(_mflo|_mfhi);
    assign m4[1]=((state==4)&(_addu|_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|_srlv|_srav|_sll|_srl|_sra|
                 _addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|_sw|_sh|_sb|_clz))|((state==2)&(_jal))|
                  ((state==2)&(_jalr));
    assign m4[0]=((state==4)&(_addu|_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|_srlv|_srav|_sll|_srl|_sra|
                 _addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_sw|_sh|_sb|_clz))|((state==2)&(_jal|_jalr))|
                  ((state==3)&(_mfhi))|((state==7)&_mul);
    assign m5[1]=((state==4)&(_addi|_addiu|_andi|_ori|_xori|_lui|_slti|_sltiu|_lw|_lh|_lhu|_lb|_lbu|_sw|_sh|_sb|_mfc0));
    assign m5[0]=((state==4)&(_addu|_addu|_subu|_add|_sub|_and|_or|_xor|_nor|_slt|_sltu|_sllv|_srlv|_srav|_sll|_srl|_sra|
                 _clz))|((state==3)&(_mfc0|_mtc0|_mfhi|_mthi|_mflo|_mtlo))|((state==7)&_mul)|((state==2)&_jalr);
    assign m6=_mul|_multu|_div|_divu;
    assign m7=(state==3)&_mtlo;
    assign m8=(state==3)&_clz;
    
    //other
    assign sign=((state==3)&(_addi|_addiu|_lw|_lh|_lhu|_lb|_lbu|_sw|_sh|_sb|_slti|_sltiu))|((state==4)&(_lh|_lb|_bne|_beq));



endmodule
