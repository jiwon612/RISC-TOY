module ID(
        input [31:0] INST,

        output [4:0] OpCode,
        output [21:0] IMM,
        output [1:0] ImmSel1,
        output Branch,
        output MemRead,
        output MemWrite,
        output RegWrite,
        output MemtoReg,
        output [4:0] Write_Addr,
        output reg [4:0] Read_Addr1, Read_Addr2
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

        always @(*) begin
                case(OpCode)
                        ADDI: Read_Addr1 = INST[21:17]; //RB
                        ANDI: Read_Addr1 = INST[21:17];
                        ORI: Read_Addr1 = INST[21:17];
                        ADD: Read_Addr1 = INST[21:17];
                        SUB: Read_Addr1 = INST[21:17];
                        AND: Read_Addr1 = INST[21:17];
                        OR: Read_Addr1 = INST[21:17];
                        XOR: Read_Addr1 = INST[21:17];
                        LSR: Read_Addr1 = INST[21:17];
                        ASR: Read_Addr1 = INST[21:17];
                        SHL: Read_Addr1 = INST[21:17];
                        ROR: Read_Addr1 = INST[21:17];
                        BR: Read_Addr1 = INST[21:17];
                        BRL: Read_Addr1 = INST[21:17];
                        LD: Read_Addr1 = INST[21:17];
                        ST: Read_Addr1 = INST[21:17];
                        default: Read_Addr1 = 5'b0;
                endcase

                case(OpCode)
                        ADD: Read_Addr2 = INST[16:12]; //RC
                        SUB: Read_Addr2 = INST[16:12];
                        NEG: Read_Addr2 = INST[16:12];
                        NOT: Read_Addr2 = INST[16:12];
                        AND: Read_Addr2 = INST[16:12];
                        OR: Read_Addr2 = INST[16:12];
                        XOR: Read_Addr2 = INST[16:12];
                        LSR: Read_Addr2 = INST[16:12];
                        ASR: Read_Addr2 = INST[16:12];
                        SHL: Read_Addr2 = INST[16:12];
                        ROR: Read_Addr2 = INST[16:12];
                        BR: Read_Addr2 = INST[16:12];
                        BRL: Read_Addr2 = INST[16:12];
                        ST: Read_Addr2 = INST[26:22]; //RA
                        STR: Read_Addr2 = INST[26:22]; //RA
                        default: Read_Addr2 = 5'b0;
                endcase
        end

        assign OpCode = INST [31:27];
        assign IMM = INST [21:0];
        assign Write_Addr = INST[26:22];



        Control_Sig U0 (.OpCode(OpCode), .ImmSel1(ImmSel1), .Branch(Branch), .MemRead(MemRead), .MemWrite(MemWrite), 
                        .RegWrite(RegWrite), .MemtoReg(MemtoReg));


endmodule