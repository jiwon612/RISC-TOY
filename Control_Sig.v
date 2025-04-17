module Control_Sig(
        input [4:0] OpCode,

        output [1:0] ImmSel1,
        output Branch,
        output MemRead,
        output MemWrite,
        output RegWrite,
        output MemtoReg
);

        parameter [4:0] ADDI = 5'd0,
                        ANDI = 5'd1,
                        ORI = 5'd2,
                        MOVI = 5'd3,
                        ADD = 5'd4,
                        SUB = 5'd5,
                        NEG = 5'd6,
                        NOT = 5'd7,
                        AND = 5'd8,
                        OR = 5'd9,
                        XOR = 5'd10,
                        LSR = 5'd11,
                        ASR = 5'd12,
                        SHL = 5'd13,
                        ROR = 5'd14,
                        BR = 5'd15,
                        BRL = 5'd16,
                        J = 5'd17,
                        JL = 5'd18,
                        LD = 5'd19,
                        LDR = 5'd20,
                        ST = 5'd21,
                        STR = 5'd22;

        reg [1:0] Imm_1;

        always @ (*) begin
                case (OpCode)
                        ADDI : Imm_1 = 2'b01;      
                        ANDI : Imm_1 = 2'b01; 
                        ORI : Imm_1 = 2'b01; 
                        MOVI : Imm_1 = 2'b01; 
                        ADD : Imm_1 = 2'b00; 
                        SUB : Imm_1 = 2'b00; 
                        NEG : Imm_1 = 2'b00; 
                        NOT : Imm_1 = 2'b00; 
                        AND : Imm_1 = 2'b00; 
                        OR : Imm_1 = 2'b00; 
                        XOR : Imm_1 = 2'b00;  
                        LSR : Imm_1 = 2'b00; 
                        ASR : Imm_1 = 2'b00;  
                        SHL : Imm_1 = 2'b00;  
                        ROR : Imm_1 = 2'b00; 
                        BR : Imm_1 = 2'b00;  
                        BRL : Imm_1 = 2'b00; 
                        J : Imm_1 = 2'b10; 
                        JL : Imm_1 = 2'b10; 
                        LD : Imm_1 = 2'b01; 
                        LDR : Imm_1 = 2'b10; 
                        ST : Imm_1 = 2'b01; 
                        STR : Imm_1 = 2'b10; 
                        default: Imm_1 = 2'b00;
                endcase
        end

        assign ImmSel1 = Imm_1;
        assign Branch = (OpCode == BR) | (OpCode == BRL) | (OpCode == J) | (OpCode == JL);
        assign RegWrite = ~(OpCode == BR) & ~(OpCode == J) & ~(OpCode == ST) & ~(OpCode == STR);
        assign MemtoReg = (OpCode == LD) | (OpCode == LDR);
        assign MemRead = (OpCode == LD) | (OpCode == LDR);
        assign MemWrite = (OpCode == ST) | (OpCode == STR);

endmodule
