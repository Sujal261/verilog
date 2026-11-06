module tb_udpadder; 
reg a, b, c; 
wire sum, cout; 
integer i;
udpadder dut(.a(a), .b(b), .c(c), .sum(sum), .cout(cout)); 
initial begin 
    $monitor("a=%b b=%b, c=%b sum=%b carry=%b", a , b, c, sum, cout); 
    for(i=0; i<8; i=i+1) begin 
        {a, b, c} = i[2:0]; 
        #10;
    end
    $finish; 
    end
endmodule

        
