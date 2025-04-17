module LCD_CTRL (
    // Host Side
    input [7:0] DATA_IN,
    input RS_IN, START_IN,
    input CLK1K, RSTN,
    output reg DONE_OUT,

    // LCD Interface
    output [7:0] LCD_DATA,
    output reg LCD_ENABLE,
    output LCD_RW,
    output LCD_RS,
    output LCD_ON,
    output LCD_BLON
);

    assign LCD_ON = 1'b1;
    assign LCD_BLON = 1'b1;

    // Constants
    parameter CLK_DIVIDE = 5'd16;

    // Internal Registers
    reg [4:0] CLK_COUNT;
    reg [1:0] STATE;
    reg PREV_START, START_EDGE;

    // Direct assignment
    assign LCD_DATA = DATA_IN;
    assign LCD_RW = 1'b0;       // Write only
    assign LCD_RS = RS_IN;

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            DONE_OUT <= 1'b0;
            LCD_ENABLE <= 1'b0;
            PREV_START <= 1'b0;
            START_EDGE <= 1'b0;
            CLK_COUNT <= 5'd0;
            STATE <= 2'd0;
        end else begin
            // Rising edge detection
            PREV_START <= START_IN;
            if ({PREV_START, START_IN} == 2'b01) begin
                START_EDGE <= 1'b1;
                DONE_OUT <= 1'b0;
            end

            if (START_EDGE) begin
                case (STATE)
                    2'd0: STATE <= 2'd1; // Setup Delay
                    2'd1: begin
                        LCD_ENABLE <= 1'b1;
                        STATE <= 2'd2;
                    end
                    2'd2: begin
                        if (CLK_COUNT < CLK_DIVIDE)
                            CLK_COUNT <= CLK_COUNT + 5'd1;
                        else
                            STATE <= 2'd3;
                    end
                    2'd3: begin
                        LCD_ENABLE <= 1'b0;
                        START_EDGE <= 1'b0;
                        DONE_OUT <= 1'b1;
                        CLK_COUNT <= 5'd0;
                        STATE <= 2'd0;
                    end
                endcase
            end
        end
    end

endmodule

