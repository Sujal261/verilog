module tb_RCA; 
    parameter N = 4;
    reg [N-1:0] a, b; 
    reg cin; 
    wire [N-1:0] sum; 
    wire cout; 
    integer i, j,k, errors =0; 
    RCA #(.N(N)) dut(.carry_out(cout), .sum(sum), .a(a), .b(b), .carry_in(cin)); 
    initial begin 
        for(i=0; i<16; i=i+1) 
            for(j=0; j<16;j=j+1) 
                for(k=0; k<2; k=k+1) begin 
                    a = i; b = j; cin=k; #1; 
                    if({cout, sum} !== a+b+cin) begin 
                        errors = errors +1; 
                        $display("FAIL a=%0d a=%0d b=%0d -> %0d", a, b, cin, {cout, sum}); 

                    end
                end

        $display("Done. errors= %0d", errors); 

        $display("fa_loop[0].t1 = %b", dut.fa_loop[0].t1);
        $finish;
    end


endmodule   