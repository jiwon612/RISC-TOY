module IF_Pipereg (
        input [31:0] PC,
        input wire CLK, RSTN,
        input Stall,
        
        output reg IREQ,
        output reg [31:0] PC_out

);
///////////////////CLK//////////////////

        reg [31:0] PC_temp;

        always @(posedge CLK or negedge RSTN) begin
                if (~RSTN) begin PC_out <= 0; end
                else begin PC_out <= PC_temp; end
        end

        always @ (*) begin
                if (Stall) begin IREQ = 0; PC_temp = PC; end
                else begin PC_temp = PC + 4; IREQ = RSTN; end
        end


/*
        assign PC_temp = (Branch_Sig == 1) ? PC_branch : PC + 4;
*/
endmodule