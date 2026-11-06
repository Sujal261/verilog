module tb_countera; 
reg clk =0, rst =1; 
wire [3:0] count; 
countera dut(.clk(clk), .rst(rst), .count(count)); 

always #5 clk = ~clk; 
initial begin 
    $dumpfile("counter.vcd"); 
    $dumpvars(0, tb_countera);
    $monitor("t = %0t, rst=%b count=%d", $time, rst, count); 
    #12 rst=0; 
  #120 rst=1; 
    #7 rst=0; 
    #50 $finish; 

end
endmodule