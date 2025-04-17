module TOP (/*AUTOARG*/
   // Outputs
   SEG7_0, SEG7_1, SEG7_2, SEG7_3, SEG7_4, SEG7_5, SEG7_6, SEG7_7, 
	LEDG_OUT,
	LCD_DATA,
	LCD_ENABLE, LCD_RW, LCD_RS, LCD_ON, LCD_BLON,
   // Inputs
   CLK1K, RSTN, SW1, SW2, SW3, SW4, SW5, SW6, KEY1, KEY2, KEY3, SOUNDSENSOR, TOUCH_IN
   );
	
   input CLK1K;
   input RSTN;
   input SW1;
   input SW2;
   input SW3;
	input SW4;
	input SW5;
	input SW6;
   input KEY1;
   input KEY2;
   input KEY3;
	input SOUNDSENSOR;
	input TOUCH_IN;
   output wire [6:0] SEG7_0, SEG7_1, SEG7_2, SEG7_3, SEG7_4, SEG7_5, SEG7_6, SEG7_7;
	output wire [3:0] LEDG_OUT;
	output wire [7:0] LCD_DATA;
	output wire LCD_ENABLE, LCD_RW, LCD_RS, LCD_ON, LCD_BLON;
   
   wire [3:0] 	     SET_SEC0, SET_SEC1, SET_MIN0, SET_MIN1, SET_HOUR0, SET_HOUR1, SET_DAY0, SET_DAY1; // OUTPUT when SW1 ON
   wire [3:0] 	     SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7; // OUTPUT of DIGITAL CLOCK
	wire [3:0]       SEG0_IN, SEG1_IN, SEG2_IN, SEG3_IN, SEG4_IN, SEG5_IN, SEG6_IN, SEG7_IN;
   wire 	     KEY_STABLE3, KEY_STABLE2, KEY_STABLE1; // KEY PUSHES
   wire [3:0] 	     STOP_SEC0, STOP_SEC1, STOP_MIN0, STOP_MIN1, STOP_HOUR0, STOP_HOUR1, STOP_DAY0, STOP_DAY1;
   wire [3:0] 	     TSEG0; // OUTPUT of TIMER
	wire		  CLK1H;
	wire 	     LED;
   wire 	     LEDR, LEDG; 
	wire 		  LED1, LED2, LED3, LED4;
	wire [4:0] 		  DAY, HOUR;
	wire LCD_EN;
	wire TOUCH_KEY1, TOUCH_KEY2, TOUCH_KEY3;
	wire KEY1_IN, KEY2_IN, KEY3_IN; // TOUCH SENSOR or BOARD INPUT

   assign SEG0_IN = SW2 ? STOP_SEC0 : (SW6 ? TSEG0 : SEG0);
   assign SEG1_IN = SW2 ? STOP_SEC1 : (SW6 ? 4'd0 : SEG1);
   assign SEG2_IN = SW2 ? STOP_MIN0 : (SW6 ? 4'd0 : SEG2);
   assign SEG3_IN = SW2 ? STOP_MIN1 : (SW6 ? 4'd0 : SEG3);
   assign SEG4_IN = SW2 ? STOP_HOUR0 : (SW6 ? 4'd0 : SEG4);
   assign SEG5_IN = SW2 ? STOP_HOUR1 : (SW6 ? 4'd0 : SEG5);
   assign SEG6_IN = SW2 ? STOP_DAY0 : (SW6 ? 4'd0 : SEG6);
   assign SEG7_IN = SW2 ? STOP_DAY1 : (SW6 ? 4'd0 : SEG7);

	assign KEY1_IN = (SW1 == 1'b1) && (SW5 == 1'b1) ? TOUCH_KEY1 : KEY_STABLE1;
	assign KEY2_IN = (SW1 == 1'b1) && (SW5 == 1'b1) ? TOUCH_KEY2 : KEY_STABLE2;
	assign KEY3_IN = (SW1 == 1'b1) && (SW5 == 1'b1) ? TOUCH_KEY3 : KEY_STABLE3;
	
	assign LEDG_OUT[0] = SW4 ? LEDG  :
								SW5 ? LED1  :
								SW6 ? LED   : 1'b0;

	assign LEDG_OUT[1] = SW4 ? LEDR  :
								SW5 ? LED2  :
								1'b0;

	assign LEDG_OUT[2] = SW5 ? LED3  : 1'b0;
	assign LEDG_OUT[3] = SW5 ? LED4  : 1'b0;

   DECODE7SEG SEC0 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_0[6:0]),
		    // Inputs
		    .IN			(SEG0_IN[3:0]));
   DECODE7SEG SEC1 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_1[6:0]),
		    // Inputs
		    .IN			(SEG1_IN[3:0]));
   DECODE7SEG MIN0 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_2[6:0]),
		    // Inputs
		    .IN			(SEG2_IN[3:0]));
   DECODE7SEG MIN1 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_3[6:0]),
		    // Inputs
		    .IN			(SEG3_IN[3:0]));
   DECODE7SEG HOUR0 (/*AUTOINS*/
		     // Outputs
		     .OUT			(SEG7_4[6:0]),
		     // Inputs
		     .IN			(SEG4_IN[3:0]));
   DECODE7SEG HOUR1 (/*AUTOINS*/
		     // Outputs
		     .OUT			(SEG7_5[6:0]),
		     // Inputs
		     .IN			(SEG5_IN[3:0]));
   DECODE7SEG DAY0 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_6[6:0]),
		    // Inputs
		    .IN			(SEG6_IN[3:0]));
   DECODE7SEG DAY1 (/*AUTOINS*/
		    // Outputs
		    .OUT			(SEG7_7[6:0]),
		    // Inputs
		    .IN			(SEG7_IN[3:0]));
   
   DEBOUNCING DKEY3 (/*AUTOINS*/
		     // Outputs
		     .KEY_STABLE		(KEY_STABLE3),
		     // Inputs
		     .CLK1K			(CLK1K),
		     .RSTN			(RSTN),
		     .KEY			(KEY3));
   DEBOUNCING DKEY2 (/*AUTOINS*/
		     // Outputs
		     .KEY_STABLE		(KEY_STABLE2),
		     // Inputs
		     .CLK1K			(CLK1K),
		     .RSTN			(RSTN),
		     .KEY			(KEY2));
   DEBOUNCING DKEY1 (/*AUTOINS*/
		     // Outputs
		     .KEY_STABLE		(KEY_STABLE1),
		     // Inputs
		     .CLK1K			(CLK1K),
		     .RSTN			(RSTN),
		     .KEY			(KEY1));

   DIGITALCLOCK digitalclock (/*AUTOINS*/
			      // Outputs
			      .SEG0		(SEG0[3:0]),
			      .SEG1		(SEG1[3:0]),
			      .SEG2		(SEG2[3:0]),
			      .SEG3		(SEG3[3:0]),
			      .SEG4		(SEG4[3:0]),
			      .SEG5		(SEG5[3:0]),
			      .SEG6		(SEG6[3:0]),
			      .SEG7		(SEG7[3:0]),
			      // Inputs
			      .CLK1K		(CLK1K),
			      .RSTN		(RSTN),
			      .SET_SEC0		(SET_SEC0[3:0]),
			      .SET_SEC1		(SET_SEC1[3:0]),
			      .SET_MIN0		(SET_MIN0[3:0]),
			      .SET_MIN1		(SET_MIN1[3:0]),
			      .SET_HOUR0	(SET_HOUR0[3:0]),
			      .SET_HOUR1	(SET_HOUR1[3:0]),
			      .SET_DAY0		(SET_DAY0[3:0]),
			      .SET_DAY1		(SET_DAY1[3:0]),
			      .SW1		(SW1),
					.SW3		(SW3));

   CLOCKVALUE clockvalue (/*AUTOINS*/
			  // Outputs
			  .SET_SEC0		(SET_SEC0[3:0]),
			  .SET_SEC1		(SET_SEC1[3:0]),
			  .SET_MIN0		(SET_MIN0[3:0]),
			  .SET_MIN1		(SET_MIN1[3:0]),
			  .SET_HOUR0		(SET_HOUR0[3:0]),
			  .SET_HOUR1		(SET_HOUR1[3:0]),
			  .SET_DAY0		(SET_DAY0[3:0]),
			  .SET_DAY1		(SET_DAY1[3:0]),
			  // Inputs
			  .CLK1K		(CLK1K),
			  .RSTN			(RSTN),
			  .SW1			(SW1),
			  .KEY_STABLE3		(KEY3_IN),
			  .KEY_STABLE2		(KEY2_IN),
			  .KEY_STABLE1		(KEY1_IN),
			  .SEG0			(SEG0[3:0]),
			  .SEG1			(SEG1[3:0]),
			  .SEG2			(SEG2[3:0]),
			  .SEG3			(SEG3[3:0]),
			  .SEG4			(SEG4[3:0]),
			  .SEG5			(SEG5[3:0]),
			  .SEG6			(SEG6[3:0]),
			  .SEG7			(SEG7[3:0]));


   STOPWATCH stopwatch (/*AUTOINS*/
			// Outputs
			.STOP_SEC0		(STOP_SEC0[3:0]),
			.STOP_SEC1		(STOP_SEC1[3:0]),
			.STOP_MIN0		(STOP_MIN0[3:0]),
			.STOP_MIN1		(STOP_MIN1[3:0]),
			.STOP_HOUR0	(STOP_HOUR0[3:0]),
			.STOP_HOUR1	(STOP_HOUR1[3:0]),
			.STOP_DAY0		(STOP_DAY0[3:0]),
			.STOP_DAY1		(STOP_DAY1[3:0]),
			// Inputs
			.CLK		(CLK1K),
			.RSTN		(RSTN),
			.SW2		(SW2),
			.SW3	 	(SW3),
			.START		(KEY_STABLE3));

   TIMER timer (/*AUTOINST*/
		// Outputs
		.TSEG0			(TSEG0[3:0]),
		.LED			(LED),
		// Inputs
		.CLK1H			(CLK1H),
		.RSTN			(RSTN),
		.SOUNDSENSOR			(SOUNDSENSOR),
		.SW6			(SW6));
		
   LEDCLOCK ledclock (/*AUTOINST*/
		      // Outputs
		      .LEDG		(LEDG),
		      .LEDR		(LEDR),
				.DAY (DAY[4:0]),
				.HOUR(HOUR[4:0]),
				.LCD_EN(LCD_EN),
		      // Inputs
		      .CLK1K		(CLK1K),
		      .RSTN		(RSTN),
				.SW1		(SW1),
		      .SW4		(SW4),
		      .SEG0		(SEG0[3:0]),
		      .SEG1		(SEG1[3:0]),
		      .SEG2		(SEG2[3:0]),
		      .SEG3		(SEG3[3:0]),
		      .SEG4		(SEG4[3:0]),
		      .SEG5		(SEG5[3:0]),
		      .SEG6		(SEG6[3:0]),
		      .SEG7		(SEG7[3:0]));
				
	 LCD_DISPLAY lcd_display (
				 // Inputs
				 .CLK1K(CLK1K),
				 .RSTN(RSTN),
				 .DAY(DAY[4:0]),
				 .HOUR(HOUR[4:0]),
				 .LCD_EN(LCD_EN),
				 // Outputs
				 .LCD_DATA(LCD_DATA[7:0]),
				 .LCD_ENABLE(LCD_ENABLE),
				 .LCD_RW(LCD_RW),
				 .LCD_RS(LCD_RS),
				 .LCD_ON(LCD_ON),
				 .LCD_BLON(LCD_BLON));
				
   CLKGEN1HZ clkgen1h (/*AUTOINST*/
		       // Outputs
		       .CLK1H		(CLK1H),
		       // Inputs
		       .CLK1K		(CLK1K),
		       .RSTN		(RSTN));

	TOUCH touch (/*AUTOINST*/
		     // Outputs
		     .TOUCH_KEY1		(TOUCH_KEY1),
		     .TOUCH_KEY2		(TOUCH_KEY2),
		     .TOUCH_KEY3		(TOUCH_KEY3),
			  .LED1			   (LED1),
			  .LED2			   (LED2),
			  .LED3			   (LED3),
			  .LED4			   (LED4),
		     // Inputs
		     .CLK1K		(CLK1K),
		     .RSTN		(RSTN),
		     .TOUCH_IN		(TOUCH_IN)); 
			  
		 
endmodule
