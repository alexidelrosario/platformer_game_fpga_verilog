`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 05:55:31 PM
// Design Name: 
// Module Name: hex7seg
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

module hex7seg(

    input [3:0] n, // 4bit bus input
    output [6:0] seg // 7bit bus for led segments
    
//    output DP,
//    output AN3,
//    output AN2,
//    output AN1,
//    output AN0
    );
    
    assign val_0 = ~n[3]&~n[2]&~n[1]&~n[0];
    assign val_1 = ~n[3]&~n[2]&~n[1]&n[0];
    assign val_2 = ~n[3]&~n[2]&n[1]&~n[0];
    assign val_3 = ~n[3]&~n[2]&n[1]&n[0];
    assign val_4 = ~n[3]&n[2]&~n[1]&~n[0];
    assign val_5 = ~n[3]&n[2]&~n[1]&n[0];
    assign val_6 = ~n[3]&n[2]&n[1]&~n[0];
    assign val_7 = ~n[3]&n[2]&n[1]&n[0];
    assign val_8 = n[3]&~n[2]&~n[1]&~n[0];
    assign val_9 = n[3]&~n[2]&~n[1]&n[0];
    assign val_A = n[3]&~n[2]&n[1]&~n[0];
    assign val_B = n[3]&~n[2]&n[1]&n[0];
    assign val_C = n[3]&n[2]&~n[1]&~n[0];
    assign val_D = n[3]&n[2]&~n[1]&n[0];
    assign val_E = n[3]&n[2]&n[1]&~n[0];
    assign val_F = n[3]&n[2]&n[1]&n[0];
    
    assign seg[0] = val_1 | val_4 | val_B | val_D;
    assign seg[1] = val_5 | val_6 | val_B | val_C | val_E | val_F;
    assign seg[2] = val_2 | val_C | val_E | val_F;
    assign seg[3] = val_1 | val_4 | val_7 | val_9 | val_A | val_F;
    assign seg[4] = val_1 | val_3 | val_4 | val_5 | val_7 | val_9;
    assign seg[5] = val_1 | val_2 | val_3 | val_7 | val_D;
    assign seg[6] = val_0 | val_1 | val_7 | val_C;
    
//    assign AN3 = 1;
//    assign AN2 = 1;
//    assign AN1 = 1;
//    assign AN0 = 0;
    
    
endmodule