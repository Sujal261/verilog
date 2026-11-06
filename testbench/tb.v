`timescale 1ns/1ps

module tb;
    reg clk = 0;
    reg reset = 1;
    wire [3:0] count;

    counter uut (.clk(clk), .reset(reset), .count(count));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
        $monitor("t=%0t reset=%b count=%d", $time, reset, count);

        #12 reset = 0;
        #100 $finish;
    end
endmodule

