module TOP_FPGA (/*AUTOARG*/
		 // Outputs
		 SEG7_0, SEG7_1, SEG7_2, SEG7_3, SEG7_4, SEG7_5, SEG7_6, SEG7_7, 
		 LEDG_OUT,
		 LCD_DATA,
	    LCD_ENABLE, LCD_RW, LCD_RS, LCD_ON, LCD_BLON,

		 // Inputs
		 CLK50M, RSTN, SW1, SW2, SW3, SW4, SW5, SW6, KEY1, KEY2, KEY3, SOUNDSENSOR, TOUCH_IN
		 );


   input CLK50M;
   input RSTN;
	input SW1, SW2, SW3, SW4, SW5, SW6;
	input KEY1, KEY2, KEY3;
	input SOUNDSENSOR;
	input TOUCH_IN;

   output wire [6:0] SEG7_0;
   output wire [6:0] SEG7_1;
   output wire [6:0] SEG7_2;
   output wire [6:0] SEG7_3;
   output wire [6:0] SEG7_4;
   output wire [6:0] SEG7_5;
   output wire [6:0] SEG7_6;
   output wire [6:0] SEG7_7;
	output wire [3:0] LEDG_OUT;
	output wire [7:0] LCD_DATA;
	output wire LCD_ENABLE, LCD_RW, LCD_RS, LCD_ON, LCD_BLON;

   wire 	     CLK1K;

   CLKGEN1K clkgen1k (/*AUTOINST*/	
		      // Outputs
		      .CLK1K		(CLK1K),
		      // Inputs
		      .CLK50M		(CLK50M),
		      .RSTN		(RSTN));

   TOP DUT (/*AUTOINST*/
	    // Outputs
	    .SEG7_0		(SEG7_0[6:0]),
	    .SEG7_1		(SEG7_1[6:0]),
	    .SEG7_2		(SEG7_2[6:0]),
	    .SEG7_3		(SEG7_3[6:0]),
	    .SEG7_4		(SEG7_4[6:0]),
	    .SEG7_5  	(SEG7_5[6:0]),
	    .SEG7_6		(SEG7_6[6:0]),
	    .SEG7_7		(SEG7_7[6:0]),
		 .LEDG_OUT	(LEDG_OUT[3:0]),
		 .LCD_DATA	(LCD_DATA[7:0]),
	    .LCD_ENABLE(LCD_ENABLE), 
		 .LCD_RW		(LCD_RW), 
		 .LCD_RS		(LCD_RS), 
		 .LCD_ON		(LCD_ON), 
		 .LCD_BLON	(LCD_BLON),
	    // Inputs
	    .CLK1K			(CLK1K),
	    .RSTN			(RSTN),
	    .SW1			(SW1),
	    .SW2			(SW2),
	    .SW3			(SW3),
		 .SW4			(SW4),
		 .SW5			(SW5),
		 .SW6			(SW6),
	    .KEY1			(KEY1),
	    .KEY2			(KEY2),
	    .KEY3			(KEY3),
		 .SOUNDSENSOR  (SOUNDSENSOR),
		 .TOUCH_IN 		(TOUCH_IN));
endmodule
