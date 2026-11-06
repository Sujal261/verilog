module mul_datapath (
    ldA,
    ldP,
    clrP,
    ldB,
    decB,
    data_in,
    eqz,
    clk
);
  input ldA, ldB, ldP, decB, clk, clrP;
  input [15:0] data_in;
  output eqz;
  wire [15:0] X, Y, Z, Bout, Bus;

  assign Bus = data_in;

  PIPO1 A (
      X,
      Bus,
      ldA,
      clk
  );
  PIPO2 P (
      Y,
      Z,
      ldP,
      clk,
      clrP
  );
  CNTR B (
      Bout,
      ldB,
      clk,
      decB,
      Bus
  );
  ADD AD (
      Z,
      X,
      Y
  );
  EQZ COMP (
      eqz,
      Bout
  );
endmodule

module PIPO1 (
    dout,
    din,
    ld,
    clk
);
  input [15:0] din;
  input ld, clk;
  output reg [15:0] dout;

  always @(posedge clk) if (ld) dout <= din;
endmodule

module PIPO2 (
    dout,
    din,
    ld,
    clk,
    clr
);
  input [15:0] din;
  input ld, clk, clr;
  output reg [15:0] dout;

  always @(posedge clk)
    if (clr) dout <= 16'b0;
    else if (ld) dout <= din;
endmodule


module CNTR (
    Bout,
    ld,
    clk,
    dec,
    din
);
  input [15:0] din;
  input ld, clk, dec;
  output reg [15:0] Bout;

  always @(posedge clk)
    if (ld) Bout <= din;
    else if (dec) Bout <= Bout - 1;
endmodule

module EQZ (
    eqz,
    data
);
  input [15:0] data;
  output eqz;

  assign eqz = (data == 0);
endmodule

module ADD (
    out,
    in1,
    in2
);
  input [15:0] in1, in2;
  output reg [15:0] out;

  always @(*) out = in1 + in2;
endmodule


module controller (
    ldA,
    ldB,
    ldP,
    clrP,
    decB,
    clk,
    eqz,
    start,
    reset,
    done
);
  input clk, eqz, start, reset;
  output reg ldA, ldB, ldP, clrP, decB, done;
  reg [2:0] PS, NS;
  parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;

  always @(posedge clk)
    if (reset) PS <= S0;
    else PS <= NS;

  always @(*) begin
    case (PS)
      S0:
      if (start) NS = S1;
      else NS = S0;
      S1: NS = S2;
      S2: NS = S3;
      S3:
      #2
      if (eqz) NS = S4;
      else NS = S3;
      S4: NS = S4;
      default: NS = S0;
    endcase
  end

  always @(PS) begin
    ldA  = 0;
    ldB  = 0;
    ldP  = 0;
    clrP = 0;
    decB = 0;
    done = 0;
    case (PS)
      S0: begin
        #1 ldA = 0;
        ldB  = 0;
        ldP  = 0;
        clrP = 0;
        decB = 0;
      end
      S1: begin
        #1 ldA = 1;
      end
      S2: begin
        #1 ldA = 0;
        ldB  = 1;
        clrP = 1;
      end
      S3: begin
        #1 ldB = 0;
        ldP  = 1;
        clrP = 0;
        decB = 1;
      end
      S4: begin
        #1 done = 1;
        ldB  = 0;
        ldP  = 0;
        decB = 0;
      end
      default: begin
        #1 ldA = 0;
        ldB  = 0;
        ldP  = 0;
        clrP = 0;
        decB = 0;
      end
    endcase
  end
endmodule

