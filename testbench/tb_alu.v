module tb_alu;
wire [7:0] f;
reg [7:0] a, b;
reg [1:0] op;  
integer i;  
alu8bit dut(.f(f), .a(a), .b(b), .op(op));

initial begin 
    a = 8; b=4;
    for(i=0; i<4; i=i+1) begin 
        op = i[1:0]; #5; 
        $display("op = %b, a=%d, b=%d, f=%d", op,a, b, f );
end
$finish;
end

endmodule