module ones_detector(x, clk, reset, z); 
    input x, clk, reset; 
    output reg z; 

    parameter A=0, B=1, C=2, D=3; 
    reg [1:0] PS, NS; 

    always @(posedge clk or posedge reset) 
    if (reset) PS<=A; 
    else PS <=NS; 

    always @(PS, x) 
        case(PS) 
            A: begin z=0; NS = x ? B : A; end
            B: begin z=0; NS = x ? C : A; end
            C: begin z=x; NS = x ? D : A; end
            D: begin z=x; NS = x ? D : A; end
        endcase
endmodule
