module DEBOUNCING (
    input 	CLK1K,         // 1kHz clock input
    input RSTN,          // Active low reset
    input KEY,           // Raw button input (active low)
    output reg KEY_STABLE // 1-clock pulse when button pressed (1→0)
);

    parameter N = 10; // debounce duration: 10ms

    reg [3:0] stable_cnt;
    reg key_sync_0, key_sync_1, key_sync_2, key_sync_3;
    reg key_prev;
    reg key_stable_state;

    // Input synchronizer
    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            key_sync_0 <= 1'b1;
            key_sync_1 <= 1'b1;
				key_sync_2 <= 1'b1;
				key_sync_3 <= 1'b1;
        end else begin
            key_sync_0 <= KEY;
            key_sync_1 <= key_sync_0;
				key_sync_2 <= key_sync_1;
				key_sync_3 <= key_sync_2;
        end
    end

    // Debounce + falling edge detection
    always @(posedge CLK1K or negedge RSTN) begin
        if (!RSTN) begin
            stable_cnt       <= 4'd0;
            key_prev         <= 1'b1;
            key_stable_state <= 1'b1;
            KEY_STABLE       <= 1'b0;
        end else begin
                if (key_sync_3 == key_prev) begin
                    if (stable_cnt < N)
                        stable_cnt <= stable_cnt + 4'd1;
                    else if (stable_cnt == N) begin
                        if (key_stable_state == 1'b1 && key_sync_3 == 1'b0) begin
                            // Button pressed (1→0), stable for N clocks
                            KEY_STABLE <= 1'b1;
                        end else begin
                            KEY_STABLE <= 1'b0;
                        end
                        key_stable_state <= key_sync_3;
                    end else begin
                        KEY_STABLE <= 1'b0;
                    end
                end else begin
                    stable_cnt <= 0;
                    key_prev   <= key_sync_3;
                    KEY_STABLE <= 1'b0;
                end
        end
    end

endmodule
