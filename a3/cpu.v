module cpu ( input clk,             // clock
             input reset,           // reset
			 output [31:0] iaddr,   // instruction address
             input [31:0] idata,    // instruction
			 output [31:0] daddr,   // data address if dmem is used
			 input [31:0] drdata,   // data read from dmem
			 output [31:0] dwdata,  // write value to dmem
			 output [3:0] dwe       // dmem write enable signals
           );

	reg [31:0] iaddr; // instruction address

    // regfile,alu and imm_gen related outputs and inputs
    wire regWrited, MEMToReg, regOrImm;
	wire [4:0] r1, r2, rd ,aluop;
	wire [31:0] wdata, r1rf, r2rf, r1alu, r2alu, out_alu, imm;
    reg [31:0] drdatarf;

    // dmem related inputs and outputs
    reg [3:0] dwe_temp;
    reg [31:0] repeatdata;

    // iaddr
    always @(posedge clk) begin
        // if reset, set to 0
        if (reset) begin
            iaddr <= 0;
        end
        else begin
            //else increment iaddr by 4
			iaddr <= iaddr + 4;
        end
    end

	// Instantiating all the modules used
    control cntrl(
		.reset(reset),
        .idata(idata),
        .dMEMToReg(dMEMToReg),
		.aluop(aluop),
		.r1(r1),
		.r2(r2),
        .rd(rd),
        .regOrImm(regOrImm),
		.regWrite(regWrite)
    );

    imm_gen ig(
        .idata(idata),
        .imm(imm)
    );

    alu alu(
		.aluop(aluop),
        .r1(r1alu),
        .r2(r2alu),
        .out(out_alu)
    );

    regfile rf(
        .clk(clk),
		.reset(reset),
        .rs1(r1),
        .rs2(r2),
        .rd(rd),
        .we(regWrite),
        .wdata(wdata),
		.r1(r1rf),
		.r2(r2rf)
    );

	//Assigning appropriate values for all wires and regs
    assign r1alu = (idata[6:0] == 7'b0010111) ? iaddr : r1rf;
    assign r2alu = (regOrImm) ? imm : r2rf;
    assign daddr = out_alu;
    assign wdata = (dMEMToReg) ? drdatarf : out_alu;
    assign dwdata = repeatdata;
    assign dwe = ~reset & dwe_temp;

    always @(idata, daddr) begin
		// STORE
        if (idata[6:0] === 7'b0100011) begin
            case(idata[14:12])
                // SB
                0: begin
					repeatdata = {4{r2rf[7:0]}};
                    case(daddr[1:0])
                        0:
                            dwe_temp = 4'b0001;
                        1:
                            dwe_temp = 4'b0010;
                        2:
                            dwe_temp = 4'b0100;
                        3:
                            dwe_temp = 4'b1000;
                    endcase
                end
                // SH
                1: begin
                    repeatdata = {2{r2rf[15:0]}};
                    case(daddr[1:0])
                        0:
                            dwe_temp = 4'b0011;
                        2:
                            dwe_temp = 4'b1100;
                        default:
                            dwe_temp = 4'b0000;
                    endcase
                end
                // SW
                2: begin
                    repeatdata = r2rf;
                    case(daddr[1:0])
                        0:
                            dwe_temp = 4'b1111;
                        default:
                            dwe_temp = 4'b0000;
                    endcase
                end
                default: begin
                    dwe_temp = 4'b0000;
					repeatdata = 0;
				end
            endcase
        end
        else
			begin 
            dwe_temp = 4'b0000;
			repeatdata = 0;
			end

        // LOAD
        if (idata[6:0] === 7'b0000011) begin
            case(idata[14:12])
                // LB
                0: begin
                    case(daddr[1:0])
                        0:
                            drdatarf = $signed(drdata[7:0]);
                        1:
                            drdatarf = $signed(drdata[15:8]);
                        2:
                            drdatarf = $signed(drdata[23:16]);
                        3:
                            drdatarf = $signed(drdata[31:24]);
                    endcase
                end
                // LH
                1: begin
                    case(daddr[1:0])
                        0:
                            drdatarf = $signed(drdata[15:0]);
                        2:
                            drdatarf = $signed(drdata[31:16]);
                        default:
                            drdatarf = 32'b0;
                    endcase
                end
                // LW
                2: begin
                    drdatarf = drdata;
                end
                // LBU
                4: begin
                    case(daddr[1:0])
                        0:
                            drdatarf = drdata[7:0];
                        1:
                            drdatarf = drdata[15:8];
                        2:
                            drdatarf = drdata[23:16];
                        3:
                            drdatarf = drdata[31:24];
                    endcase
                end
                // LHU
                5: begin
                    case(daddr[1:0])
                        0:
                            drdatarf = drdata[15:0];
                        2:
                            drdatarf = drdata[31:16];
                        default:
                            drdatarf = 32'b0;
                    endcase
                end
                default: begin
                    drdatarf = 32'b0;
                end
            endcase
        end
        else
            drdatarf = 32'b0;
    end

endmodule