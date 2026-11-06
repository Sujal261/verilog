primitive udp_carry(cout, a, b, c); 
    input a, b, c; 
    output cout; 
    table 
        0 0 ? : 0; 
        0 ? 0 : 0; 
        0 0 ? : 0; 
        1 1 ? : 0; 
        1 ? 1 : 1; 
        ? 1 1 : 1;
        endtable 
        endprimitive 
primitive udp_sum(sum, a, b, c); 
    input a, b, c; 
    output sum; 
    table 
        0 0 0 : 0; 
        0 0 1 : 1;
        0 1 0 : 1;
        0 1 1 : 0;
        1 0 0 : 1;
        1 0 1 : 0;
        1 1 0 : 0;
        1 1 1 : 1;
        endtable 
        endprimitive

module udpadder(sum,cout,  a, b, c); 
    input a, b, c; 
    output  sum, cout; 
    udp_sum SUM (sum, a, b, c); 
    udp_carry CARRY (cout, a, b, c);

endmodule

