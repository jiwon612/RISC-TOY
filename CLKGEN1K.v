module CLKGEN1K (/*AUTOARG*/
   // Outputs
   CLK1K,
   // Inputs
   CLK50M, RSTN
   );
   input CLK50M; // 20ns
   input RSTN;
   output reg CLK1K; // 1ms

   reg [14:0] CNT;

   always@(posedge CLK50M, negedge RSTN) begin
      if (!RSTN) begin
	 		CNT <= 15'd0;
	 		CLK1K <= 1'd0;	
      end
      else begin
	 		CNT <= (CNT == 15'd24999) ? 15'd0 : CNT + 15'd1;
	 		CLK1K <= (CNT == 15'd24999) ? ~CLK1K : CLK1K;
      end
   end

endmodule
