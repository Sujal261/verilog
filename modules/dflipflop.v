module dflipflop (
    input wire clk, D, 
    output reg Q, Qbar
); 
always @(negedge clk) begin 
    Q <= D; 
    Qbar <= ~D;
end
endmodule

