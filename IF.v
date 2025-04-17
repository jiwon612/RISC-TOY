module IF (
        input [31:0] PC, 
        input RSTN,
        input Branch_Sig,
        input [31:0] PC_branch,

        output reg [31:0] PC_out
);
        wire [31:0] PC_temp;

        always @ (*) begin
                if (~RSTN) begin PC_out = 0; end
                else begin PC_out = PC_temp; end
        end
        
        assign PC_temp = (Branch_Sig == 1) ? PC_branch : PC;


endmodule