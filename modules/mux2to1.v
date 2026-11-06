module mux2to1_star (
    input wire in0, in1, s, 
    output reg f 
); 
    always @(*) begin 
        if (s) f = in1; 
        else   f = in0;
        end 

    endmodule  