module WB(
        input MemtoReg, //WB signal #When this bit is zero, it means that it is not from data memory    
        input [31:0] Result,
        input [31:0] Read_data, //DRDATA

        output wire [31:0] WB_data
);

        //Decide REGFILE input value
        assign WB_data = (MemtoReg == 0) ? Result : Read_data;

endmodule