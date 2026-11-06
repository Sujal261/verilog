module booth_datapath (
    ldA,
    ldQ,
    ldM,
    clrA,
    clrQ,
    clrff,
    sftA,
    sftQ,
    addsub,
    decr,
    ldcnt,
    data_in,
    clk,
    q0,
    qm1,
    eqz
);
  input ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, addsub, clk, decr, ldcnt;
  input [15:0] data_in;
  output q0, qm1, eqz;
  wire [15:0] A, M, Q, Z;
  wire [4:0] count;

  assign eqz = ~|count;
  assign q0  = Q[0];

  shiftreg AR (
      A,
      Z,
      A[15],
      clk,
      ldA,
      clrA,
      sftA
  );
  shiftreg QR (
      Q,
      data_in,
      A[0],
      clk,
      ldQ,
      clrQ,
      sftQ
  );
  dff QM1 (
      Q[0],
      qm1,
      clk,
      clrff
  );
  PIPO MR (
      M,
      data_in,
      clk,
      ldM
  );
  ALU AS (
      Z,
      A,
      M,
      addsub
  );
  counter CN (
      count,
      decr,
      ldcnt,
      clk
  );

endmodule

module shiftreg (
    data_out,
    data_in,
    s_in,
    clk,
    ld,
    clr,
    sft
);
  input s_in, clk, ld, clr, sft;
  input [15:0] data_in;
  output reg [15:0] data_out;

  always @(posedge clk) begin
    if (clr) data_out <= 0;
    else if (ld) data_out <= data_in;
    else if (sft) data_out <= {s_in, data_out[15:1]};
  end
endmodule

module PIPO (
    data_out,
    data_in,
    clk,
    load
);
  input [15:0] data_in;
  input clk, load;
  output reg [15:0] data_out;

  always @(posedge clk) if (load) data_out <= data_in;
endmodule

module ALU (
    out,
    in1,
    in2,
    addsub
);
  input [15:0] in1, in2;
  input addsub;
  output reg [15:0] out;
  always @(*) begin
    if (addsub == 0) out = in1 - in2;
    else out = in1 + in2;
  end
endmodule

module counter (
    data_out,
    decr,
    ldcnt,
    clk
);
  input decr, clk, ldcnt;
  output reg [4:0] data_out;
  always @(posedge clk) begin
    if (ldcnt) data_out <= 5'b10000;
    else if (decr) data_out <= data_out - 1;
  end
endmodule

module dff (
    q0,
    q1,
    clk,
    clr
);
  input q0, clk, clr;
  output reg q1;
  always @(posedge clk) begin
    if (clr) q1 <= 1'b0;
    else q1 <= q0;
  end

endmodule

module booth_controller (
    ldA,
    clrA,
    sftA,
    ldQ,
    clrQ,
    sftQ,
    ldM,
    clrff,
    addsub,
    start,
    decr,
    ldcnt,
    done,
    clk,
    q0,
    qm1,
    eqz
);

  input clk, q0, qm1, start, eqz;
  output reg ldA, clrA, sftA, ldQ, clrQ, sftQ, ldM, clrff, addsub, decr, ldcnt, done;

  reg [2:0] NS, PS;
  parameter S0 = 3'b000,S1 = 3'b001,S2 = 3'b010,S3 = 3'b011,S4 = 3'b100,
            S5 = 3'b101,S6 = 3'b110,S7 = 3'b111;

  // simulation-only power-up state (this design has no reset port)
  initial begin
    PS = S0;
    NS = S0;
  end

  always @(posedge clk) PS <= NS;

  always @(*) begin
    case (PS)
      S0:
      if (start) NS = S1;
      else NS = S0;
      S1: NS = S2;
      S2: NS = S7;  // Q is loaded at the end of S2
      S3: NS = S5;
      S4: NS = S5;
      S5: NS = S7;  // shift done, go and re-check
      S7:
      if (eqz) NS = S6;
      else if ({q0, qm1} == 2'b01) NS = S3;
      else if ({q0, qm1} == 2'b10) NS = S4;
      else NS = S5;
      S6: NS = S6;
      default: NS = S0;
    endcase
  end
  always @(*) begin
    clrA   = 0;
    ldA    = 0;
    sftA   = 0;
    clrQ   = 0;
    ldQ    = 0;
    sftQ   = 0;
    ldM    = 0;
    clrff  = 0;
    addsub = 0;
    decr   = 0;
    ldcnt  = 0;
    done   = 0;
    case (PS)
      S0: begin
        clrA  = 0;
        ldA   = 0;
        sftA  = 0;
        clrQ  = 0;
        ldQ   = 0;
        sftQ  = 0;
        ldM   = 0;
        clrff = 0;
        done  = 0;
      end
      S1: begin
        clrA  = 1;
        clrff = 1;
        ldcnt = 1;
        ldM   = 1;
      end
      S2: begin
        clrA  = 0;
        clrff = 1;  // keep qm1 = 0 while Q is being loaded
        ldcnt = 0;
        ldQ   = 1;
      end
      S3: begin
        ldA = 1;
        addsub = 1;
        ldQ = 0;
        sftA = 0;
        sftQ = 0;
        decr = 0;
      end
      S4: begin
        ldA = 1;
        addsub = 0;
        ldQ = 0;
        sftA = 0;
        sftQ = 0;
        decr = 0;
      end
      S5: begin
        sftA = 1;
        sftQ = 1;
        ldA  = 0;
        ldQ  = 0;
        decr = 1;
      end
      S6: done = 1;
      S7: begin  // check state: no register changes
        ldA  = 0;
        ldQ  = 0;
        sftA = 0;
        sftQ = 0;
        decr = 0;
      end
      default: begin
        clrA = 0;
        sftA = 0;
        ldQ  = 0;
        sftQ = 0;
      end

    endcase
  end
endmodule


