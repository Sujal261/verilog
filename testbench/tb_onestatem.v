module test_ones; 
    reg clk, x, reset; 
    wire z; 
    ones_detector DUT(x, clk, reset, z); 
    initial begin 
        $dumpfile("ones.vcd"); 
        $dumpvars(0, test_ones); 
        clk = 0; reset = 1; 
        #13 reset = 0;
    end

    always #5 clk = ~clk; 

    initial begin 
        #12 x=1; #10 x=1; #10 x=0; #10 x=1; 
        #10 x=1; #10 x=1; #10 x=1; #10 x=0; 
        #10 x=1; #10 x=1; #10 x=1; #10 x=0; 
        #10 $finish; 
    end

    always @(posedge clk) if(!reset)
        $display("t=%0t x=%b z=%b", $time, x, z); 
endmodule
