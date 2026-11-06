module tb_ram; 
  reg [9:0] addr; 
  reg clk, rd, wr, cs; 
  reg [7:0] data_drv; 
  reg drive; 
  wire [7:0] data; 

  assign data = drive ? data_drv : 8'bz; 

  ram_s DUT(.addr(addr), .data(data), .clk(clk), .rd(rd), .wr(wr), .cs(cs)); 

  initial clk = 0; 
  always #5 clk = ~clk; 

  initial begin 
    addr =0; rd =0; wr = 0; cs =0; drive =0; data_drv = 0; 

    @(negedge clk); 
      addr = 10'd5; data_drv = 8'hA5; drive = 1; 
      cs = 1; wr =1; rd =0; 
    @(negedge clk);
    wr=0; cs = 0; drive =0; 

    @(negedge clk); 
    addr = 10'd5; cs = 1; rd = 1; wr =0; 
    @(negedge clk); 
    $display("Read addr 5:data = %h", data); 

    @(negedge clk); 
    rd =0; cs =0; 
    #1 $finish; 
  end 
  initial 
    begin
    $dumpfile("ram.vcd"); 
    $dumpvars(0, tb_ram);
    end
endmodule
