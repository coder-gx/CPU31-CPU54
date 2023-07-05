`timescale 1ns / 1ps


module top_tb();
    reg clk;
reg reset;
wire [31:0]inst;
wire [31:0]pc;
wire[7:0] o_seg,o_sel;
    
    initial  begin
        clk = 0;
        reset = 1; #5 reset = 0; 
    end
    
    
    always begin
        #5 clk = ~clk;
    end
    
top top_inst(clk,reset,o_seg,o_sel);

    
endmodule