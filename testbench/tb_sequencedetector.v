module test_sequence;
  reg clk, x, reset;
  wire z;
  seq_detector SEQ (x, clk, reset, z);

  initial begin
    $dumpfile("sequence.vcd");
    $dumpvars(0, test_sequence);
    clk = 1'b0; reset = 1'b1;
    #13 reset = 1'b0;
  end

  always #5 clk = ~clk;

  initial begin
    #12 x = 0; #10 x = 0; #10 x = 1; #10 x = 1;
    #10 x = 0; #10 x = 1; #10 x = 1; #10 x = 0;
    #10 x = 0; #10 x = 1; #10 x = 1; #10 x = 0;
    #10 $finish;
  end

  always @(posedge clk) if (!reset)
    $display("t=%0t x=%b z=%b", $time, x, z);
endmodule
