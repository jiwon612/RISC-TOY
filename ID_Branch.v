module ID_Branch(
    input signed [31:0] data1, 
    input signed [31:0] data2,
    input [21:0] IMM, 
    input [31:0] PC,
    input [4:0] OpCode,
    input Branch,

    output reg [31:0] PC_out,
    output Branch_Sig_out 
);

    parameter [4:0] BR = 5'd15,
                    BRL = 5'd16,
                    J = 5'd17,
                    JL = 5'd18;

    reg Branch_Sig;

/*
    wire [31:0] ExtIMM22;
    assign ExtIMM22 = {{10{IMM[21]}}, IMM}; //Sign Extension
*/

    always @(*) begin

        case (OpCode)
            BR: begin
                case(IMM[2:0])
                    1: begin PC_out = data1; Branch_Sig = 1'b1; end
                    2: begin 
                            if (data2 == 0) begin PC_out = data1; Branch_Sig = 1'b1; end
                            else begin PC_out = 0; Branch_Sig = 0; end 
                            end
                    3: begin 
                            if (data2 != 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    4: begin 
                            if (data2 >= 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    5: begin 
                            if (data2 < 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    default: begin PC_out = 0; Branch_Sig = 1'b0; end
                endcase
            end
            BRL: begin
                case(IMM[2:0])
                    1: begin PC_out = data1; Branch_Sig = 1'b1; end
                    2: begin 
                            if (data2 == 0) begin PC_out = data1; Branch_Sig = 1'b1; end
                            else begin PC_out = 0; Branch_Sig = 0; end 
                            end
                    3: begin 
                            if (data2 != 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    4: begin 
                            if (data2 >= 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    5: begin 
                            if (data2 < 0) begin PC_out = data1; Branch_Sig = 1'b1; end 
                            else begin PC_out = 0; Branch_Sig = 0; end
                            end
                    default: begin PC_out = 0; Branch_Sig = 1'b0; end
                endcase
            end
            J: begin PC_out = PC + IMM; Branch_Sig = 1'b1; end
            JL: begin PC_out = PC + IMM; Branch_Sig = 1'b1; end
            default: begin Branch_Sig = 0; PC_out = 0; end
        endcase     
    end           

    //Decide whether to Branch or not
    assign Branch_Sig_out = Branch & Branch_Sig;

endmodule