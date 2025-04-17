module TIMER (/*AUTOARG*/
	      // Outputs
	      TSEG0, LED, 
	      // Inputs
	      CLK1H, RSTN, SOUNDSENSOR, SW6
	      );

   input CLK1H;
   input RSTN;
	input SOUNDSENSOR;
   input SW6;
   output reg [3:0] TSEG0;
	wire TIMEOUT;
	output reg LED;
	
   always @(posedge CLK1H or negedge RSTN) begin
      if (!RSTN) begin
         TSEG0 <= 4'd0;
			LED <= 1'b0;
      end else begin
	      if (!SW6) begin
	         TSEG0 <= 4'd3; // START FROM 3sec
				LED <= 1'b0;
	      end else begin
			   LED <= TIMEOUT;
            // When SW6 is pressed, allow setting of the time
            // Countdown logic when SW6 is not pressed
		      if (SOUNDSENSOR && !TIMEOUT) begin
					if (TSEG0 != 4'd0) begin
						TSEG0 <= TSEG0 - 4'd1;
		         end else begin
						TSEG0 <= 4'd0;
					end 
		      end else if (!TIMEOUT) begin
					TSEG0 <= 4'd3;
				end
			end
		end 
   end

   // Assigning the time to the segment outputs
	assign TIMEOUT = (TSEG0 == 4'd0) ? 1'b1 : 1'b0;
endmodule
