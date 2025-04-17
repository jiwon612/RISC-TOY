module CLKGEN1HZ (/*AUTOARG*/
		  // Outputs
		  CLK1H,
		  // Inputs
		  CLK1K, RSTN
		  );

   input CLK1K;
   input RSTN;
   output reg CLK1H;

   reg [8:0]  CNT;

   always @(posedge CLK1K or negedge RSTN) begin
      if (!RSTN) begin
			 CLK1H <= 1'b0;
			 CNT <= 9'd0;
      end else begin
			if (CNT == 9'd499) begin
				CNT <= 9'd0;
				CLK1H <= ~CLK1H;
			end else begin
				CNT <= CNT + 9'd1;
			end
		end
	end
		
endmodule
