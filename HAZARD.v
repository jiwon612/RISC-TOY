module HAZARD (
        input RegWrite_ID, MemtoReg_ID,
                RegWrite_EX, MemtoReg_EX,
                RegWrite_MEM, MemtoReg_MEM,
                Branch,
                MemWrite_EX, MemWrite_MEM,

        input [4:0]     RA_ID, RB_ID, RC_ID,
                        RA_EX, RB_EX, RC_EX,
                        RA_MEM, RB_MEM, RC_MEM,
                        RA_WB,
        input [31:0]    INST_IF,

        output reg Stall,
        output reg [1:0] Forward_A, Forward_B, Branch_Forward_A, Branch_Forward_B

);

        
        reg RegWrite_EX_sig, RegWrite_ID_reg;

        wire [4:0] RB_IF, RC_IF;
        assign RB_IF = INST_IF[21:17];
        assign RC_IF = INST_IF[16:12];

        always @ (*) begin
                Forward_A = 0; Forward_B = 0;

                if (((RegWrite_EX == 1) && (MemtoReg_EX == 0)) || MemWrite_EX) begin //not LD or LDR
                        if ((((RegWrite_MEM == 1) && (MemtoReg_MEM == 0)) || MemWrite_MEM) && ((RA_WB == RB_MEM) || (RA_WB == RC_MEM)) 
                        && ((RA_WB == RB_EX)|| (RA_WB == RC_EX)) && ((RA_MEM == RB_MEM) || (RA_MEM == RC_MEM)))
                        begin
                                if (RA_MEM == RB_EX) begin Forward_A = 2'b01; end
                                if(RA_MEM == RC_EX) begin Forward_B = 2'b01; end
                                
                        end 
                        else begin
                                if (RA_MEM == RB_EX) begin Forward_A = 2'b01; end
                                if (RA_MEM == RC_EX) begin Forward_B = 2'b01; end
                                if (RA_WB == RB_EX) begin Forward_A = 2'b10; end
                                if (RA_WB == RC_EX) begin Forward_B = 2'b10; end
                        end
                end
                
        end

        always @ (*) begin
                Stall = 0; 
                if ((RegWrite_ID == 1) && (MemtoReg_ID == 1)) begin //LD or LDR -> Need to Stall for 1 instruction
                        if (RA_ID == RB_IF) begin Stall = 1; end
                        if (RA_ID == RC_IF) begin Stall = 1; end
                end

                Branch_Forward_A = 0;
                Branch_Forward_B = 0;
                //forward hazard in branch operation -> stall until ra value is saved to REGFILE
                if (Branch) begin
                        if (RA_EX == RB_ID) begin Branch_Forward_A = 2'b01; end
                        if (RA_EX == RC_ID) begin Branch_Forward_B = 2'b01; end
                        if (RA_MEM == RB_ID) begin Branch_Forward_A = 2'b10; end
                        if (RA_MEM == RC_ID) begin Branch_Forward_B = 2'b10; end
                end
        end


endmodule