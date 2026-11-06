module ram_s (
    addr,
    data,
    clk,
    rd,
    wr,
    cs
);
  input [9:0] addr;
  input clk, rd, wr, cs;
  inout [7:0] data;

  reg [7:0] mem[0:1023];
  reg [7:0] d_out;

  assign data = (cs && rd && !wr) ? d_out : 8'bz;

  always @(posedge clk) if (cs && wr && !rd) mem[addr] <= data;
  always @(posedge clk) if (cs && rd && !wr) d_out <= mem[addr];
endmodule

module ram_a (
    addr,
    data,
    clk,
    rd,
    wr,
    cs
);
  input [9:0] addr;
  input clk, rd, wr, cs;
  inout [7:0] data;

  reg [7:0] mem[0:1023];
  reg [7:0] d_out;

  assign data = (cs && rd && !wr) ? d_out : 8'bz;

  always @(addr or data or rd or wr or cs) if (cs && wr && !rd) mem[addr] = data;

  always @(addr or data or cs or wr or rd) if (cs && !wr && rd) d_out = mem[addr];

endmodule


