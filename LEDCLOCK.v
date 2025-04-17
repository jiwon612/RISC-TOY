module LEDCLOCK (
    // Outputs
    LEDG, LEDR,
	 DAY,
    HOUR,
	 LCD_EN,
    // Inputs
    CLK1K, RSTN, SW1, SW4, SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7
);

    input CLK1K;                 // 클럭 입력
    input RSTN;                  // 리셋 신호
	 input SW1;
    input SW4;                   // 스위치 입력
    input wire [3:0] SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7;  // 시계 입력
    output reg LEDG, LEDR;       // LED 출력
    output wire [4:0] HOUR;             // 시 값
    output wire [4:0] DAY;              // 날짜 값
	 output reg LCD_EN;

	 reg [4:0] CNT_HOUR;   // HOUR 카운터
    reg [4:0] CNT_DAY;           // DAY 
    reg [9:0] CNT;               // 카운터
	 reg [13:0] LCD_CNT;
    reg START_BLINK;             // LED 깜빡임 시작 신호

    assign HOUR = (SEG5 << 3) + (SEG5 << 1) + SEG4;
	 assign DAY = (SEG7 << 3) + (SEG7 << 1) + SEG6;
    always @(posedge CLK1K or negedge RSTN) begin
		  
        if (!RSTN) begin
            LEDG <= 1'b0;
            LEDR <= 1'b0;
            CNT <= 10'd0;
            CNT_HOUR <= 5'd0;
            CNT_DAY <= 5'd0;
            START_BLINK <= 1'b0;  //
				LCD_EN <= 1'b0;
				LCD_CNT <= 14'd0;
        end else begin
				
            if (SW4 && !SW1) begin
                // SEG0~SEG3가 모두 0일 때 신호를 받으면 LED 깜빡임 시작
                if ((SEG0 == 4'b0) && (SEG1 == 4'b0) && (SEG2 == 4'b0) && (SEG3 == 4'b0)) begin
					    if (!START_BLINK) begin
								START_BLINK <= 1'b1;  // SEG0~SEG3이 0일 

						 end
                end
					if (LCD_EN) begin
						 LCD_CNT <= LCD_CNT + 14'd1;
						 if (LCD_CNT == 14'd10000) begin
							  LCD_EN <= 1'b0;
						 end
					end

                // HOUR와 DAY에 따라 LED가 깜빡이기
                if (START_BLINK) begin
					     if ((SEG4 == 4'b0) && (SEG5 == 4'b0)) begin

                    		// DAY 값 업데이트
                    		if (CNT_DAY < DAY) begin
                        	CNT <= (CNT == 10'd999) ? 10'd0 : CNT + 10'd1;  // 1초 카운터
                        	LEDR <= ((CNT == 10'd499) || (CNT == 10'd999)) ? ~LEDR : LEDR;  // LEDR 깜빡이기
                        	if (CNT == 10'd999) begin
                              CNT_DAY <= CNT_DAY + 5'd1;
                           end
                        end else begin
                           // DAY 업데이트 완료 후, 카운터 초기화
								   START_BLINK <= 1'b0;
                           CNT_DAY <= 5'd0;
                           CNT <= 10'd0;
									LCD_EN <= 1'b1;
									LCD_CNT <= 14'd0;
                        end
					     end else begin
                    	// HOUR 값 업데이트
								if (CNT_HOUR < HOUR) begin
									  CNT <= (CNT == 10'd999) ? 10'd0 : CNT + 10'd1;  // 1초 카운터
									LEDG <= ((CNT == 10'd499) || (CNT == 10'd999)) ? ~LEDG : LEDG;  // LEDG 깜빡이기
									if (CNT == 10'd999) begin
										 CNT_HOUR <= CNT_HOUR + 5'd1;
									end
								end else begin
									// HOUR 업데이트 완료 후, 카운터 초기화
									CNT_HOUR <= 5'd0;
									CNT <= 10'd0;
									START_BLINK <= 1'b0;
									LCD_EN <= 1'b1;
									LCD_CNT <= 14'd0;
								end
				 		  end
                end
					 
            end
        end
    end

endmodule

