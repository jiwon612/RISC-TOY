module ID_Pipereg (
        input [31:0] PC,
        input [31:0] INST,
        input CLK, RSTN,
        input Branch_Sig,
        
        output reg [31:0] PC_out,
        output reg [31:0] INST_out
);
///////////////////CLK//////////////////

        wire [31:0] PC_temp, INST_temp;

        always @(posedge CLK or negedge RSTN) begin
                if (~RSTN) begin
                        PC_out <= 32'b0; 
                        INST_out <= 32'b0;
                end else begin
                        PC_out <= PC_temp; 
                        INST_out <= INST_temp;
                end
        end
		  
        assign PC_temp = (Branch_Sig) ? 0 : PC;
        assign INST_temp = (Branch_Sig) ? 0 : INST;
 

endmodule
