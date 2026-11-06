
module tb_multiplication;

    reg [15:0] data_in = 17;
    reg clk = 0, start = 0, reset = 1;

    wire ldA, ldB, ldP, clrP, decB, eqz, done;

    mul_datapath DUT(
        .ldA(ldA),
        .ldP(ldP),
        .clrP(clrP),
        .ldB(ldB),
        .decB(decB),
        .data_in(data_in),
        .eqz(eqz),
        .clk(clk)
    );

    controller DUT1(
        .ldA(ldA),
        .ldB(ldB),
        .ldP(ldP),
        .clrP(clrP),
        .decB(decB),
        .clk(clk),
        .eqz(eqz),
        .start(start),
        .reset(reset),
        .done(done)
    );

    initial begin
        #12 reset = 0;
        #1 start = 1;
        #10 start = 0;
        #3 data_in = 5;
    end

    always #5 clk = ~clk;

    initial begin
$monitor(
    "Time=%0t | Input=%d | A=%d | B=%d | P=%d | Z=%d | eqz=%b | done=%b",
    $time,
    data_in,
    DUT.X,
    DUT.Bout,
    DUT.Y,
    DUT.Z,
    eqz,
    done
);
        

        $dumpfile("multiplication.vcd");
        $dumpvars(0, tb_multiplication);

        #300 $finish;
    end

endmodule

