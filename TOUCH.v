module TOUCH (
    input CLK1K,         
    input RSTN,          
    input TOUCH_IN,      

    output reg TOUCH_KEY1,  // Single tap output
    output reg TOUCH_KEY2,  // Double tap output
    output reg TOUCH_KEY3,  // Long press output
    output reg LED1,
    output reg LED2,
    output reg LED3,
    output reg LED4
);

    parameter IDLE = 1'b0,
              TOUCHING = 1'b1;

    reg STATE;

    reg [11:0] TOUCH_CNT;         
    reg [11:0] INTER_TOUCH_CNT;   
    reg FIRST_DETECTED;

    reg touch_filtered;
    reg prev_touch_filtered;
    reg [6:0] touch_timeout_cnt = 7'd0;

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            touch_filtered <= 1'b0;
            touch_timeout_cnt <= 7'd0;
				LED4 <= 1'd0;
        end else begin
            if (TOUCH_IN) begin
                touch_filtered <= 1'b1;
                touch_timeout_cnt <= 7'd0;
					 LED4 <= 1'd1;
            end else begin
					 LED4 <= 1'd0;
                if (touch_timeout_cnt < 7'd100)
                    touch_timeout_cnt <= touch_timeout_cnt + 7'd1;

                if (touch_timeout_cnt >= 7'd50)
                    touch_filtered <= 1'b0;
            end
        end
    end

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN)
            prev_touch_filtered <= 1'd0;
        else
            prev_touch_filtered <= touch_filtered;
    end

    wire TOUCH_FALL = (touch_filtered == 0 && prev_touch_filtered == 1); 
    wire TOUCH_RISE = (touch_filtered == 1 && prev_touch_filtered == 0); 

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            STATE <= IDLE;
            TOUCH_KEY1 <= 1'd0;
            TOUCH_KEY2 <= 1'd0;
            TOUCH_KEY3 <= 1'd0;
            LED1 <= 1'd0;
            LED2 <= 1'd0;
            LED3 <= 1'd0;

            TOUCH_CNT <= 12'd0;
            INTER_TOUCH_CNT <= 12'd0;
            FIRST_DETECTED <= 1'd0;
        end else begin
            TOUCH_KEY1 <= 1'd0;
            TOUCH_KEY2 <= 1'd0;
            TOUCH_KEY3 <= 1'd0;
            LED1 <= 1'd0;
            LED2 <= 1'd0;
            LED3 <= 1'd0;


            case (STATE)
                IDLE: begin
                    if (TOUCH_RISE) begin  
                        STATE <= TOUCHING;
                        TOUCH_CNT <= 12'd0;
                    end
                    if (FIRST_DETECTED) begin
                        INTER_TOUCH_CNT <= INTER_TOUCH_CNT + 12'd1;
                        if (INTER_TOUCH_CNT >= 12'd500) begin 
                            TOUCH_KEY1 <= 1'd1; 
                            LED1 <= 1'd1;
                            FIRST_DETECTED <= 1'd0;
                        end
                    end
                end

                TOUCHING: begin
                    TOUCH_CNT <= TOUCH_CNT + 12'd1;

                    if (TOUCH_FALL) begin 
                        if (TOUCH_CNT >= 12'd1000) begin
                            TOUCH_KEY3 <= 1'd1; 
                            LED3 <= 1'd1;
                            FIRST_DETECTED <= 1'd0;
                        end else begin
                            if (FIRST_DETECTED) begin
                                TOUCH_KEY2 <= 1'd1; 
                                LED2 <= 1'd1;
                                FIRST_DETECTED <= 1'd0;
                            end else begin
                                FIRST_DETECTED <= 1'd1;    
                                INTER_TOUCH_CNT <= 12'd0;    
                            end
                        end
                        STATE <= IDLE;
                    end
                end

                default: STATE <= IDLE;
            endcase
        end
    end
endmodule
