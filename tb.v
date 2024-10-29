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

