module tb_mips32; 
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
        DUT.Mem[0] = 32'h2801000a;   
        DUT.Mem[1] = 32'h28020014;   
        DUT.Mem[2] = 32'h28030019;   
        DUT.Mem[3] = 32'h0ce77800;   
        DUT.Mem[4] = 32'h0ce77800;  
        DUT.Mem[5] = 32'h00222000;  
        DUT.Mem[6] = 32'h0ce77800;  
        DUT.Mem[7] = 32'h00832800;   
        DUT.Mem[8] = 32'hfc000000;   

        DUT.HALTED = 0; 
        DUT.PC = 0;
        DUT.TAKEN_BRANCH = 0; 
        #280; 
        for(k =0; k<6; k=k+1) 
            $display("R%1d - %2d", k, DUT.Reg[k]); 
    end
        initial begin
            $dumpfile("mips32.vcd"); 
            $dumpvars(0, tb_mips32);
            $monitor("t=%0t PC=%0d IR=%h HALTED=%b TB=%b R1=%0d Type =%b",
                 $time, DUT.PC, DUT.IF_ID_IR, DUT.HALTED, DUT.TAKEN_BRANCH, DUT.Reg[1], DUT.ID_EX_type);
            #300 $finish;
        end
        
endmodule 
