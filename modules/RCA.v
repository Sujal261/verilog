module RCA #(parameter N = 8)(
    output wire carry_out,
    output wire [N-1:0] sum, 
    input wire [N-1:0] a, b, 
    input wire carry_in
);
    wire [N:0] carry; 
    assign carry[0] = carry_in; 
    assign carry_out = carry[N]; 

    genvar i; 
    generate 
        for(i=0; i<N; i=i+1) begin : fa_loop 
            wire t1, t2, t3; 
            xor G1(t1, a[i], b[i]); 
            xor G2(sum[i], t1, carry[i]); 
            and G3 (t2, a[i], b[i]); 
            and G4(t3, t1, carry[i]); 
            or G5(carry[i+1], t2, t3);
        end

    endgenerate
endmodule