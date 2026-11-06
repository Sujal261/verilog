module tb_GCD;
  reg [15:0] data_in;
  reg clk = 0, start = 0, reset = 1;
  wire ldA, ldB, sel1, sel2, sel_in, lt, gt, eq, done;
  wire [15:0] result;

  GCD_datapath DUT1 (
      .ldA(ldA),
      .ldB(ldB),
      .sel1(sel1),
      .sel2(sel2),
      .sel_in(sel_in),
      .clk(clk),
      .data_in(data_in),
      .lt(lt),
      .gt(gt),
      .eq(eq)
  );

  GCD_controller DUT2 (
      .clk(clk),

      .lt(lt),
      .gt(gt),
      .eq(eq),
      .start(start),
      .ldA(ldA),
      .ldB(ldB),
      .sel1(sel1),
      .sel2(sel2),
      .sel_in(sel_in),
      .done(done)
  );

  always #5 clk = ~clk;

  initial begin
    data_in = 143;
    #12 #4 start = 1;  // t=16, data_in=143 is captured into A at t=25
    #10 data_in = 78;  // t=26, captured into B at t=35
    wait (done);
    #10 $display("GCD = %0d", result);
    $finish;
  end

  initial begin
    $monitor("%0t A=%0d B=%0d done=%b", $time, DUT1.Aout, DUT1.Bout, done);
    $dumpfile("GCD.vcd");
    $dumpvars(0, tb_GCD);
  end
endmodule
