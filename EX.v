module EX (
        input signed [31:0] data1, //RB
        input signed [31:0] data2, //RC, RA
        input [31:0] PC,
        input wire [4:0] OpCode,
        input wire [21:0] IMM, //will be cutted in execution process
        input [1:0] ImmSel1, //EX signal

        output [31:0] Result
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



        wire ExtSel; //Decide between Zero extent and Sign extent
        reg [1:0] ImmSel2; //Decide between ExtIMM11/ExtIMM17/ExtIMM22

        reg [21:0] IMM22;
        reg [16:0] IMM17;
        reg [10:0] IMM11;
        
        reg [31:0] ExtIMM11;
        reg [31:0] ExtIMM17;
        reg [31:0] ExtIMM22;

        reg signed [31:0] ExtIMM_out; //this goes into ALU as an immediate value

        reg RB_32; //used in LD and ST. 1 when RB is 5'b11111
        
        assign ExtSel = (((OpCode == LD) || (OpCode == ST)) && (data1 == 5'b11111)) ? 1'b0 : 1'b1; //Decide between Zero extent and Sign extent

        always @ (*) begin
                ExtIMM11 =0;
                ExtIMM17 =0;
                ExtIMM22 =0;
                case(ImmSel1)
                        0: IMM11 = IMM[10:0]; //IMM11
                        1: IMM17 = IMM[16:0]; //IMM17
                        2: IMM22 = IMM[21:0]; //IMM22
                        default: begin IMM11 = 0; IMM17 = 0; IMM22 = 0; end
                endcase

                case(ExtSel)
                        1: begin 
                                ExtIMM11 = {{21{IMM11[10]}}, IMM11}; //Sign Extension
                                ExtIMM17 = {{15{IMM17[16]}}, IMM17}; 
                                ExtIMM22 = {{10{IMM22[21]}}, IMM22}; 
                        end
                        0: begin 
                                ExtIMM11 = {{21{1'b0}}, IMM11}; // Zero Extension
                        end
                endcase
        end

        //Decide final Immediate output
        always @ (*) begin
                if ((OpCode == ADDI) || (OpCode == ANDI) || (OpCode == ORI) || (OpCode == LD) || (OpCode == ST) || (OpCode == MOVI)) begin
                        ExtIMM_out = ExtIMM17;
                end else if ((OpCode == J) || (OpCode == JL) || (OpCode == LDR) || (OpCode == STR)) begin
                        ExtIMM_out = ExtIMM22;
                end else begin
                        ExtIMM_out = ExtIMM11;
                end
        end

        ALU U1(.data1(data1), .data2(data2), .IMM(ExtIMM_out), .PC(PC), .OpCode(OpCode), 
                .Result(Result), .RB_32(RB_32));

        //Decide whether RB is 5'b11111.
        always @ (*) begin
                if (IMM[21:17] == 5'b11111) begin RB_32 = 1; end
                else begin RB_32 = 0; end
        end


endmodule

///////////////////////////// ALU ////////////////////////////////////

module ALU (
        input signed [31:0] data1,
        input signed [31:0] data2,
        input [31:0] IMM,
        input [31:0] PC,
        input [4:0] OpCode,
        input RB_32,

        output reg [31:0] Result
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
/////////////////// PC ///////////////////////
                        BR = 5'd15,
                        BRL = 5'd16,
                        J = 5'd17,
                        JL = 5'd18,

                        LD = 5'd19,
                        LDR = 5'd20,
                        ST = 5'd21,
                        STR = 5'd22;

        always @ (*) begin
                case (OpCode)
                        ADDI: Result = data1 + IMM;
                        ANDI: Result = data1 & IMM;
                        ORI: Result = data1 | IMM;
                        MOVI: Result = IMM;

                        ADD: Result = data1 + data2;
                        SUB: Result = data1 - data2;
                        AND: Result = data1 & data2;
                        OR: Result = data1 | data2;
                        XOR: Result = data1 ^ data2;
                        NEG: Result = ~data2 + 1'b1;
                        NOT: Result = ~data2;
                        LSR: Result = (IMM[5] == 0) ? (data1 >> IMM[4:0]) : (data1 >> data2);
                        ASR: Result = (IMM[5] == 0) ? (data1 >>> IMM[4:0]) : (data1 >>> data2);
                        SHL: Result = (IMM[5] == 0) ? (data1 << IMM[4:0]) : (data1 << data2);
                        ROR: begin
                                if (IMM[5] == 0) begin
                                        Result = (data1 >> IMM[4:0]) | (data1 << (32 - IMM[4:0]));
                                end else begin
                                        Result = (data1 >> (data2[4:0])) | (data1 << (32 - data2[4:0]));
                                
                                end
                        end

                        BRL: Result = PC;
                        JL: Result = PC;
                        LD: begin if (RB_32 == 1) begin Result = IMM; end else begin Result = IMM + data1; end end
                        LDR: Result = PC + IMM;
                        ST: begin if (RB_32 == 1) begin Result = IMM; end else begin Result = data1 + IMM; end end
                        STR: Result = PC + IMM;
                        default: Result = 0;
                endcase
        end

endmodule






