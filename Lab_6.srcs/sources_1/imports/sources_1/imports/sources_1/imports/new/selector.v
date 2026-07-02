`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 06:10:51 PM
// Design Name: 
// Module Name: selector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module selector(
    input [15:0] N,
    input [3:0] sel,
    output [3:0] H
    );
    
//    assign one = ~sel[3]*~sel[2]*~sel[1]*sel[0];
//    assign two = ~sel[3]*~sel[2]*sel[1]*~sel[0];
//    assign four = ~sel[3]*sel[2]*~sel[1]*~sel[0];
//    assign eight = sel[3]*~sel[2]*~sel[1]*~sel[0];
    
//    assign N[15:12] = eight;
//    assign N[11:8] = four;
//    assign N[7:4] = two;
//    assign N[3:0] = one;
    
//    assign H = 
    
    // H[i] will take the value of whichever select is high
    assign H[0] = (sel[0] & N[0]) | (sel[1] & N[4]) | (sel[2] & N[8]) | (sel[3] & N[12]);
    assign H[1] = (sel[0] & N[1]) | (sel[1] & N[5]) | (sel[2] & N[9]) | (sel[3] & N[13]);
    assign H[2] = (sel[0] & N[2]) | (sel[1] & N[6]) | (sel[2] & N[10]) | (sel[3] & N[14]);
    assign H[3] = (sel[0] & N[3]) | (sel[1] & N[7]) | (sel[2] & N[11]) | (sel[3] & N[15]);

//    // H[i] will take the value of whichever select is high
//    assign H[0] = (sel[3] & N[0]) | (sel[2] & N[4]) | (sel[1] & N[8]) | (sel[0] & N[12]);
//    assign H[1] = (sel[3] & N[1]) | (sel[2] & N[5]) | (sel[1] & N[9]) | (sel[0] & N[13]);
//    assign H[2] = (sel[3] & N[2]) | (sel[2] & N[6]) | (sel[1] & N[10]) | (sel[0] & N[14]);
//    assign H[3] = (sel[3] & N[3]) | (sel[2] & N[7]) | (sel[1] & N[11]) | (sel[0] & N[15]);

    
endmodule