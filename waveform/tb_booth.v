module tb_booth;
  reg clk = 0, start = 0;
  reg [15:0] data_in;
  wire done;
  wire signed [31:0] product;
  wire ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, addsub, decr, ldcnt, q0, qm1, eqz;

  booth_datapath DUT1 (
      ldA,
      ldQ,
      ldM,
      clrA,
      clrQ,
      clrff,
      sftA,
      sftQ,
      addsub,
      decr,
      ldcnt,
      data_in,
      clk,
      q0,
      qm1,
      eqz
  );
  booth_controller DUT2 (
      ldA,
      clrA,
      sftA,
      ldQ,
      clrQ,
      sftQ,
      ldM,
      clrff,
      addsub,
      start,
      decr,
      ldcnt,
      done,
      clk,
      q0,
      qm1,
      eqz
  );

  assign product = {DUT1.A, DUT1.Q};

  always #5 clk = ~clk;

  initial begin
    data_in = 12;       // multiplicand, captured into M at t=35
    #16 start = 1;      // t=16, FSM leaves S0 at the t=25 edge
    #24 data_in = -5;   // t=40, multiplier, captured into Q at t=45
    #1000 $finish;
  end

  initial begin
    $dumpfile("booth.vcd");
    $dumpvars(0, tb_booth);
    $monitor("%0t Done = %b Product = %d, A = %d", $time, done, product, DUT1.A);
  end
endmodule
