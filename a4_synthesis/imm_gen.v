//Module for generation of immediate values
module imm_gen ( input [31:0] idata,     // instruction
                output [31:0] imm       // immediate value
              );


    reg [31:0] imm;

    always @(idata) begin
		case(idata[6:0])     // Different cases correspond to different instructions
            7'b0110111,
            7'b0010111: //LUI and AUIPC
                imm = {idata[31:12], 12'd0};
            7'b0100011: //STORE
                imm = $signed({idata[31:25], idata[11:7]});
            7'b0000011: //LOAD
                imm = $signed(idata[31:20]);
            7'b0010011: //IMMEDIATE ALU OPS
                case(idata[14:12])
                    0,
                    2,
                    3,
                    4,
                    6,
                    7: // ADDI,SLTI,SLTIU,XORI,ORI,ANDI
                        imm = $signed(idata[31:20]);
                    1,
                    5: // SLLI,SRLI,SRAI
                        imm = {27'b0, idata[24:20]};
                endcase
            7'b0110011: //ALU OPS
                imm = 32'b0;
			7'b1101111: //JAL
                imm = $signed({idata[31], idata[19:12], idata[20], idata[30:21], 1'b0});
			7'b1100111: //JALR
                imm = $signed(idata[31:20]);
            7'b1100011: //BRANCH
                imm = $signed({idata[31], idata[7], idata[30:25], idata[11:8], 1'b0});
            default:
                imm = 32'b0;
        endcase
    end

endmodule
