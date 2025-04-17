module MEM_Piperegs(
        input CLK, RSTN,
        input [31:0] PC, //PC + 4
        input [4:0] OpCode,
        
        input MemRead, //MEM signal
        input MemWrite, //MEM signal
        input RegWrite, //WB signal
        input MemtoReg, //WB signal     
        input [4:0] Write_Addr, Read_Addr1, Read_Addr2,

        input [31:0] Result, Addr1_data, Addr2_data,

        output reg [31:0] PC_out,
        output reg [4:0] OpCode_out,

        output reg MemRead_out, //MEM signal
        output reg MemWrite_out, //MEM signal
        output reg RegWrite_out, //WB signal
        output reg MemtoReg_out, //WB signal 
        output reg [4:0] Write_Addr_out, Read_Addr1_out, Read_Addr2_out,

        output reg [31:0] Result_out, Addr1_data_out, Addr2_data_out
);

///////////////////CLK//////////////////

        always @(posedge CLK or negedge RSTN) begin
                if (~RSTN) begin
                        PC_out <= 0;
                        OpCode_out <= 0;
                        MemRead_out <= 0;
                        MemWrite_out <= 0;
                        RegWrite_out <= 0;
                        MemtoReg_out <= 0;
                        Result_out <= 0;
                        Write_Addr_out <= 0;
                        Read_Addr1_out <= 0;
                        Read_Addr2_out <= 0;
                        Addr1_data_out <= 0;
                        Addr2_data_out <= 0;
                        
                end else begin
                        PC_out <= PC;
                        OpCode_out <= OpCode;
                        MemRead_out <= MemRead;
                        MemWrite_out <= MemWrite;
                        RegWrite_out <= RegWrite;
                        MemtoReg_out <= MemtoReg;
                        Result_out <=Result;
                        Write_Addr_out <= Write_Addr;
                        Read_Addr1_out <= Read_Addr1;
                        Read_Addr2_out <= Read_Addr2;
                        Addr1_data_out <= Addr1_data;
                        Addr2_data_out <= Addr2_data;

                end
        end

endmodule