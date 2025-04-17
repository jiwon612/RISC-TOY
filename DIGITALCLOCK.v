module DIGITALCLOCK (/*AUTOARG*/
   // Outputs
   SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7,
   // Inputs
   CLK1K, RSTN, SET_SEC0, SET_SEC1, SET_MIN0, SET_MIN1, SET_HOUR0,
   SET_HOUR1, SET_DAY0, SET_DAY1, SW1, SW3
   );

   input CLK1K;
   input RSTN;
	input [3:0] SET_SEC0, SET_SEC1, SET_MIN0, SET_MIN1, SET_HOUR0, SET_HOUR1, SET_DAY0, SET_DAY1;
	input SW1, SW3;
   output wire [3:0] SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7;

   reg [3:0] 	     SEC0_IN, SEC1_IN, MIN0_IN, MIN1_IN, HOUR0_IN, HOUR1_IN, DAY0_IN, DAY1_IN;
   reg [9:0] 	     CNT; // COUNTER for 1s
	wire [9:0] CNT_SELECT;
		
	assign CNT_SELECT = SW3 ? 10'd9 : 10'd999; // DEBUG MODE = 9, NOT DEBUG = 999
	
	
   always @(posedge CLK1K or negedge RSTN) begin
      if (!RSTN) begin
	      SEC0_IN <= 4'd0;
	      SEC1_IN <= 4'd0;
	      MIN0_IN <= 4'd0;
	      MIN1_IN <= 4'd0;
	      HOUR0_IN <= 4'd0;
	      HOUR1_IN <= 4'd0;
	      DAY0_IN <= 4'd1; // START FROM DAY1
	      DAY1_IN <= 4'd0;
	      CNT <= 10'd0;
      end else begin
         SEC0_IN <= SW1 ? SET_SEC0 : SEC0_IN;  
         SEC1_IN <= SW1 ? SET_SEC1 : SEC1_IN;
         MIN0_IN <= SW1 ? SET_MIN0 : MIN0_IN;
         MIN1_IN <= SW1 ? SET_MIN1 : MIN1_IN;
         HOUR0_IN <= SW1 ? SET_HOUR0 : HOUR0_IN;
         HOUR1_IN <= SW1 ? SET_HOUR1 : HOUR1_IN;
         DAY0_IN <= SW1 ? SET_DAY0 : DAY0_IN;
         DAY1_IN <= SW1 ? SET_DAY1 : DAY1_IN;
			if (!SW1) begin
		      if (CNT == CNT_SELECT) begin
		         CNT <= 10'd0;
		         // SECOND COUNTING	 
	            if (SEC0_IN == 4'd9) begin
	               SEC0_IN <= 4'd0;   
			         if (SEC1_IN == 4'd5) begin
		  	            SEC1_IN <= 4'd0;
		               // MINUTE COUNTING
		  		         if (MIN0_IN == 4'd9) begin
		     		         MIN0_IN <= 4'd0;
		                  if (MIN1_IN == 4'd5) begin
			                  MIN1_IN <= 4'd0;
		      	            // HOUR COUNTING
		      	            if ((HOUR0_IN == 4'd3) && (HOUR1_IN == 4'd2)) begin // 24H -> 0H
		      	               HOUR0_IN <= 4'd0;
		      	               HOUR1_IN <= 4'd0;
		      	               // DAY COUNTING
		      	               if ((DAY0_IN == 4'd1) && (DAY1_IN == 4'd3)) begin // 31DAY -> 1DAY
		      	                  DAY0_IN <= 4'd1;
		      	                  DAY1_IN <= 4'd0;
		      	               end else if (DAY0_IN == 4'd9) begin // INCREASE DAY1
		      	                  DAY0_IN <= 4'd0;
		      	                  DAY1_IN <= DAY1_IN + 4'd1;
		      	               end else begin
		      	                  DAY0_IN <= DAY0_IN + 4'd1;          // INCREASE DAY0
									      DAY1_IN <= DAY1_IN; 
		      	               end
		      	            end else if (HOUR0_IN == 4'd9) begin
			                     HOUR0_IN <= 4'd0;
			                     HOUR1_IN <= HOUR1_IN + 4'd1; // INCREASE HOUR1
			                  end else begin
			                     HOUR0_IN <= HOUR0_IN + 4'd1; // INCREASE HOUR0
								      HOUR1_IN <= HOUR1_IN;
			                  end                
		                  end else begin
			                  MIN1_IN <= MIN1_IN + 4'd1; // INCREASE MINUTE1
		                  end
		               end else begin
		                  MIN0_IN <= MIN0_IN + 4'd1; // INCREASE MINUTE0
		               end
	               end else begin
		               SEC1_IN <= SEC1_IN + 4'd1; // INCREASE SECONDS1
	               end
	            end else begin
			         SEC0_IN <= SEC0_IN + 4'd1;
			      end
            end else begin
               CNT <= CNT + 10'd1;
			      SEC0_IN <= SEC0_IN;
		      end
         end
      end
   end

 assign SEG0 = SEC0_IN;
 assign SEG1 = SEC1_IN;
 assign SEG2 = MIN0_IN;
 assign SEG3 = MIN1_IN;
 assign SEG4 = HOUR0_IN;
 assign SEG5 = HOUR1_IN;
 assign SEG6 = DAY0_IN;
 assign SEG7 = DAY1_IN;


 endmodule

