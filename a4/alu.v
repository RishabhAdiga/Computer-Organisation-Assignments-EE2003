//Module for Arithmetic Logic Unit
module alu ( 
	input [4:0] aluop,     //alu operation instruction
	input [31:0] r1,       //input 1 to alu
	input [31:0] r2,       //input 2 to alu
	output [31:0] out      //output
    );
	reg [31:0] out;
	  
	always @(aluop, r1, r2) begin
		  case (aluop)
			0 : out = r1 + r2; //ADD
			1 : out = r1 << r2; //SLL
			2 : if ($signed(r1) < $signed(r2))
                    out = 32'b1;
                else
                    out = 32'b0; //SLT
			3 : if (r1 < r2)
                    out = 32'b1;
                else
                    out = 32'b0; //SLTU
			4 : out = r1 ^ r2; //XOR
			5 : out = r1 >> r2; //SRL
			6 : out = r1 | r2; //OR
			7 : out = r1 & r2; //AND
			8 : out = $signed(r1) >>> r2; //SRA
			9 : out = r1 - r2; //SUB
			default: out = 32'b0;
		  endcase
		end
endmodule
		