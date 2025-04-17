/*****************************************
    
    Team 01 : 
        2022104263    Seok Jiwon
        2022104320    Lee Jiwon
*****************************************/


// You are able to add additional modules and instantiate in RISC_TOY.


////////////////////////////////////
//  TOP MODULE
////////////////////////////////////
module RISC_TOY (
    input     wire              CLK,
    input     wire              RSTN,

    output    wire              IREQ, //inst mem request 
    output    wire    [29:0]    IADDR, //inst mem address
    input     wire    [31:0]    INSTR, //instruction from inst mem

    output    wire              DREQ, //data mem request
    output    wire              DRW, //data mem read(0) / write(1)
    output    wire    [29:0]    DADDR, //data mem address 32bit daddr = 100101100
    output    wire    [31:0]    DWDATA, //data to write
    input     wire    [31:0]    DRDATA //data from data mem
);

    wire [31:0] PC_IF, PC_ID_reg, PC_ID, PC_EX, PC_MEM_reg, PC_MEM;
    wire Branch_EX_reg;
    wire MemRead_EX_reg, MemRead_EX, MemRead_MEM;
    wire MemWrite_EX_reg, MemWrite_EX, MemWrite_MEM;
    wire RegWrite_EX_reg, RegWrite_EX, RegWrite_MEM, RegWrite_WB;
    wire MemtoReg_EX_reg, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB;
    wire [4:0] Write_Addr_EX_reg, Write_Addr_EX, Write_Addr_MEM, Write_Addr_WB;
    wire [4:0] Read_Addr1_EX_reg, Read_Addr2_EX_reg, Read_Addr1_EX, Read_Addr2_EX, Read_Addr1_MEM, Read_Addr2_MEM;
    wire [31:0] Addr1_data, Addr1_data_EX, Addr2_data, Addr2_data_EX, Addr1_data_WB_reg, Addr2_data_WB_reg, Addr1_data_WB, Addr2_data_WB;
    wire [31:0] Result_MEM_reg, Result_MEM, Result_WB;
    wire [31:0] PC_branch_IF_reg;
    wire [31:0] Read_data_WB;
    wire [31:0] WB_data, WB_data_out;
    wire Stall, Stall_out, Branch_Sig_out, Branch_Sig_Stall;





    wire [1:0] ImmSel1_EX_reg, ImmSel1_EX;
    wire [31:0] INST_ID;
    wire [4:0] OpCode_EX_reg, OpCode_EX, OpCode_MEM;
    wire [21:0] IMM_EX_reg, IMM_EX;
    wire [1:0] Forward_A, Forward_B, Branch_Forward_A, Branch_Forward_B;
    reg [31:0] Forward_A_data, Forward_B_data, Branch_Forward_A_data, Branch_Forward_B_data;
    



    // WRITE YOUR CODE                                                                                      ////////////////
    IF_Pipereg FetchReg(.CLK(CLK), .RSTN(RSTN), .PC(PC_ID_reg), .PC_out(PC_IF), .IREQ(IREQ), .Stall(Stall));

    

    IF Fetch(.PC(PC_IF), .RSTN(RSTN), .Branch_Sig(Branch_Sig_out), .PC_branch(PC_branch_IF_reg),
                .PC_out(PC_ID_reg)); //PC_Inst_Mem address goes into inst mem
    
    

    //////////// Access to Instruction Memory ///////////////////
    assign IADDR = PC_ID_reg[29:0]; //based on IADDR, INSTR comes in
    /////////////////////////////////////////////////////////////




    //HAZARD: RA_ID, RegWrite_ID, MemtoReg_ID -------- INST_IF ---- STALL & FLUSH
    ID_Pipereg DecodeReg(.CLK(CLK), .RSTN(RSTN), .Branch_Sig(Branch_Sig_out), .PC(PC_ID_reg), .INST(INSTR), 
                        .PC_out(PC_ID), .INST_out(INST_ID));

    ID Decode(.INST(INST_ID), .OpCode(OpCode_EX_reg), .IMM(IMM_EX_reg), .ImmSel1(ImmSel1_EX_reg), 
                .Branch(Branch_EX_reg), .MemRead(MemRead_EX_reg), .MemWrite(MemWrite_EX_reg), .RegWrite(RegWrite_EX_reg),
                .MemtoReg(MemtoReg_EX_reg), .Write_Addr(Write_Addr_EX_reg), .Read_Addr1(Read_Addr1_EX_reg), .Read_Addr2(Read_Addr2_EX_reg));

    ID_Branch BranchDecode(.data1(Branch_Forward_A_data), .data2(Branch_Forward_B_data), .IMM(IMM_EX_reg), .PC(PC_ID), .OpCode(OpCode_EX_reg), .Branch(Branch_EX_reg), .PC_out(PC_branch_IF_reg), .Branch_Sig_out(Branch_Sig_out));
                                     //////////////////////////////////

    always @ (*) begin
        case (Branch_Forward_A)
            2'b01: begin Branch_Forward_A_data = Result_MEM_reg; end
            2'b10: begin Branch_Forward_A_data = WB_data; end
            default: begin Branch_Forward_A_data = Addr1_data; end
        endcase

        case (Branch_Forward_B)
            2'b01: begin Branch_Forward_B_data = Result_MEM_reg; end
            2'b10: begin Branch_Forward_B_data = WB_data; end
            default: begin Branch_Forward_B_data = Addr2_data; end
        endcase 
    end



    /////////// REGFILE ////////
    //Read_Addr1 -> Addr1_data
    //Read_addr2 -> Addr2_data
    ////////////////////////////


    //HAZARD: RA_EX, RB_EX, RC_EX, RegWrite_EX, MemtoReg_EX
    EX_Pipereg ExecutionReg(.CLK(CLK), .RSTN(RSTN), .PC(PC_ID), .OpCode(OpCode_EX_reg), .IMM(IMM_EX_reg), .ImmSel1(ImmSel1_EX_reg), 
                .MemRead(MemRead_EX_reg), .MemWrite(MemWrite_EX_reg), .RegWrite(RegWrite_EX_reg),
                .MemtoReg(MemtoReg_EX_reg), .Write_Addr(Write_Addr_EX_reg), .Addr1_data(Addr1_data), .Addr2_data(Addr2_data), .Read_Addr1(Read_Addr1_EX_reg), .Read_Addr2(Read_Addr2_EX_reg),
                .PC_out(PC_EX), .OpCode_out(OpCode_EX), .IMM_out(IMM_EX), .ImmSel1_out(ImmSel1_EX), .MemRead_out(MemRead_EX),
                .MemWrite_out(MemWrite_EX), .RegWrite_out(RegWrite_EX), .MemtoReg_out(MemtoReg_EX), .Addr1_data_out(Addr1_data_EX), .Addr2_data_out(Addr2_data_EX),
                .Write_Addr_out(Write_Addr_EX), .Read_Addr1_out(Read_Addr1_EX), .Read_Addr2_out(Read_Addr2_EX));

    //Directly connect to Data Memory to synchronize the clk



    HAZARD Hazard_module(.Branch(Branch_EX_reg), .RegWrite_ID(RegWrite_EX_reg), .MemtoReg_ID(MemtoReg_EX_reg), .RegWrite_EX(RegWrite_EX), .MemtoReg_EX(MemtoReg_EX), .RegWrite_MEM(RegWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM),
                            .MemWrite_EX(MemWrite_EX), .MemWrite_MEM(MemWrite_MEM), .INST_IF(INSTR), .RA_ID(Write_Addr_EX_reg), .RB_ID(Read_Addr1_EX_reg), .RC_ID(Read_Addr2_EX_reg), .RA_EX(Write_Addr_EX), .RB_EX(Read_Addr1_EX), .RC_EX(Read_Addr2_EX),
                            .RA_MEM(Write_Addr_MEM), .RB_MEM(Read_Addr1_MEM), .RC_MEM(Read_Addr2_MEM), .RA_WB(Write_Addr_WB),
                            .Stall(Stall), .Forward_A(Forward_A), .Forward_B(Forward_B), .Branch_Forward_A(Branch_Forward_A), .Branch_Forward_B(Branch_Forward_B));


    always @ (*) begin
        case (Forward_A)
            2'b01: begin Forward_A_data = Result_MEM; end
            2'b10: begin Forward_A_data = WB_data_out; end
            default: begin Forward_A_data = Addr1_data_EX; end
        endcase

        case (Forward_B)
            2'b01: begin Forward_B_data = Result_MEM; end
            2'b10: begin Forward_B_data = WB_data_out; end
            default: begin Forward_B_data = Addr2_data_EX; end
        endcase 
    end




    EX Execution(.data1(Forward_A_data), .data2(Forward_B_data), .PC(PC_EX), .OpCode(OpCode_EX), .IMM(IMM_EX), .ImmSel1(ImmSel1_EX),
                    .Result(Result_MEM_reg));


    //HAZARD: RA_MEM, RB_MEM, RC_MEM, RegWrite_MEM, MemtoReg_MEM
    MEM_Piperegs MemoryReg(.CLK(CLK), .RSTN(RSTN), .PC(PC_MEM_reg), .OpCode(OpCode_EX), .MemRead(MemRead_EX), 
                            .MemWrite(MemWrite_EX), .RegWrite(RegWrite_EX), .MemtoReg(MemtoReg_EX),
                            .Write_Addr(Write_Addr_EX), .Read_Addr1(Read_Addr1_EX), .Read_Addr2(Read_Addr2_EX), .Result(Result_MEM_reg), .Addr1_data(Addr1_data_EX), .Addr2_data(Addr2_data_EX),
                            .PC_out(PC_MEM), .OpCode_out(OpCode_MEM),
                            .MemRead_out(MemRead_MEM), .MemWrite_out(MemWrite_MEM), .RegWrite_out(RegWrite_MEM), .MemtoReg_out(MemtoReg_MEM),
                            .Write_Addr_out(Write_Addr_MEM), .Read_Addr1_out(Read_Addr1_MEM), .Read_Addr2_out(Read_Addr2_MEM), .Result_out(Result_MEM), .Addr1_data_out(Addr1_data_WB_reg), .Addr2_data_out(Addr2_data_WB_reg));

    ////////////////////////// Access to Data Memory //////////////////////////////
    assign DREQ = (MemWrite_EX || MemRead_EX); 
    assign DRW = (MemWrite_EX && !MemRead_EX); // MemWrite=1,MemRead=0 -> 1
    assign DADDR = (Result_MEM_reg[29:0]);  // Result (calculated address in ALU)
    assign DWDATA = Write_Addr_EX;  // R[ra] #Will be saved to REGFILE in WB Stage
    //DRDATA will be input from Data Memory
    ///////////////////////////////////////////////////////////////////////////////


    //Directly connect to REGFILE Memory to synchronize the CLK

    WB WriteBack(.MemtoReg(MemtoReg_MEM), .Result(Result_MEM), .Read_data(DRDATA), .WB_data(WB_data));

    //HAZARD: RA_WB
    WB_Piperegs WriteBackReg(.CLK(CLK), .RSTN(RSTN), .WB_data(WB_data), .RegWrite(RegWrite_MEM), .MemtoReg(MemtoReg_MEM), .Write_Addr(Write_Addr_MEM), .Result(Result_MEM), .Read_data(DRDATA), .Addr1_data(Addr1_data_WB_reg), .Addr2_data(Addr2_data_WB_reg),
                                .WB_data_out(WB_data_out), .RegWrite_out(RegWrite_WB), .MemtoReg_out(MemtoReg_WB), .Write_Addr_out(Write_Addr_WB), .Result_out(Result_WB), .Read_data_out(Read_data_WB), .Addr1_data_out(Addr1_data_WB), .Addr2_data_out(Addr2_data_WB));



    ///////////// REGFILE AGAIN ////////////////////////
    ////////////////////////////////////////////////////
    

    initial begin
        $monitor("REG[%d] : Write_Data[%d] : PC [%d] : Addr1_data %d : Addr2_data %d : READ_ADDR %d : READ_ADDR2 %d", Write_Addr_MEM, WB_data, PC_IF, WB_data, PC_ID, Addr1_data, Addr2_data, Read_Addr1_EX_reg, Read_Addr2_EX_reg);
    end


/*
    initial begin
      $monitor("REG[%d] : %b PC : %d || D1:%b D2: %b R:%b PC:%d", Write_Addr_WB, WB_data, PC_IF, Addr1_data_EX, Addr2_data_EX, Result_MEM_reg, PC_MEM_reg);
   end
*/
    // REGISTER FILE FOR GENRAL PURPOSE REGISTERS
    REGFILE    #(.AW(5), .ENTRY(32))    RegFile (
                    .CLK    (CLK),
                    .RSTN   (RSTN),
                    .WEN    (~RegWrite_MEM),  // WRITE ENABLE (ACTIVE LOW)
                    .WA     (Write_Addr_MEM),           // WRITE ADDRESS #Destination
                    .DI     (WB_data),           // WRITE DATA INPUT
                    .RA0    (Read_Addr1_EX_reg),        // READ ADDRESS 0
                    .RA1    (Read_Addr2_EX_reg),        // READ ADDRESS 1
                    .DOUT0  (Addr1_data),      // READ DATA OUTPUT 0
                    .DOUT1  (Addr2_data)       // READ DATA OUTPUT 1
    );


    // WRITE YOUR CODE



endmodule