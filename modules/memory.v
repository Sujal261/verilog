module memory_model;
  reg [7:0] mem[0:1023];
  //initializing using directly assigning 
  initial begin
    mem[0] = 8'b01100011;
    mem[1] = 8'b11110000;
  end
endmodule

module memory_model1;
  reg [7:0] mem1[0:1023];

  initial begin
    //reading from the hexadecimal file
    $readmemh("mem.dat", mem1);
    // reading from a binary file from  specific addresses 
    $readmemb("mem.dat", mem1, 50, 200);
  end
endmodule

module parameterized_memory (
    data_out,
    data_in,
    addr,
    wr,
    cs
);
  parameter addr_size   = 10;
  parameter word_size   = 8;
  parameter memory_size = 1024;

  input [addr_size - 1:0] addr;
  input [word_size-1:0] data_in;
  input wr, cs;
  output [word_size-1:0] data_out;

  reg [word_size-1:0] mem[0:memory_size-1];
  assign data_out = mem[addr];

  always @(*) if (cs && wr) mem[addr] = data_in;
endmodule


