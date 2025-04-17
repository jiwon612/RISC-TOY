module WB_Piperegs(
        input CLK, RSTN,
        input RegWrite, //WB signal
        input MemtoReg, //WB signal #When this bit is zero, it means that it is not from data memory    
        input [4:0] Write_Addr, //RA REGFILE address for WB values to go in
        input [31:0] Result, WB_data,
        input [31:0] Read_data, Addr1_data, Addr2_data, 
                     //DRDATA


        output reg RegWrite_out,
        output reg MemtoReg_out,
        output reg [4:0] Write_Addr_out,
        output reg [31:0] Result_out, WB_data_out,
        output reg [31:0] Read_data_out, Addr1_data_out, Addr2_data_out
        
);

        always @ (posedge CLK or negedge RSTN) begin
                if (~RSTN) begin
                        RegWrite_out <= 0;
                        MemtoReg_out <= 0;
                        Write_Addr_out <= 0;
                        Result_out <= 0;
                        Read_data_out <=0;
                        Addr1_data_out <= 0;
                        Addr2_data_out <= 0;
                        WB_data_out <= 0;

                end else begin
                        RegWrite_out <= RegWrite;
                        MemtoReg_out <= MemtoReg;
                        Write_Addr_out <= Write_Addr;
                        Result_out <= Result;
                        Read_data_out <= Read_data;
                        Addr1_data_out <= Addr1_data;
                        Addr2_data_out <= Addr2_data;
                        WB_data_out <= WB_data;

                end
        end
endmodule