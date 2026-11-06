module register_bank(rdData1, rdData2, wrData, sr1, sr2, dr, write, clk); 
  input clk, write; 
  input [1:0] sr1, sr2, dr; 
  input [31:0] wrData; 
  output [31:0] rdData1, rdData2; 

  reg [31:0] R0, R1, R2, R3; 
  
  assign rdData1 = (sr1 == 0 )? R0 : 
                   (sr1 == 1) ? R1 : 
                   (sr1 == 2) ? R2 : R3; 

  assign rdData2 = (sr2 == 0)? R0 : 
                    (sr2 == 1)? R1 : 
                    (sr2 == 2)? R2: R3; 

  always @(posedge clk) begin
    if(write) begin
      case(dr)  
        0: R0 <= wrData; 
        1: R1 <=wrData; 
        2: R2 <=wrData; 
        3: R3 <= wrData; 
      endcase
  end
  end 
endmodule

module array_register(rdData1, rdData2, wrData, sr1, sr2,dr, write,reset, clk); 
  input clk, write, reset; 
  input [4:0] sr1, sr2, dr; 
  input [31:0] wrData; 
  output [31:0] rdData1, rdData2; 
  integer k;
  reg [31:0] regfile [0:32]; 
  assign rdData1 = regfile[sr1]; 
  assign rdData2 = regfile[sr2]; 
  
  always @(posedge clk) begin
  if(reset) begin 
    for(k=0; k<32; k = k+1) 
        regfile[k] <= 32'b0;
    end else if(write) begin  
        regfile[dr] <=wrData;
      end
    end
endmodule
