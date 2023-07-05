module decoder_control(
    input[31:0] instr,//指令
    input zero,
    output rf_w,
    output m1,
    output m2,
    output [1:0] m3,
    output [1:0] m4,
    output [1:0] m5,
    output cs,
    output dm_w,
    output dm_r,
    output sign,
    output [3:0] aluc//各种运算操作
    );
    //r型操作指令
    wire r_add,r_addu,r_sub,r_subu,r_and,r_or,r_xor,r_nor,r_slt,r_sltu;
    wire r_sll,r_srl,r_sra,r_sllv,r_srlv,r_srav;
    wire jr,i_addi,i_addiu,i_andi,i_beq,i_bne,i_ori,i_xori,i_lui,i_lw;
    wire i_sw,i_slti,i_sltiu,j,jal;

    assign r_add=(instr[31:26]==0)&&(instr[5:0]==6'b10_0000);
    assign r_addu=(instr[31:26]==0)&&(instr[5:0]==6'b10_0001);
    assign r_sub=(instr[31:26]==0)&&(instr[5:0]==6'b10_0010);
    assign r_subu=(instr[31:26]==0)&&(instr[5:0]==6'b10_0011);
    assign r_and=(instr[31:26]==0)&&(instr[5:0]==6'b10_0100);
    assign r_or=(instr[31:26]==0)&&(instr[5:0]==6'b10_0101);
    assign r_xor=(instr[31:26]==0)&&(instr[5:0]==6'b10_0110);
    assign r_nor=(instr[31:26]==0)&&(instr[5:0]==6'b10_0111);
    assign r_slt=(instr[31:26]==0)&&(instr[5:0]==6'b10_1010);
    assign r_sltu=(instr[31:26]==0)&&(instr[5:0]==6'b10_1011);
    assign r_sll=(instr[31:26]==0)&&(instr[5:0]==6'b00_0000);
    assign r_srl=(instr[31:26]==0)&&(instr[5:0]==6'b00_0010);
    assign r_sra=(instr[31:26]==0)&&(instr[5:0]==6'b00_0011);
    assign r_sllv=(instr[31:26]==0)&&(instr[5:0]==6'b00_0100);
    assign r_srlv=(instr[31:26]==0)&&(instr[5:0]==6'b00_0110);
    assign r_srav=(instr[31:26]==0)&&(instr[5:0]==6'b00_0111);
    

    assign jr=(instr[31:26]==0)&&(instr[5:0]==6'b00_1000);

    //i型操作指令
    assign i_addi=(instr[31:26]==6'b00_1000);
    assign i_addiu=(instr[31:26]==6'b00_1001);
    assign i_andi=(instr[31:26]==6'b00_1100);
    assign i_ori=(instr[31:26]==6'b00_1101);
    assign i_xori=(instr[31:26]==6'b00_1110);
    assign i_lui=(instr[31:26]==6'b00_1111);
    assign i_lw=(instr[31:26]==6'b10_0011);
    assign i_sw=(instr[31:26]==6'b10_1011);
    assign i_beq=(instr[31:26]==6'b00_0100);
    assign i_bne=(instr[31:26]==6'b00_0101);
    assign i_slti=(instr[31:26]==6'b00_1010);
    assign i_sltiu=(instr[31:26]==6'b00_1011);

    //j型操作指令
    assign j=(instr[31:26]==6'b00_0010);
    assign jal=(instr[31:26]==6'b00_0011);
    
    

    //aluc
    assign aluc[3]=i_lui|r_slt|i_slti|r_sltu|i_sltiu|r_sll|r_sllv|r_sra|r_srav|r_srl|r_srlv;
    assign aluc[2]=r_and|i_andi|r_or|i_ori|r_xor|i_xori|r_nor|r_sll|r_sllv|r_sra|r_srav|r_srl|r_srlv;
    assign aluc[1]=r_add|i_addi|i_lw|i_sw|r_sub|r_xor|i_xori|r_sllv|r_nor|r_slt|i_slti|r_sltu|i_sltiu|r_sll;
    assign aluc[0]=r_subu|i_beq|i_bne|r_sub|r_or|i_ori|r_nor|r_slt|i_slti|r_srl|r_srlv;
    //选择器控制
    assign m1=(r_sll|r_srl|r_sra)? 0:1;
    assign m2=(i_addi|i_addiu|i_andi|i_ori|i_xori|i_lui|i_lw|i_sw|i_slti|i_sltiu);
    assign m3[1]=(i_beq&&(zero==1))|(i_bne&&(zero==0))|jr;
    assign m3[0]=(i_beq&&(zero==1))|(i_bne&&(zero==0))|j|jal ? 0:1;
    assign m4[1]=(i_lw|i_sw|i_beq|i_bne|jal) ? 0:1;
    assign m4[0]=i_lw;
    assign m5[1]=(i_addi|i_addiu|i_andi|i_ori|i_xori|i_lui|i_lw|i_slti|i_sltiu);
    assign m5[0]=(r_addu|r_add|r_subu|r_sub|r_and|r_or|r_xor|r_nor|r_slt|r_sltu|r_sll|r_srl|r_sra|r_sllv|r_srlv|r_srav);

    //dmem
    assign cs=i_lw|i_sw;
    assign dm_w=i_sw;
    assign dm_r=i_lw;
    assign rf_w=(i_sw|i_beq|i_bne|j|jr)? 0:1;

    //other
    assign sign=(i_addi|i_addiu|i_lw|i_sw|i_slti|i_sltiu);



endmodule
