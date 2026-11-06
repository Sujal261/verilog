module tb_dff; 
reg clk =0, D =0; 
wire Q, Qbar; 

dflipflop dut (.clk(clk), .D(D), .Q(Q), .Qbar(Qbar)); 

always #5 clk = ~clk; 

initial begin 
    $dumpfile("dff.vcd"); 
    $dumpvars(0, tb_dff); 
    #12 D=1; 
    #10 D=0;
    #10 D=1; 
    #20 $finish;
end
endmodule

