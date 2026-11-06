module tb_priorityencoder; 
reg [7:0] in; 
wire [2:0] code; 

priorityencoder dut (.in(in), .code(code)); 

initial begin 
    $monitor("in=%b, code=%b", in, code); 
    in = 8'b00000000; 
    #10 in = 8'b10000000; 
    #10 in = 8'b00101000; 
    #10 in = 8'b11111111; 
    #10 in = 8'b11110100; 
    #10 $finish; 
end 
endmodule