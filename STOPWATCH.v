module STOPWATCH(
   input CLK, RSTN,
   input SW2, SW3,
   input START,
   output reg [3:0] STOP_SEC0, STOP_SEC1,
   output reg [3:0] STOP_MIN0, STOP_MIN1,
   output reg [3:0] STOP_HOUR0, STOP_HOUR1,
   output reg [3:0] STOP_DAY0, STOP_DAY1
);

parameter IDLE = 1'b0, RUN = 1'b1;

reg STATE, NEXT_STATE;
reg PREV_START;
reg [9:0] CNT;
wire [9:0] CNT_SELECT;

assign CNT_SELECT = SW3 ? 10'd9 : 10'd999; // DEBUG MODE = 9, NOT DEBUG = 999

always @(posedge CLK or negedge RSTN) begin
   if (!RSTN) STATE <= IDLE;
   else       STATE <= NEXT_STATE;
end

always @(*) begin
   NEXT_STATE = STATE;
   if (SW2) begin
      case (STATE)
         IDLE: if (START && !PREV_START) NEXT_STATE = RUN;
         RUN:  if (START && !PREV_START) NEXT_STATE = IDLE;
      endcase
   end else
      NEXT_STATE = IDLE;
end

always @(posedge CLK or negedge RSTN) begin
   if (!RSTN) begin
      {STOP_SEC0, STOP_SEC1, STOP_MIN0, STOP_MIN1,
       STOP_HOUR0, STOP_HOUR1, STOP_DAY1} <= 0;
      STOP_DAY0 <= 4'd1;
      PREV_START <= 1'b0;
		CNT <= 10'd0; // COUNTER FOR 1S
   end
   else begin
      PREV_START <= START;

      if (!SW2) begin
         {STOP_SEC0, STOP_SEC1, STOP_MIN0, STOP_MIN1,
          STOP_HOUR0, STOP_HOUR1, STOP_DAY1} <= 0;
         STOP_DAY0 <= 4'd1;
      end
      else if (STATE == RUN) begin
		 if (CNT == CNT_SELECT) begin
			CNT <= 10'd0;
			if (STOP_SEC0 == 4'd9) begin
            STOP_SEC0 <= 4'd0;
            if (STOP_SEC1 == 4'd5) begin
               STOP_SEC1 <= 4'd0;
               if (STOP_MIN0 == 4'd9) begin
                  STOP_MIN0 <= 4'd0;
                  if (STOP_MIN1 == 4'd5) begin
                     STOP_MIN1 <= 4'd0;
                     if (STOP_HOUR0 == 4'd3 && STOP_HOUR1 == 4'd2) begin
                        STOP_HOUR0 <= 4'd0;
                        STOP_HOUR1 <= 4'd0;
                        if (STOP_DAY0 == 4'd1 && STOP_DAY1 == 4'd3) begin
                           STOP_DAY0 <= 4'd1;
                           STOP_DAY1 <= 4'd0;
                        end else if (STOP_DAY0 == 4'd9) begin
                           STOP_DAY0 <= 4'd0;
                           STOP_DAY1 <= STOP_DAY1 + 4'd1;
                        end else begin
                           STOP_DAY0 <= STOP_DAY0 + 4'd1;
                        end
                     end else if (STOP_HOUR0 == 4'd9) begin
                        STOP_HOUR0 <= 4'd0;
                        STOP_HOUR1 <= STOP_HOUR1 + 4'd1;
                     end else begin
                        STOP_HOUR0 <= STOP_HOUR0 + 4'd1;
                     end
                  end else begin
                     STOP_MIN1 <= STOP_MIN1 + 4'd1;
                  end
               end else begin
                  STOP_MIN0 <= STOP_MIN0 + 4'd1;
               end
            end else begin
               STOP_SEC1 <= STOP_SEC1 + 4'd1;
            end
         end else begin
            STOP_SEC0 <= STOP_SEC0 + 4'd1;
         end
      end else begin
 		   CNT <= CNT + 10'd1;
			STOP_SEC0 <= STOP_SEC0;
      end
     end
   end
end

endmodule

