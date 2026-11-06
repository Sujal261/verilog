module tb_pipeline_ex; 
  parameter N =10; 
  wire [N-1:0] F; 
  reg [N-1:0] A, B, C, D; 
  reg clk; 

  pipe_ex DUT(F, A, B, C, D, clk); 

  initial clk =0; 
  always #5 clk = ~clk; 

  initial
    begin
      #5 A=10; B = 12; C=6; D=3;
      #20 A=20; B = 10; C=5; D=3;

      #20 A=30; B = 11; C=4; D=3;
      #20 A=40; B = 10; C=3; D=3;
      #20 A=50; B = 15; C=2; D=3;
      #20 A=8; B = 12; C=1; D=3;
      #20 A=10; B = 5; C=6; D=3;
      #20 A=30; B = 20; C=5; D=3;
  
    end

    initial 
      begin
        $dumpfile("pipe1.gcd"); 
        $dumpvars(0, tb_pipeline_ex); 
        $monitor("Time: %d, F = %d", $time, F);
        #300 $finish;
      end
endmodule
