`timescale 1ns / 1ps

module mod53 (
    input [7:0] value_i,
    output [7:0] remainder_o
);

    // SUB 53
    wire [7:0] val1, val2, val3, val4;
    assign val1 = value_i-8'd53; 
    assign val2 = val1-8'd53;   
    assign val3 = val2-8'd53; 
    assign val4 = val3-8'd53;

    wire mod_0, mod_1, mod_2, mod_3, mod_4; 
    
    assign mod_0 = ~value_i[7] & ~value_i[6];   // less than 64
    assign mod_1 = ~val1[7] & ~val1[6];          //  53-64
    assign mod_2 = ~val2[7] & ~val2[6];
    assign mod_3 = ~val3[7] & ~val3[6]; 
    assign mod_4 = ~val4[7] & ~val4[6];

    wire sel0, sel1, sel2, sel3, sel4; 
    
    assign sel0 = mod_0; 
    assign sel1 = ~mod_0 & mod_1;
    assign sel2 = ~mod_0 & ~mod_1 & mod_2; 
    assign sel3 = ~mod_0 & ~mod_1 & ~mod_2 & mod_3;
    assign sel4 = ~mod_0 & ~mod_1 & ~mod_2 & ~mod_3 & mod_4; 

    assign remainder_o = ({8{sel0}} & value_i) |
        ({8{sel1}} & val1) |
        ({8{sel2}} & val2) | 
        ({8{sel3}} & val3) | 
        ({8{sel4}} & val4);

endmodule
