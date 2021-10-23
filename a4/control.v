module control ( input reset,           // reset
				 input [31:0] idata,    // instruction
                 output dMEMToReg,      // read from dmem to write into register
				 output [4:0] aluop,    // ALU operations instructions
				 output [4:0] r1,       // register1 address
				 output [4:0] r2,       // register2 address
                 output [4:0] rd,       // regfile write address
                 output regOrImm,       // read from regfile or ALU
                 output regWrite,       // regfile write signal
				 output br,             // signal for branch
                 output jmp             // signal for jump
               );

    reg dMEMToReg, regOrImm, regWrite, br, jmp;
    reg [4:0] aluop;
    reg [4:0] r1, r2, rd;

    always @(idata) begin
		case(idata[6:0])
			7'b0110111,
			7'b0010111: begin  //LUI and AUIPC
						dMEMToReg = 1'b0;
						aluop = 5'd0;
						r1 = 5'd0;
						r2 = 5'd0;
						rd = idata[11:7];
						regOrImm = 1'b1;
						regWrite = 1'b1;
						br = 1'b0;
						jmp = 1'b0;
						end

			7'b1100011: begin  //BRANCH
						br = 1'b1;
						jmp = 1'b0;
						dMEMToReg = 1'b0;
						case(idata[14:12])
							0:   // BEQ
								aluop = 6'd9;
							1:   // BNE
								aluop = 6'd9;
							4:   // BLT
								aluop = 6'd2;
							5:   // BGE
								aluop = 6'd2;
							6:   // BLTU
								aluop = 6'd3;
							7:   // BGEU
								aluop = 6'd3;
							default:
								aluop = 6'd15;
						endcase
						r1 = idata[19:15];
						r2 = idata[24:20];
						rd = 5'd0;
						regOrImm = 1'b0;
						regWrite = 1'b0;
						end

			7'b1101111: begin  //JAL
						br = 1'b0;
						jmp = 1'b1;
						dMEMToReg = 1'b0;
						aluop = 6'd0;
						r1 = 5'd0;
						r2 = 5'd0;
						rd = idata[11:7];
						regOrImm = 1'b0;
						regWrite = 1'b1;
						end

			7'b1100111: begin  //JALR
						br = 1'b0;
						jmp = 1'b1;
						dMEMToReg = 1'b0;
						aluop = 6'd0;
						r1 = idata[19:15];
						r2 = 5'd0;
						rd = idata[11:7];
						regOrImm = 1'b0;
						regWrite = 1'b1;
						end

			7'b0100011: begin  //STORE
						dMEMToReg = 1'b0;
						aluop = 5'd0;
						r1 = idata[19:15];
						r2 = idata[24:20];
						rd = 5'd0;
						regOrImm = 1'b1;
						regWrite = 1'b0;
						br = 1'b0;
						jmp = 1'b0;
						end

			7'b0000011: begin  //LOAD
						dMEMToReg = 1'b1;
						aluop = 5'd0;
						r1 = idata[19:15];
						r2 = 5'd0;
						rd = idata[11:7];
						regOrImm = 1'b1;
						regWrite = 1'b1;
						br = 1'b0;
						jmp = 1'b0;
						end		

			7'b0010011: begin  //IMMEDIATE
						dMEMToReg = 1'b0;
						case (idata[14:12])
							0,   // ADDI
							2,   // SLTI
							3,   // SLTU
							4,   // XORI
							6,   // ORI
							7:   // ANDI
								aluop = {2'd0, idata[14:12]};
							1:   // SLLI
								aluop = {2'd0, idata[14:12]};
							5:   // SRLI or SRAI
								aluop = (idata[30]) ? 5'd8:5'd5;
							default:
								aluop = {2'd0, idata[14:12]};
						endcase
						r1 = idata[19:15];
						r2 = 5'd0;
						rd = idata[11:7];
						regOrImm = 1'b1;
						regWrite = 1'b1;
						br = 1'b0;
						jmp = 1'b0;
						end

			7'b0110011: begin  //ALU OPS
						dMEMToReg = 1'b0;
						case(idata[14:12])
							1,   // SLL
							2,   // SLT
							3,   // SLTU
							4,   // XOR
							6,   // OR
							7:   // AND
								aluop = {2'd0, idata[14:12]};
							0:   // ADD or SUB
								aluop = (idata[30]) ? 5'd9:5'd0;
							5:   // SRL or SRA
								aluop = (idata[30]) ? 5'd8:5'd5;
							default:
								aluop = {2'd0, idata[14:12]};
						endcase
						r1 = idata[19:15];
						r2 = idata[24:20];
						rd = idata[11:7];
						regOrImm = 1'b0;
						regWrite = 1'b1;
						br = 1'b0;
						jmp = 1'b0;
						end

				default: begin // everything is 0
						dMEMToReg = 1'b0;
						aluop = 5'd0;
						r1 = 5'd0;
						r2 = 5'd0;
						rd = 5'd0;
						regOrImm = 1'b0;
						regWrite = 1'b0;
						br = 1'b0;
						jmp = 1'b0;
						end
			endcase
		end
endmodule
