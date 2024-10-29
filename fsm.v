module fsm (
	input clk,
	input rstb,
	input enable,
	output reg [3:0] out
);
	typedef enum {S1=8, S2=1, S3=3, S4=4, S5=5, S6=7} fsm_type;
	fsm_type st, nx_st;

	always @(posedge clk, negedge rstb) begin
		if (~rstb)
			st <= S1;
		else
			st <= nx_st;
	end

	always @(*) begin
		out = 0;
		case (st)
			S1: 
				if (enable) begin
					nx_st = S2;
					out = 10;
				end else begin
					nx_st = S4;
					out = 5;
				end
			S2: nx_st = S3;
			S3: nx_st = S4;
			S4: nx_st = S5;
			S5: nx_st = S6;
			default: nx_st = S1;
		endcase
	end

endmodule

