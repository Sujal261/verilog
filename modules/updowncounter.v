module updowncounter (
    input wire [7:0] din, 
    output reg [7:0] count, 
    input wire mode, clr, ld, clk

); 
always @(posedge clk) begin 
    if (ld) count <= din; 
    else if(clr) count <=0;
    else if(mode) count <= count +1; 
    else count <= count -1;
end
endmodule