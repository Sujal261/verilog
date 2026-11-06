module tb_pararam;
  reg [9:0] address; 
  reg [7:0] data_in; 
  reg write, select; 
  wire [7:0] data_out; 
  integer k , myseed, rnd; 

  parameterized_memory DUT(data_out, data_in, address, write, select); 
  initial begin
  address = 0; 
  data_in =0; 
  write = 0; 
  select = 0; 
  myseed = 35; 

  for(k =0; k<1024; k=k+1) begin 
  address = k; 
  data_in = (k+k)%256; 
  write = 1; 
  select = 1; 
  #2; 
  write = 0;
  select =0; 
  #2;
  end
  
  repeat (20) begin 
    rnd = $random(myseed); 
    address = (rnd & 32'h7fffffff) % 1024; 
    write =0; select=1; 
    #1; $display("Address = %5d, Data = %4d", address, data_out); 
    #1; 
    select =0; 
  end
  end
  
  initial begin
    $dumpfile("parameter.vcd"); 
    $dumpvars(0, tb_pararam);
  end
endmodule
