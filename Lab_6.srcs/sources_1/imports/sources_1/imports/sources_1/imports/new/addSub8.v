`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////


module addSub8(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] S
    // output ovfl // dont need
    );
    
    wire [3:0] B_mod; 
    wire cout;
    
    // xor b with sub so if sub 0, then B. if sub 1, then ~B
    assign B_mod = B ^ {4{sub}};
    
    adder8 addition(
        .a(A),
        .b(B_mod),
        .cin(sub),
        .s(S),
        .cout(cout)
        // .ovfl(ovfl) // dont need
    );

endmodule