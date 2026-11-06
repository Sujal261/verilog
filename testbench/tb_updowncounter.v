module tb_updowncounter; 
reg mode=0, ld=0 , clr=0, clk=0;
reg [7:0] din =0; 
wire [7:0] count;

updowncounter dut(.mode(mode), .ld(ld), .clr(clr), .clk(clk), .din(din), .count(count));
always #5 clk = ~clk;
initial begin
    $dumpfile("updowncounter.vcd"); 
    $dumpvars(0, tb_updowncounter); 
    $monitor("t=%0t ld=%b clr=%b mode=%b din=%d count=%d", $time, ld, clr, mode, din, count);
    din = 8'd250; ld=1; #10 ld=0; 
    mode = 1; #80; 
    mode =0; #40; 
    din = 8'd77; ld=1; clr=1; #10 ;
    ld =0; #10; 
    $finish;

end
endmodule