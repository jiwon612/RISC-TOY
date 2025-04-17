module CLOCKVALUE (/*AUTOARG*/
    // Outputs
    SET_SEC0, SET_SEC1, SET_MIN0, SET_MIN1, SET_HOUR0, SET_HOUR1,
    SET_DAY0, SET_DAY1,
    // Inputs
    CLK1K, RSTN, SW1, KEY_STABLE3, KEY_STABLE2, KEY_STABLE1,
	 SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7 
    );

    input CLK1K;
    input RSTN;
    input SW1;
    input KEY_STABLE3, KEY_STABLE2, KEY_STABLE1;
	 input [3:0] SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7;

    output reg [3:0] SET_SEC0;
    output reg [3:0] SET_SEC1;
    output reg [3:0] SET_MIN0;
    output reg [3:0] SET_MIN1;
    output reg [3:0] SET_HOUR0;
    output reg [3:0] SET_HOUR1;
    output reg [3:0] SET_DAY0;
    output reg [3:0] SET_DAY1;

    reg [3:0] S_SEC0, S_SEC1, S_MIN0, S_MIN1, S_HOUR0, S_HOUR1, S_DAY0, S_DAY1;
    reg [1:0] mode;  // Mode: 0 = sec, 1 = min, 2 = hour, 3 = day

	 parameter      [1:0] FIELD_SEC = 2'd0;
    parameter      [1:0] FIELD_MIN = 2'd1;
    parameter      [1:0] FIELD_HOUR = 2'd2;
    parameter      [1:0] FIELD_DAY = 2'd3;

    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            // Initialize values to 0
            S_SEC0 <= 4'd0;
            S_SEC1 <= 4'd0;
            S_MIN0 <= 4'd0;
            S_MIN1 <= 4'd0;
            S_HOUR0 <= 4'd0;
            S_HOUR1 <= 4'd0;
            S_DAY0 <= 4'd1;
            S_DAY1 <= 4'd0;
            mode <= FIELD_SEC;
        end else begin
				S_SEC0 <= SW1 ? S_SEC0 : SEG0;  
         	S_SEC1 <= SW1 ? S_SEC1 : SEG1;
        	 	S_MIN0 <= SW1 ? S_MIN0 : SEG2;
         	S_MIN1 <= SW1 ? S_MIN1 : SEG3;
         	S_HOUR0 <= SW1 ? S_HOUR0 : SEG4;
         	S_HOUR1 <= SW1 ? S_HOUR1 : SEG5;
         	S_DAY0 <= SW1 ? S_DAY0 : SEG6;
         	S_DAY1 <= SW1 ? S_DAY1 : SEG7;
            // SW1 is ON for setting mode
            if (SW1) begin
                // Mode switch when KEY3 is pressed (sec -> min -> hour -> day -> sec)
                if (KEY_STABLE3) begin
                    case (mode)
                        FIELD_SEC: mode <= FIELD_MIN;
                        FIELD_MIN: mode <= FIELD_HOUR;
                        FIELD_HOUR: mode <= FIELD_DAY;
                        FIELD_DAY: mode <= FIELD_SEC;
                    endcase
                end

                // Increment or decrement values based on KEY2 (increment) and KEY1 (decrement)
                case (mode)
                    FIELD_SEC: begin
                        // Increase sec when KEY2 is stable
                        if (KEY_STABLE2) begin
								   if (S_SEC1 == 4'd5 && S_SEC0 == 4'd9) begin 
                              S_SEC0 <= 4'd0;  // Reset to 00
										S_SEC1 <= 4'd0;
								   end else if (S_SEC0 == 4'd9) begin
                              S_SEC0 <= 4'd0; 
								 		S_SEC1 <= S_SEC1 + 4'd1;  // Increment tens of sec
								   end else begin
                              S_SEC0 <= S_SEC0 + 4'd1;  // Increment ones of sec
                           end
						      end
                        // Decrease sec when KEY1 is stable
                        if (KEY_STABLE1) begin
								   if (S_SEC0 == 4'd0 && S_SEC1 == 4'd0) begin
                              S_SEC0 <= 4'd9;  // Reset to 59
										S_SEC1 <= 4'd5;
							      end else if (S_SEC0 == 4'd0) begin
                              S_SEC0 <= 4'd9; 
								  	   S_SEC1 <= S_SEC1 - 4'd1;  // Decrement tens of sec
								   end else begin 
                              S_SEC0 <= S_SEC0 - 4'd1;  // Decrement ones of sec
                           end
                        end
					      end

                    FIELD_MIN: begin
                        // Increase min when KEY2 is stable
                        if (KEY_STABLE2) begin
							      if (S_MIN1 == 4'd5 && S_MIN0 == 4'd9) begin
                              S_MIN0 <= 4'd0;  // Reset to 00
							  			S_MIN1 <= 4'd0;
								   end else if (S_MIN0 == 4'd9) begin
                              S_MIN0 <= 4'd0; 
									   S_MIN1 <= S_MIN1 + 4'd1;  // Increment tens of min
								   end else begin
                              S_MIN0 <= S_MIN0 + 4'd1;  // Increment ones of min
                           end
					         end
                        // Decrease min when KEY1 is stable
                        if (KEY_STABLE1) begin
							      if (S_MIN0 == 4'd0 && S_MIN1 == 4'd0) begin
                              S_MIN0 <= 4'd9;  // Reset to 59
										S_MIN1 <= 4'd5;
								   end else if (S_MIN0 == 4'd0) begin
                              S_MIN0 <= 4'd9;
							  		  	S_MIN1 <= S_MIN1 - 4'd1;  // Decrement tens of min
								   end else begin
                              S_MIN0 <= S_MIN0 - 4'd1;  // Decrement ones of min
                           end
                        end
					      end

                    FIELD_HOUR: begin
                        // Increase hour when KEY2 is stable
                        if (KEY_STABLE2) begin
								   if (S_HOUR1 == 4'd2 && S_HOUR0 == 4'd3) begin
                              S_HOUR0 <= 4'd0;  // Reset to 00
									   S_HOUR1 <= 4'd0;
								   end else if (S_HOUR0 == 4'd9) begin
                              S_HOUR0 <= 4'd0;
							  	    	S_HOUR1 <= S_HOUR1 + 4'd1;  // Increment tens of hour
								   end else begin
                              S_HOUR0 <= S_HOUR0 + 4'd1;  // Increment ones of hour
                           end
					         end
                        // Decrease hour when KEY1 is stable
                        if (KEY_STABLE1) begin
								   if (S_HOUR0 == 4'd0 && S_HOUR1 == 4'd0) begin
                              S_HOUR0 <= 4'd3;  // Reset to 23
										S_HOUR1 <= 4'd2;
								   end else if (S_HOUR0 == 4'd0) begin
                              S_HOUR0 <= 4'd9;
							  		   S_HOUR1 <= S_HOUR1 - 4'd1;  // Decrement tens of hour
								   end else begin
                              S_HOUR0 <= S_HOUR0 - 4'd1;  // Decrement ones of hour
                           end
                        end
					      end

                    FIELD_DAY: begin
                        // Increase day when KEY2 is stable
                        if (KEY_STABLE2) begin
								   if (S_DAY1 == 4'd3 && S_DAY0 == 4'd1) begin
                              S_DAY0 <= 4'd1;  // Reset to 01
										S_DAY1 <= 4'd0;
								   end else if (S_DAY0 == 4'd9) begin
                              S_DAY0 <= 4'd0; 
										S_DAY1 <= S_DAY1 + 4'd1;  // Increment tens of day
								   end else begin
                              S_DAY0 <= S_DAY0 + 4'd1;  // Increment ones of day
                           end
					         end
                        // Decrease day when KEY1 is stable
                        if (KEY_STABLE1) begin
								   if (S_DAY0 == 4'd1 && S_DAY1 == 4'd0) begin
                              S_DAY0 <= 4'd1;  // Reset to 31
										S_DAY1 <= 4'd3;
								   end else if (S_DAY0 == 4'd0) begin
                              S_DAY0 <= 4'd9;
							  			S_DAY1 <= S_DAY1 - 4'd1;  // Decrement tens of day
								   end else begin
                              S_DAY0 <= S_DAY0 - 4'd1;  // Decrement ones of day
                           end
					         end
                    end
                endcase
            end
            // Output the current time values
            SET_SEC0 <= S_SEC0;
            SET_SEC1 <= S_SEC1;
            SET_MIN0 <= S_MIN0;
            SET_MIN1 <= S_MIN1;
            SET_HOUR0 <= S_HOUR0;
            SET_HOUR1 <= S_HOUR1;
            SET_DAY0 <= S_DAY0;
            SET_DAY1 <= S_DAY1;
        end
    end

endmodule

 
