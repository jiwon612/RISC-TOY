module DECODE7SEG(/*AUTOARG*/
		   // Outputs
		   OUT,
		   // Inputs
		   IN
		   );

input [3:0] IN;
output reg [6:0] OUT;

always@(*) begin
   OUT = 7'b1111111;
   case (IN)
     4'd0 : OUT = 7'b1000000; // 0
     4'd1 : OUT = 7'b1111001; // 1
     4'd2 : OUT = 7'b0100100; // 2
     4'd3 : OUT = 7'b0110000; // 3
     4'd4 : OUT = 7'b0011001; // 4
     4'd5 : OUT = 7'b0010010; // 5
     4'd6 : OUT = 7'b0000010; // 6
     4'd7 : OUT = 7'b1111000; // 7
     4'd8 : OUT = 7'b0000000; // 8
     4'd9 : OUT = 7'b0010000; // 9
     default : OUT = 7'b1111111; // default
   endcase
end
endmodule
