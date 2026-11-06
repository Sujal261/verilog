module rom(addr, data, rd_en, cs);
  input [2:0] addr; 
  input rd_en, cs; 
  output reg [7:0] data; 

  always @(*) begin
    // default so the output is always assigned
    data = 8'd0; 
    if(rd_en && cs) begin 
      case(addr) 
        3'd0: data = 8'd22; 
        3'd1: data = 8'd45; 
        3'd7: data = 8'd12;
        default: data = 8'd0; 
      endcase
    end 


    
  end
endmodule
