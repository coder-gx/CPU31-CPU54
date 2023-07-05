module clz(
    input [31:0]rs,
    output reg[31:0] oclz
    );

    always@(*)begin
        if(rs[31])
           oclz=0;
        else if(rs[30])
           oclz=1;
        else if(rs[29])
           oclz=2;
        else if(rs[28])
           oclz=3;
        else if(rs[27])
           oclz=4;
        else if(rs[26])
           oclz=5;
        else if(rs[25])
           oclz=6;
        else if(rs[24])
           oclz=7;
        else if(rs[23])
           oclz=8;
        else if(rs[22])
           oclz=9;
        else if(rs[21])
           oclz=10;
        else if(rs[20])
           oclz=11;
        else if(rs[19])
           oclz=12;
        else if(rs[18])
           oclz=13;
        else if(rs[17])
           oclz=14;
        else if(rs[16])
           oclz=15;
        else if(rs[15])
           oclz=16;
        else if(rs[14])
           oclz=17;
        else if(rs[13])
           oclz=18;
        else if(rs[12])
           oclz=19;
        else if(rs[11])
           oclz=20;
        else if(rs[10])
           oclz=21;
        else if(rs[9])
           oclz=22;
        else if(rs[8])
           oclz=23;
        else if(rs[7])
           oclz=24;
        else if(rs[6])
           oclz=25;
        else if(rs[5])
           oclz=26;
        else if(rs[4])
           oclz=27;
        else if(rs[3])
           oclz=28;
        else if(rs[2])
           oclz=29;
        else if(rs[1])
           oclz=30;
        else if(rs[0])
           oclz=31;
        else 
           oclz=32;
    end
endmodule
