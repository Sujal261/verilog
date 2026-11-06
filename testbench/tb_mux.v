module tb_mux; 
    reg in0, in1, s; 
    wire f; 
    integer i; 
    mux2to1_star dut (.in0(in0), .in1(in1), .s(s), .f(f)); 

    initial begin 
        $dumpfile("tb_mux.vcd"); 
        $dumpvars(0, tb_mux); 

        $monitor("t=%0t s=%b in1=%b in0=%b -> f=%b", $time, s, in1, in0, f); 
        for(i =0; i <8 ; i =i+1) begin 
            {s, in1, in0} = i[2:0]; 
            #10; 
        end 
        $finish; 
    end
endmodule