module TB_TOP;
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  CLK1K;                  // To DUT of TOP.v
   reg                  KEY0;                   // To DUT of TOP.v
   reg                  KEY1;                   // To DUT of TOP.v
   reg                  KEY2;                   // To DUT of TOP.v
   reg                  KEY3;                   // To DUT of TOP.v
   reg                  SW0;                    // To DUT of TOP.v
   reg                  SW1;                    // To DUT of TOP.v
   reg                  SW2;                    // To DUT of TOP.v
   reg                  SW3;                    // To DUT of TOP.v
   reg                  SW4;                    // To DUT of TOP.v
   reg                  SW5;                    // To DUT of TOP.v
   reg                  SW6;                    // To DUT of TOP.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [6:0]           SEG0;                 // From DUT of TOP.v
   wire [6:0]           SEG1;                 // From DUT of TOP.v
   wire [6:0]           SEG2;                 // From DUT of TOP.v
   wire [6:0]           SEG3;                 // From DUT of TOP.v
   wire [6:0]           SEG4;                 // From DUT of TOP.v
   wire [6:0]           SEG5;                 // From DUT of TOP.v
   wire [6:0]           SEG6;                 // From DUT of TOP.v
   wire [6:0]           SEG7;                 // From DUT of TOP.v
   // End of automatics
   TOP
     DUT
       (/*AUTOINST*/
        // Outputs
        .SEG7_0                         (SEG0[6:0]),
        .SEG7_1                         (SEG1[6:0]),
        .SEG7_2                         (SEG2[6:0]),
        .SEG7_3                         (SEG3[6:0]),
        .SEG7_4                         (SEG4[6:0]),
        .SEG7_5                         (SEG5[6:0]),
        .SEG7_6                         (SEG6[6:0]),
        .SEG7_7                         (SEG7[6:0]),
        // Inputs
        .CLK1K                          (CLK1K),
        .RSTN                           (SW0),
        .SW1                            (SW1),
        .SW2                            (SW2),
        .SW3                            (SW3),
        .SW4                            (SW4),
        .SW5                            (SW5),
        .SW6                            (SW6),
        .KEY3                           (KEY3),
        .KEY2                           (KEY2),
        .KEY1                           (KEY1));
   ////////////////////////////////////////////////
     //DISPLAY & FILE PARAMETER
   ////////////////////////////////////////////////
   integer     result_file;
   integer     gap;
   parameter SD0 = 7'b1000000; // '0'
   parameter SD1 = 7'b1111001; // '1'
   parameter SD2 = 7'b0100100; // '2'
   parameter SD3 = 7'b0110000; // '3'
   parameter SD4 = 7'b0011001; // '4'
   parameter SD5 = 7'b0010010; // '5'
   parameter SD6 = 7'b0000010; // '6'
   parameter SD7 = 7'b1111000; // '7'
   parameter SD8 = 7'b0000000; // '8'
   parameter SD9 = 7'b0010000; // '9'

   integer     display_second;
   integer     display_minute;
   integer     display_hour;
   integer     display_day;

   function automatic [3:0] SEG2NUM(input [6:0] SEGVALUE);
      begin
         case(SEGVALUE)
           SD0:SEG2NUM=0; // '0'
           SD1:SEG2NUM=1; // '1'
           SD2:SEG2NUM=2; // '2'
           SD3:SEG2NUM=3; // '3'
           SD4:SEG2NUM=4; // '4'
           SD5:SEG2NUM=5; // '5'
           SD6:SEG2NUM=6; // '6'
           SD7:SEG2NUM=7; // '7'
           SD8:SEG2NUM=8; // '8'
           SD9:SEG2NUM=9; // '9'
           default: SEG2NUM=0;
         endcase 
      end
   endfunction
   always@(*) begin 
      display_second = SEG2NUM(SEG0) + 10 * SEG2NUM(SEG1);
      display_minute = SEG2NUM(SEG2) + 10 * SEG2NUM(SEG3);
      display_hour = SEG2NUM(SEG4) + 10 * SEG2NUM(SEG5);
      display_day = SEG2NUM(SEG6) + 10 * SEG2NUM(SEG7);
   end
   ////////////////////////////////////////////////
   //CLCOK1K_BYPASS
   ////////////////////////////////////////////////
   initial begin
      CLK1K = 0;
      forever #0.5 CLK1K = ~CLK1K;
   end
   ////////////////////////////////////////////////
   //INIT TASKS
   ///////////////////////////////////////////////
   task init();
      begin
         KEY0 = 1'b1; // To DUT of TOPMODULE.v
         KEY1 = 1'b1; // To DUT of TOPMODULE.v
         KEY2 = 1'b1; // To DUT of TOPMODULE.v
         KEY3 = 1'b1; // To DUT of TOPMODULE.v
         SW0 = 1'b0; // To DUT of TOPMODULE.v
         SW1 = 1'b0; // To DUT of TOPMODULE.v
         SW2 = 1'b0; // To DUT of TOPMODULE.v
         SW3 = 1'b0; // To DUT of TOPMODULE.v
         SW4 = 1'b0; // To DUT of TOPMODULE.v
         SW5 = 1'b0; // To DUT of TOPMODULE.v
         SW6 = 1'b0; // To DUT of TOPMODULE.v
      end 
   endtask
   task automatic push_reset();
      begin
         SW0 = 0;
         #(3 + ($urandom($time) % 5));
         @(negedge CLK1K)
           SW0 =1;
         $fwrite(result_file, "%12.1f ms: reset released!\n",$time);
         $display("%12.1f ms: reset released!\n",$time);
      end 
   endtask
   ////////////////////////////////////////////////
   //PUSH BUTTONS
   ///////////////////////////////////////////////
   task automatic push_key0();
      begin
         integer bounce = $urandom($time) % 50;
         integer dur = 200 + $urandom($time) %100;
         $fwrite(result_file, "%12.1f ms: key0 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         $display("%12.1f ms: key0 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         KEY0 = 1'b1;
         repeat (bounce) begin
            #0.1;
            KEY0 = ~ KEY0;
         end
         KEY0 = 1'b0;
         #(dur);
         repeat (bounce) begin
            #0.1;
            KEY0 = ~ KEY0;
         end
         KEY0 = 1'b1;
      end
   endtask
   task automatic push_key1();
      begin
         integer bounce = $urandom($time) % 50;
         integer dur = 200 + $urandom($time) %100;
         $fwrite(result_file, "%12.1f ms: key1 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         $display("%12.1f ms: key1 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         KEY1 = 1'b1;
         repeat (bounce) begin
            #0.1;
            KEY1 = ~ KEY1;
         end
         KEY1 = 1'b0;
         #(dur);
         repeat (bounce) begin
            #0.1;
            KEY1 = ~ KEY1;
         end
         KEY1 = 1'b1;
         #(dur);
      end
   endtask
   task automatic push_key2();
      begin
         integer bounce = $urandom($time) % 50;
         integer dur = 200 + $urandom($time) %100;
         $fwrite(result_file, "%12.1f ms: key2 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         $display("%12.1f ms: key2 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         KEY2 = 1'b1;
         repeat (bounce) begin
            #0.1;
            KEY2 = ~ KEY2;
         end
         KEY2 = 1'b0;
         #(dur);
         repeat (bounce) begin
            #0.1;
            KEY2 = ~ KEY2;
         end
         KEY2 = 1'b1;
         #(dur);
      end
   endtask
   task automatic push_key3();
      begin
         integer bounce = $urandom($time) % 50;
         integer dur = 200 + $urandom($time) %100;
         $fwrite(result_file, "%12.1f ms: key3 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         $display("%12.1f ms: key3 pushed with %3d toggles and %3d ms duration !\n",$time,bounce,dur);
         KEY3 = 1'b1;
         repeat (bounce) begin
            #0.1;
            KEY3 = ~ KEY3;
         end
         KEY3 = 1'b0;
         #(dur);
         repeat (bounce) begin
            #0.1;
            KEY3 = ~ KEY3;
         end
         KEY3 = 1'b1;
         #(dur);
      end
   endtask
   ////////////////////////////////////////////////
   //SW BUTTONS
   ///////////////////////////////////////////////
   task automatic reverse_sw0();
      reg tmp;
      begin
         integer bounce = $urandom($time) % 50;
         $fwrite(result_file, "%12.1f ms: sw0 changed with %3d toggles from %1d !\n",$time,bounce,SW0);
         $display("%12.1f ms: sw0 with %3d toggles from %1d !\n",$time,bounce,SW0);
         tmp = SW0;
         repeat (bounce) begin
            #0.1;
            SW0 = ~ SW0;
         end
         SW0 = ~tmp;
      end
   endtask
   task automatic reverse_sw1();
      reg tmp;
      begin
         integer bounce = $urandom($time) % 50;
         $fwrite(result_file, "%12.1f ms: sw1 changed with %3d toggles from %1d !\n",$time,bounce,SW1);
         $display("%12.1f ms: sw1 with %3d toggles from %1d !\n",$time,bounce,SW1);
         tmp = SW1;
         repeat (bounce) begin
            #0.1;
            SW1 = ~ SW1;
         end
         SW1 = ~tmp;
      end
   endtask
   task automatic reverse_sw2();
      reg tmp;
      begin
         integer bounce = $urandom($time) % 50;
         $fwrite(result_file, "%12.1f ms: sw2 changed with %3d toggles from %1d !\n",$time,bounce,SW2);
         $display("%12.1f ms: sw2 with %3d toggles from %1d !\n",$time,bounce,SW2);
         tmp = SW2;
         repeat (bounce) begin
            #0.1;
            SW2 = ~ SW2;
         end
         SW2 = ~tmp;
         #(100);
      end
   endtask
   task automatic reverse_sw3();
      reg tmp;
      begin
         integer bounce = $urandom($time) % 50;
         $fwrite(result_file, "%12.1f ms: sw3 changed with %3d toggles from %1d !\n",$time,bounce,SW3);
         $display("%12.1f ms: sw3 with %3d toggles from %1d !\n",$time,bounce,SW3);
         tmp = SW3;
         repeat (bounce) begin
            #0.1;
            SW3 = ~ SW3;
         end
         SW3 = ~tmp;
         #(100);
      end
   endtask
   ////////////////////////////////////////////////
   //MAIN
   ///////////////////////////////////////////////
   //display
   integer time_wait;
   //stopwatch
   integer time_sw2on;
   integer time_sw2off;
   integer time_stopstart;
   integer time_stopstop;
   integer time_meas_init;
   integer time_meas_stopstart;
   integer time_meas_stopstop;
   integer time_meas_stopoff;
   //manual
   integer add_sec;
   integer sub_sec;
   integer add_min;
   integer sub_min;
   integer add_hr;
   integer sub_hr;
   integer add_day;
   integer sub_day;

   //debug
   integer time_meas_debug_start;
   integer time_meas_debug_stop;
   integer time_meas_debug_diff;

	//expected
   integer exp_day;
   integer exp_hr;
   integer exp_min;
   integer exp_sec;
   initial begin
      result_file = $fopen("./result.txt","w");
      init();
      push_reset();
      //
      ////////////////////////////////////////////////
      //1. DISPALY Check (reset 5pt + dispaly pt 5)
      ///////////////////////////////////////////////
      time_wait = ($urandom($time) % (2*3600)) * 1000;
      if((display_day == 1) && 
         (display_hour == 0) && 
         (display_minute == 0) && 
         (display_second == 0)) begin
         $fwrite(result_file, "%12.1f ms: 1_1.RESET_PASS - reest value is day %2d, %2d:%2d:%2d !\n",$time,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 1_1.RESET_PASS: reest value is day %2d, %2d:%2d:%2d !\n",$time,display_day,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 1_1.RESET_FAIL - reest value is day %2d, %2d:%2d:%2d !\n",$time,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 1_1.RESET_FAIL: reest value is day %2d, %2d:%2d:%2d !\n",$time,display_day,display_hour,display_minute,display_second);
      end
      #(time_wait);
      exp_day = (time_wait / (60000 * 60 * 24)) % 31 + 1;
      exp_hr = (time_wait / (60000 * 60)) % 24;
      exp_min = (time_wait / 60000) % 60;
      exp_sec = (time_wait/1000) % 60;
      if((display_day == exp_day) && 
         (display_hour == exp_hr) && 
         (display_minute == exp_min) && 
         (display_second == exp_sec)) begin
         $fwrite(result_file, "%12.1f ms: 1_2.DISPLAY_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 1_2.DISPLAY_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 1_2.DISPLAY_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 1_2.DISPLAY_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      ////////////////////////////////////////////////
      //2. STOPWATCH - 20pt (function 15 pt + reset 5 pt)
      ///////////////////////////////////////////////
      push_reset();
      time_meas_init = $time; 
      time_sw2on = ($urandom($time) % 5) * 1000;
      time_sw2off = ($urandom($time+1) % 5) * 1000;
      time_stopstart = ($urandom($time+1) % 5) * 1000;
      time_stopstop = ($urandom($time+1) % 5) * 1000;
      
      #(time_sw2on);
      reverse_sw2();
      #(time_stopstart);
      push_key3();
      time_meas_stopstart = $time;
      #(time_stopstop);
      push_key3();
      #(50);
      time_meas_stopstop = $time;
      exp_day = ((time_meas_stopstop - time_meas_stopstart) / (60000 * 60 * 24)) % 31 + 1;
      exp_hr = ((time_meas_stopstop - time_meas_stopstart) / (60000 * 60)) % 24;
      exp_min = ((time_meas_stopstop - time_meas_stopstart) / 60000) % 60;
      exp_sec = ((time_meas_stopstop - time_meas_stopstart) / 1000) % 60;
      if((display_hour == exp_hr) && 
         (display_minute == exp_min) && 
         (display_second == exp_sec)) begin
         $fwrite(result_file, "%12.1f ms: 2_1.STOPWATCH_PASS - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_1.STOPWATCH_PASS - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 2_1.STOPWATCH_FAIL - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_1.STOPWATCH_FAIL - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
      end
      #(time_sw2off);
      reverse_sw2();
      time_meas_stopoff = $time;
      exp_day = ((time_meas_stopoff - time_meas_init) / (60000 * 60 * 24)) % 31 + 1;
      exp_hr = ((time_meas_stopoff - time_meas_init) / (60000 * 60)) % 24;
      exp_min = ((time_meas_stopoff - time_meas_init) / 60000) % 60;
      exp_sec = ((time_meas_stopoff - time_meas_init) / 1000) % 60;
      if((display_day == exp_day) && 
         (display_hour == exp_hr) && 
         (display_minute == exp_min) && 
         (display_second == exp_sec)) begin
         $fwrite(result_file, "%12.1f ms: 2_2.STOPWATCH_REALTIME_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_2.STOPWATCH_REALTIME_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 2_2.STOPWATCH_REALTIME_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_2.STOPWATCH_REALTIME_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      #(time_sw2on);
      reverse_sw2();
      #1000;
      exp_hr = 0; 
      exp_min =0; 
      exp_sec =0; 
      if((display_hour == exp_hr) && 
         (display_minute == exp_min) && 
         (display_second == exp_sec)) begin
         $fwrite(result_file, "%12.1f ms: 2_3.STOPWATCH_RESET_PASS - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_3.STOPWATCH_RESET_PASS - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 2_3.STOPWATCH_RESET_FAIL - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
         $display("%12.1f ms: 2_3.STOPWATCH_RESET_FAIL - exp_time:%2d:%2d:%2d, act_time:%2d:%2d:%2d !\n",$time,exp_hr,exp_min,exp_sec,display_hour,display_minute,display_second);
      end
      reverse_sw2();
      #1000;
      ////////////////////////////////////////////////
      //3. MANUAL SETTING - 20pt (each 5pt)
      ///////////////////////////////////////////////
      push_reset();
      add_sec = $urandom ( $time ) % 15;
      sub_sec = $urandom ( $time + 1 ) % 15;
      add_min = $urandom ( $time + 2 ) % 15;
      sub_min = $urandom ( $time + 3 ) % 15;
      add_hr = $urandom ( $time + 4 ) % 15;
      sub_hr = $urandom ( $time + 5 ) % 15;
      add_day = $urandom ( $time + 6 ) % 15;
      sub_day = $urandom ( $time + 7 ) % 15;

      reverse_sw1();
      //sec
      repeat(add_sec) push_key2;
      repeat(sub_sec) push_key1;
      //min
      push_key3;
      repeat(add_min) push_key2;
      repeat(sub_min) push_key1;
      //hours
      push_key3;
      repeat(add_hr) push_key2;
      repeat(sub_hr) push_key1;
      //day
      push_key3;
      repeat(add_day) push_key2;
      repeat(sub_day) push_key1;
      //sec
      push_key3;
      repeat(add_sec) push_key2;
      repeat(sub_sec) push_key1;
		//before changing SW2 release
		#5000;
		exp_day = (add_day >= sub_day) ? 1 + (add_day - sub_day) : 31 + (add_day - sub_day); 
      exp_hr = (add_hr >= sub_hr) ? (add_hr - sub_hr) : 24 + (add_hr - sub_hr); 
      exp_min = (add_min >= sub_min) ? (add_min - sub_min) : 60 + (add_min - sub_min); 
      exp_sec = ((2 * add_sec) >= (2 * sub_sec)) ? (2 * add_sec - 2 * sub_sec) : 60 + (2 * add_sec - 2 * sub_sec); 
      
      if((display_day == exp_day) && 
         (display_hour == exp_hr) && 
         (display_minute == exp_min) && 
			(display_second == exp_sec) || (display_second == exp_sec+1) ||(display_second == exp_sec-1)) begin
         $fwrite(result_file, "%12.1f ms: 3.MANUALSETTING_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 3.MANUALSETTING_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 3.MANUALSETTING_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 3.MANUALSETTING_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
		//after changing sw realease
      reverse_sw1();
      #2200;
      exp_day = (add_day >= sub_day) ? 1 + (add_day - sub_day) : 31 + (add_day - sub_day); 
      exp_hr = (add_hr >= sub_hr) ? (add_hr - sub_hr) : 24 + (add_hr - sub_hr); 
      exp_min = (add_min >= sub_min) ? (add_min - sub_min) : 60 + (add_min - sub_min); 
      exp_sec = ((2 * add_sec + 2) >= (2 * sub_sec)) ? (2 * add_sec - 2 * sub_sec + 2) : 60 + (2 * add_sec - 2 * sub_sec + 2); 
      
      if((display_day == exp_day) && 
         (display_hour == exp_hr) && 
         (display_minute == exp_min) && 
			(display_second == exp_sec) || (display_second == exp_sec+1) ||(display_second == exp_sec-1)) begin
         $fwrite(result_file, "%12.1f ms: 3.MANUALSETTING_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 3.MANUALSETTING_PASS - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 3.MANUALSETTING_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
         $display("%12.1f ms: 3.MANUALSETTING_FAIL - exp_time:day %2d,%2d:%2d:%2d, act_time:day %2d,%2d:%2d:%2d !\n",$time,exp_day,exp_hr,exp_min,exp_sec,display_day,display_hour,display_minute,display_second);
      end
      #(1000);
      ////////////////////////////////////////////////
      //4. DEBUGGING
      ///////////////////////////////////////////////
      push_reset();
      reverse_sw3();
      #2000;
      time_meas_debug_start = display_second + 60 * display_minute + 3600 * display_hour + 3600 * 24 * display_day;
      #(time_wait);
      time_meas_debug_stop = display_second + 60 * display_minute + 3600 * display_hour + 3600 * 24 * display_day;
      time_meas_debug_diff = time_meas_debug_stop - time_meas_debug_start;
      if(time_meas_debug_diff == time_wait/10) begin
         $fwrite(result_file, "%12.1f ms: 4.DEBUG_PASS - exp_time:%12d sec, act_time:%12d sec !\n",$time,time_meas_debug_diff,time_wait);
         $display("%12.1f ms: 4.DEBUG_PASS - exp_time:%12d sec, act_time:%12d sec !\n",$time,time_meas_debug_diff,time_wait);
      end
      else begin
         $fwrite(result_file, "%12.1f ms: 4.DEBUG_FAIL - exp_time:%12d sec, act_time:%12d sec !\n",$time,time_meas_debug_diff,time_wait);
         $display("%12.1f ms: 4.DEBUG_FAIL - exp_time:%12d sec, act_time:%12d sec !\n",$time,time_meas_debug_diff,time_wait);
      end
      #10;
      $fclose(result_file);
      $finish;
   end
endmodule
// Local Variables:
// verilog-library-directories: ("." "./../rtl" )
// End:
