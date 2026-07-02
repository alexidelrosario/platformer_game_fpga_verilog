`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 8 bit adder
//////////////////////////////////////////////////////////////////////////////////


 module adder8(
    input [3:0] a, // 8bit inputs
    input [3:0] b,
    input cin, // carry in
    output [3:0] s,
    output ovfl, // need?
    output cout
    );
    
    wire [4:0] c9; // carryout for each bit and to overflow

    assign c9[0] = cin;
    
   // starting at least significant bit
    assign s[0] = a[0] ^ b[0] ^ c9[0]; // xor sets up the output bits
    assign c9[1] = (a[0] & b[0]) | (a[0] & c9[0]) | (b[0] & c9[0]); // carryout for adder
    
    assign s[1] = a[1] ^ b[1] ^ c9[1];
    assign c9[2] = (a[1] & b[1]) | (a[1] & c9[1]) | (b[1] & c9[1]);
        
    assign s[2] = a[2] ^ b[2] ^ c9[2];
    assign c9[3] = (a[2] & b[2]) | (a[2] & c9[2]) | (b[2] & c9[2]);
    
	assign s[3] = a[3] ^ b[3] ^ c9[3];
    assign c9[4] = (a[3] & b[3]) | (a[3] & c9[3]) | (b[3] & c9[3]);
    
    assign cout = c9[4]; // unsigned overflow
    
    // Out of bounds [-8, 7]
    // neg + neg = positive or pos + pos = negative
    assign ovfl = (a[3] & b[3] & ~s[3]) | (~a[3] & ~b[3] & s[3]); 

endmodule