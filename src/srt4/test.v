

module test ();
   localparam DW=32;

   reg clk, rst_n, start;
   reg [DW-1:0] dividend;
   reg [DW-1:0] divisor;
   
   reg [DW-1:0] quotient;
   reg [DW-1:0] remainder;

   reg [DW-1:0] quospec;
   reg [DW-1:0] remspec;
  
   reg 		divfinish, diverror;

   srt_4_div divinst (.reminder(remainder), .*);

   
   always #10 clk = ~clk;

   initial begin
      int i;
      
      clk = 0;
      rst_n = 1;
      start = 0;
      #20
	rst_n = 0;
      #20
	rst_n = 1;
      
      for (i=0; i<1000; i++) begin
	 bit [4:0] dividend_shift, divisor_shift;
	 dividend_shift = $random;
	 divisor_shift = $random;
	 dividend = ($random >> dividend_shift);
	 divisor = ($random >> divisor_shift);
	   quospec = dividend / divisor;
	   remspec = dividend % divisor;
	   start = 1;
	   $display("Dividing %h / %h", dividend, divisor);
	   $display("spec: / %h, %% %h", quospec, remspec);
	   #20
	   while (!divfinish) begin
	      $display("rem=%h quo=%h counter=%h iters=%h st=%h", divinst.w_reg, divinst.u3.q_reg, divinst.counter, divinst.iterations_reg, divinst.state);
	      #20;
	   end
	 $display("done:");
	 $display("rem=%h quo=%h counter=%h iters=%h st=%h", divinst.w_reg, divinst.u3.q_reg, divinst.counter, divinst.iterations_reg, divinst.state);
	   if (divisor == 0) begin
	      if (diverror != 1)
		$display("Incorrect diverror: %h", diverror);
	   end else begin
	      if (diverror != 0)
		$display("Incorrect diverror: %h", diverror);
	      
	      if (quotient != quospec)
		$display("Incorrect quotient: %h", quotient);
	      
	      if (remainder != remspec)
		$display("Incorrect remainder: %h", remainder);
	   end // else: !if(divisor == 0)
	end // for (int i=0; i<100; i++)
      $finish();
   end // initial begin
endmodule // test

      
