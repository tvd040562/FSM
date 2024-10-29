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

	always_comb begin
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
			S6: nx_st = S1;
		endcase
	end

endmodule

module tb;
	reg clk, rstb, enable;
	reg [3:0] out;

	fsm dut (
		.clk(clk),
		.rstb(rstb),
		.enable(enable),
		.out(out)
	);

	initial begin
		clk = 0;
		forever
			#5 clk = ~clk;
	end

	task wait4clk (input integer n);
		begin 
			repeat (n) 
				@(posedge clk); 
		end
	endtask

	initial begin
		$dumpfile("fsm.vcd");
		$dumpvars();
		rstb = 0;
		enable = 0;
		wait4clk(2);
		rstb = 1;
		wait4clk(10);
		enable = 1;
		wait4clk(10);
		$finish();
	end
endmodule
