module multu(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    output mul_ready,
    output [63:0] oz
    );
 
    wire [7:0] ready;
    wire [15:0] mul8_ready;
    assign mul_ready=ready[0];
    
    wire [7:0] c00,ab00,c01,ab01,c02,ab02,c03,ab03;
    wire [7:0] c10,ab10,c11,ab11,c12,ab12,c13,ab13;
    wire [7:0] c20,ab20,c21,ab21,c22,ab22,c23,ab23;
     wire [7:0] c30,ab30,c31,ab31,c32,ab32,c33,ab33;
     wire [7:0] c0,c1,c2,c3,c4,c5,c6,c7;
      wire [7:0] s0,s1,s2,s3,s4,s5,s6,s7;

    mul_8 mul_00(clk,reset,a[7:0],b[7:0],c00,ab00,mul8_ready[0]);
    mul_8 mul_01(clk,reset,a[7:0],b[15:8],c01,ab01,mul8_ready[1]);
    mul_8 mul_02(clk,reset,a[7:0],b[23:16],c02,ab02,mul8_ready[2]);
    mul_8 mul_03(clk,reset,a[7:0],b[31:24],c03,ab03,mul8_ready[3]);
    mul_8 mul_10(clk,reset,a[15:8],b[7:0],c10,ab10,mul8_ready[4]);
    mul_8 mul_11(clk,reset,a[15:8],b[15:8],c11,ab11,mul8_ready[5]);
    mul_8 mul_12(clk,reset,a[15:8],b[23:16],c12,ab12,mul8_ready[6]);
    mul_8 mul_13(clk,reset,a[15:8],b[31:24],c13,ab13,mul8_ready[7]);
    mul_8 mul_20(clk,reset,a[23:16],b[7:0],c20,ab20,mul8_ready[8]);
    mul_8 mul_21(clk,reset,a[23:16],b[15:8],c21,ab21,mul8_ready[9]);
    mul_8 mul_22(clk,reset,a[23:16],b[23:16],c22,ab22,mul8_ready[10]);
    mul_8 mul_23(clk,reset,a[23:16],b[31:24],c23,ab23,mul8_ready[11]);
    mul_8 mul_30(clk,reset,a[31:24],b[7:0],c30,ab30,mul8_ready[12]);
    mul_8 mul_31(clk,reset,a[31:24],b[15:8],c31,ab31,mul8_ready[13]);
    mul_8 mul_32(clk,reset,a[31:24],b[23:16],c32,ab32,mul8_ready[14]);
    mul_8 mul_33(clk,reset,a[31:24],b[31:24],c33,ab33,mul8_ready[15]);
    
    add_8 add0(clk,reset&mul8_ready[0],{8'b0,ab00},16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,c0,s0,ready[0]);
    add_8 add1(clk,reset&mul8_ready[0],{8'b0,ab01},{8'b0,ab10},{8'b0,c00},16'b0,16'b0,16'b0,16'b0,c1,s1,ready[1]);
    add_8 add2(clk,reset&mul8_ready[0],{8'b0,ab02},{8'b0,ab11},{8'b0,ab20},{8'b0,c01},{8'b0,c10},16'b0,16'b0,c2,s2,ready[2]); 
    add_8 add3(clk,reset&mul8_ready[0],{8'b0,ab03},{8'b0,ab12},{8'b0,ab21},{8'b0,ab30},{8'b0,c02},{8'b0,c20},{8'b0,c11},c3,s3,ready[3]);
    add_8 add4(clk,reset&mul8_ready[0],{8'b0,ab13},{8'b0,ab22},{8'b0,ab31},{8'b0,c03},{8'b0,c30},{8'b0,c12},{8'b0,c21},c4,s4,ready[4]);
    add_8 add5(clk,reset&mul8_ready[0],{8'b0,ab23},{8'b0,ab32},{8'b0,c13},{8'b0,c31},{8'b0,c22},16'b0,16'b0,c5,s5,ready[5]);
    add_8 add6(clk,reset&mul8_ready[0],{8'b0,ab33},{8'b0,c23},{8'b0,c32},16'b0,16'b0,16'b0,16'b0,c6,s6,ready[6]); 
    add_8 add7(clk,reset&mul8_ready[0],{8'b0,c33},16'b0,16'b0,16'b0,16'b0,16'b0,16'b0,c7,s7,ready[7]);
    

    assign oz={s7,s6,s5,s4,s3,s2,s1,s0}+{c6,c5,c4,c3,c2,c1,c0,8'b0};

    


endmodule

