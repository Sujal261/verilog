module tb_parity; 
    reg clk = 1, x; 
    wire z; 

    parity DUT(.x(x), .clk(clk), .z(z)); 

    always #5 clk = ~clk;

    initial begin 
        $dumpfile("parity.vcd"); 
        $dumpvars(0, tb_parity); 
        $monitor("Time = %0t x=%b z=%b", $time, x, z);
        #2 x=0; #10 x =1; #10 x=1; #10 x=1; 
        #10 x=0; #10 x=1; #10 x=1; #10 x=0; 
        #10 x=0; #10 x=1; #10 x=1; #10 x=0; 
        #10 $finish; 
    end 
endmodule

    
