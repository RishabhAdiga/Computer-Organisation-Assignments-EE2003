module regfile ( input [4:0] rs1,     // first address
				 input [4:0] rs2,     // second address
				 input [4:0] rd,      // write address 
                 input we,            // write enable
				 input clk,           // clock
				 input reset,         // reset
				 input [31:0] wdata,  // write data
				 output [31:0] r1,    // First address read value
				 output [31:0] r2    // Second address read value
               );


    reg [31:0] regs_in [0:31];

    // initialising registers to 0
    integer i;
    initial begin
        for (i=0;i<32;i=i+1)
            regs_in[i] = 32'b0;
    end

    always @(posedge clk) begin
		if (reset)  //All registers set to 0 if reset=1
			for (i=0;i<32;i=i+1)
				regs_in[i] <= 32'b0;
		else begin
			if (we == 1'b1) begin  // if write enable is 1 then write
				if(rd == 5'd0)
					regs_in[rd] <= 32'd0;
				else
					regs_in[rd] <= wdata;
			end
		end
    end
	//Assigning outputs r1 and r2 appropriately
    assign r1 = regs_in[rs1];
    assign r2 = regs_in[rs2];

endmodule
