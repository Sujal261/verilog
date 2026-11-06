module tb_mips32_factorial; 
    reg clk1, clk2; 
    integer k; 
    pipe_mips32 DUT(clk1, clk2); 

    initial begin
        clk1 = 0; 
        clk2 = 0; 
        repeat (20) begin
            #5 clk1 = 1; 
            #5 clk1 = 0; 
            #5 clk2 = 1; 
            #5 clk2 = 0;
        end
    end

    initial begin

        for(k =0; k<31; k=k+1) 
            DUT.Reg[k] = k; 
    DUT.Mem[0]  = 32'h280a00c8;  // ADDI R10, R0, 200
    DUT.Mem[1]  = 32'h28020001;  // ADDI R2, R0, 1
    DUT.Mem[2]  = 32'h0e94a000;  // OR R20,R20,R20 -- dummy instr.
    DUT.Mem[3]  = 32'h21430000;  // LW R3, 0(R10)
    DUT.Mem[4]  = 32'h0e94a000;  // OR R20,R20,R20 -- dummy instr.
    DUT.Mem[5]  = 32'h14431000;  // Loop: MUL R2, R2, R3
    DUT.Mem[6]  = 32'h2c630001;  // SUBI R3, R3, 1
    DUT.Mem[7]  = 32'h0e94a000;  // OR R20,R20,R20 -- dummy instr.
    DUT.Mem[8]  = 32'h3460fffc;  // BNEQZ R3, Loop (offset -4)
    DUT.Mem[9]  = 32'h2542fffe;  // SW R2, -2(R10)
    DUT.Mem[10] = 32'hfc000000;  // HLT
    DUT.Mem[200] = 7;

    DUT.PC = 0; 
    DUT.HALTED = 0; 
    DUT.TAKEN_BRANCH= 0; 
    #2000; 
    $display("Mem[200] = %2d, Mem[198] = %6d", DUT.Mem[200], DUT.Mem[198]); 
    
    end

    initial begin
        $dumpfile("mips2.vcd"); 
        $dumpvars(0, tb_mips32_factorial); 
        $monitor("R2: %4d", DUT.Reg[2]); 
        #3000 $finish;
    end
endmodule







