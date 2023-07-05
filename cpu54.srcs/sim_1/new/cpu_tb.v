/*`timescale 1ns / 1ps

module cpu_tb();
reg clk_in;
reg reset;
wire [31:0]inst;
wire [31:0]pc;


integer file_output;

initial  begin
        file_output = $fopen("E:/vivado_project/myresult.txt");
        clk_in = 0;
        reset = 1; 
        #1.5 reset = 0; 
end

always  begin
    #0.5 clk_in=~clk_in;
end

sccomp_dataflow sccomp_dataflow_inst(clk_in,reset,inst,pc);

always @(posedge clk_in) begin
      // $fdisplay(file_output,"pc: %h",pc);
        //$fdisplay(file_output,"instr: %h",inst);
         // $fdisplay(file_output,"mem0: %h",cpu_tb.sccomp_dataflow_inst.dmem_inst.mem[0]);
        // $fdisplay(file_output,"mem1: %h",cpu_tb.sccomp_dataflow_inst.dmem_inst.mem[1]);
        $fdisplay(file_output,"regfile0: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_output,"regfile1: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_output,"regfile2: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_output,"regfile3: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_output,"regfile4: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_output,"regfile5: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_output,"regfile6: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_output,"regfile7: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_output,"regfile8: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_output,"regfile9: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_output,"regfile10: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_output,"regfile11: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_output,"regfile12: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_output,"regfile13: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_output,"regfile14: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_output,"regfile15: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_output,"regfile16: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_output,"regfile17: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_output,"regfile18: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_output,"regfile19: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_output,"regfile20: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_output,"regfile21: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_output,"regfile22: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_output,"regfile23: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_output,"regfile24: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_output,"regfile25: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_output,"regfile26: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_output,"regfile27: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_output,"regfile28: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_output,"regfile29: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_output,"regfile30: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_output,"regfile31: %h",cpu_tb.sccomp_dataflow_inst.sccpu.cpu_ref.array_reg[31]);
        $fdisplay(file_output,"pc: %h",pc);
        $fdisplay(file_output,"instr: %h",inst);
    end



endmodule
*/
`timescale 1ns / 1ps

module  _246tb_ex9_tb;

	// Inputs
	reg clk_in;
	reg reset;

	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	sccomp_dataflow uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.inst(inst),
		.pc(pc)
	);

	integer file_output;
	reg[31:0] pre_pc;
	
initial begin
		
		file_output = $fopen("E:\\vivado_project\\cpu54_result.txt");	
		// Initialize Inputs
		clk_in = 0;
		reset = 1;
        pre_pc=0;

		// Wait 100 ns for global reset to finish
		#15;
        reset = 0;		
		// Add stimulus here
		
		//#100;
		//$fclose(file_output);
	end
   
	always begin		
	#5;	
	clk_in = ~clk_in;
   
	//if(clk_in == 1'b1) begin	
  /*  if(pc!=pre_pc)  begin
            pre_pc=pc;
			$fdisplay(file_output, "pc: %h", pc);	
			$fdisplay(file_output, "instr: %h", inst);
			$fdisplay(file_output, "regfile0: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[0]);
			$fdisplay(file_output, "regfile1: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[1]);
			$fdisplay(file_output, "regfile2: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[2]);
			$fdisplay(file_output, "regfile3: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[3]);
			$fdisplay(file_output, "regfile4: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[4]);
			$fdisplay(file_output, "regfile5: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[5]);
			$fdisplay(file_output, "regfile6: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[6]);
			$fdisplay(file_output, "regfile7: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[7]);
			$fdisplay(file_output, "regfile8: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[8]);
			$fdisplay(file_output, "regfile9: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[9]);
			$fdisplay(file_output, "regfile10: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[10]);
			$fdisplay(file_output, "regfile11: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[11]);
			$fdisplay(file_output, "regfile12: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[12]);
			$fdisplay(file_output, "regfile13: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[13]);
			$fdisplay(file_output, "regfile14: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[14]);
			$fdisplay(file_output, "regfile15: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[15]);
			$fdisplay(file_output, "regfile16: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[16]);
			$fdisplay(file_output, "regfile17: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[17]);
			$fdisplay(file_output, "regfile18: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[18]);
			$fdisplay(file_output, "regfile19: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[19]);
			$fdisplay(file_output, "regfile20: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[20]);
			$fdisplay(file_output, "regfile21: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[21]);
			$fdisplay(file_output, "regfile22: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[22]);
			$fdisplay(file_output, "regfile23: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[23]);
			$fdisplay(file_output, "regfile24: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[24]);
			$fdisplay(file_output, "regfile25: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[25]);
			$fdisplay(file_output, "regfile26: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[26]);
			$fdisplay(file_output, "regfile27: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[27]);
			$fdisplay(file_output, "regfile28: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[28]);
			$fdisplay(file_output, "regfile29: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[29]);
			$fdisplay(file_output, "regfile30: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[30]);
			$fdisplay(file_output, "regfile31: %h", _246tb_ex9_tb.uut.sccpu.cpu_ref.array_reg[31]);
			//$fdisplay(file_output, "pc: %h", pc-32'h0040_0000);	
			//$fdisplay(file_output, "pc: %h", pc);	
			//$fdisplay(file_output, "instr: %h", inst);
		end*/
	end
endmodule

