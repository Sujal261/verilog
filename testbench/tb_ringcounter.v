module tb_ringcounter; 
    reg clk=0, init =1; 
    wire [7:0] count; 

    always #5 clk = ~clk; 
    ringcounter dut(.clk(clk), .init(init), .count(count));
    initial begin 
        $dumpfile("ringcounter.vcd"); 
        $dumpvars(0, tb_ringcounter); 
        $monitor("t=%0t count = %b", $time, count); 
        #7 init =0; 
        #100 $finish;
    end
endmodule