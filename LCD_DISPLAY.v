module LCD_DISPLAY (
    input CLK1K,
    input RSTN,
    input [4:0] DAY,
    input [4:0] HOUR,
	 input LCD_EN,
    output [7:0] LCD_DATA,
    output LCD_ENABLE,
    output LCD_RW,
    output LCD_RS,
    output LCD_ON,
    output LCD_BLON
);

    reg [7:0] msg [0:25];   // Include LCD clear command at msg[0]
    reg [4:0] idx;
	 reg prev_LCD_EN;
	 reg updating ;
    reg START;
    wire DONE;
    reg [1:0] STATE;

    reg [4:0] day_tens, day_ones;
    reg [4:0] hour_tens, hour_ones;
	 

    always @(*) begin
        if (DAY < 5'd10) begin
            day_tens = 5'd0;
            day_ones = DAY;
        end else if (DAY < 5'd20) begin
            day_tens = 5'd1;
            day_ones = DAY - 5'd10;
        end else if (DAY < 5'd30) begin
            day_tens = 5'd2;
            day_ones = DAY - 5'd20;
        end else begin
            day_tens = 5'd3;
            day_ones = DAY - 5'd30;
        end
    end

	always @(*) begin
		 if (HOUR < 5'd10) begin
			  hour_tens = 5'd0;
			  hour_ones = HOUR;
		 end else if (HOUR < 5'd20) begin
			  hour_tens = 5'd1;
			  hour_ones = HOUR - 5'd10;
		 end else begin
			  hour_tens = 5'd2;
			  hour_ones = HOUR - 5'd20;
		 end
	end
	 wire [7:0] ch_day_tens = day_tens + 8'd48;
    wire [7:0] ch_day_ones = day_ones + 8'd48;
    wire [7:0] ch_hour_tens = hour_tens + 8'd48;
    wire [7:0] ch_hour_ones = hour_ones + 8'd48;
    always @(*) begin
        msg[0]  = 8'h01;  // LCD Clear
        msg[1]  = "D";
        msg[2]  = "A";
        msg[3]  = "Y";
        msg[4]  = ":";
        msg[5]  = " ";
        msg[6]  = ch_day_tens;
        msg[7]  = ch_day_ones;
        msg[8]  = " ";
        msg[9]  = "H";
        msg[10] = "O";
        msg[11] = "U";
        msg[12] = "R";
        msg[13] = ":";
        msg[14] = " ";
        msg[15] = ch_hour_tens;
        msg[16] = ch_hour_ones;
        msg[17] = 8'hC0;  // Move to second line
			msg[18] = LCD_EN ? "O" : " ";
			msg[19] = LCD_EN ? "N" : " ";
			msg[20] = " ";
			msg[21] = LCD_EN ? "T" : " ";
			msg[22] = LCD_EN ? "I" : " ";
			msg[23] = LCD_EN ? "M" : " ";
			msg[24] = LCD_EN ? "E" : " ";
			msg[25] = LCD_EN ? "!" : " ";
    end



    reg [7:0] current_char;
    always @(*) current_char = msg[idx];

    wire RS_SELECT = (idx == 0 || idx == 17) ? 1'b0 : 1'b1;

    localparam IDLE = 2'd0, TRIG = 2'd1, WAIT = 2'd2, NEXT = 2'd3;

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            idx <= 5'd0;
            STATE <= IDLE;
            START <= 1'd0;
				prev_LCD_EN <= 1'b0;
				updating <= 1'b0;
        end 
			  else begin
				  prev_LCD_EN <= LCD_EN; 
				  if (LCD_EN != prev_LCD_EN) begin
						updating <= 1'b1;  // 업데이트 활성화
						idx <= 5'd0;       // 처음부터 메시지 출력
						STATE <= IDLE;
				  end 
				  else if (updating) begin
						case (STATE)
							 IDLE: begin
								  START <= 1'b1;
								  STATE <= TRIG;
							 end
							 TRIG: begin
								  START <= 1'b0;
								  STATE <= WAIT;
							 end
							 WAIT: begin
								  if (DONE)
										STATE <= NEXT;
							 end
							 NEXT: begin
								  if (idx < 5'd25) begin
										idx <= idx + 5'd1;
										STATE <= IDLE;
								  end 
								  else begin
										idx <= 5'd0;
										updating <= 1'b0;  // 업데이트 종료
										STATE <= IDLE;
								  end
							 end
						endcase
				end 
				else begin
					START <= 1'b0;
					STATE <= IDLE;
			  end
		 end
	end
	
    LCD_CTRL lcd_ctrl_inst (
		  // Inputs
        .DATA_IN     (current_char),
        .RS_IN       (RS_SELECT),
        .START_IN    (START),
        .CLK1K       (CLK1K),
        .RSTN        (RSTN),
		  // Outputs
        .DONE_OUT    (DONE),
        .LCD_DATA    (LCD_DATA),
        .LCD_ENABLE  (LCD_ENABLE),
        .LCD_RW      (LCD_RW),
        .LCD_RS      (LCD_RS),
        .LCD_ON      (LCD_ON),
        .LCD_BLON    (LCD_BLON)
    );

endmodule
