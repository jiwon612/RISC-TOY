module EX_Pipereg (
        input CLK, RSTN,
        input [31:0] PC,
        input wire [4:0] OpCode,
        input wire [21:0] IMM, //will be cutted in execution process
        input [1:0] ImmSel1, //EX signal
        input MemRead, //MEM signal
        input MemWrite, //MEM signal
        input RegWrite, //WB signal
        input MemtoReg, //WB signal
        input [31:0] Addr1_data,
        input [31:0] Addr2_data,
        input [4:0] Write_Addr, Read_Addr1, Read_Addr2,


        output reg [31:0] PC_out,
        output reg [4:0] OpCode_out,
        output reg [21:0] IMM_out, 
        output reg [1:0] ImmSel1_out, 
        output reg MemRead_out, 
        output reg MemWrite_out, 
        output reg RegWrite_out, 
        output reg MemtoReg_out,
        output reg [31:0] Addr1_data_out,
        output reg [31:0] Addr2_data_out,
        output reg [4:0] Write_Addr_out, Read_Addr1_out, Read_Addr2_out

);

///////////////////CLK//////////////////

        always @(posedge CLK or negedge RSTN) begin
                if (~RSTN) begin
                        PC_out <= 0;
                        OpCode_out <= 0;
                        IMM_out <= 0;
                        ImmSel1_out <= 0;
                        MemRead_out <= 0;
                        MemWrite_out <= 0;
                        RegWrite_out <= 0;
                        MemtoReg_out <= 0;
                        Addr1_data_out <= 0;
                        Addr2_data_out <= 0;
                        Write_Addr_out <= 0;
                        Read_Addr1_out <= 0;
                        Read_Addr2_out <= 0;

                end else begin
                        PC_out <= PC;
                        OpCode_out <= OpCode;
                        IMM_out <= IMM;
                        ImmSel1_out <= ImmSel1;
                        MemRead_out <= MemRead;
                        MemWrite_out <= MemWrite;
                        RegWrite_out <= RegWrite;
                        MemtoReg_out <= MemtoReg;
                        Addr1_data_out <= Addr1_data;
                        Addr2_data_out <= Addr2_data;
                        Write_Addr_out = Write_Addr;
                        Read_Addr1_out = Read_Addr1;
                        Read_Addr2_out = Read_Addr2;
                end
        end
endmodule


                        