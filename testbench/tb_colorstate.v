module tb_colorstate; 
    reg clk=0; 
    wire [0:2] light; 

    colorstate DUT(clk, light); 

    always #5 clk = ~clk;
    initial begin
        $dumpfile("colorstate.vcd"); 
        $dumpvars(0, tb_colorstate); 
        $monitor("Time =%0t color = %b", $time, light); 
        #100 $finish; 
    end 
endmodule 


