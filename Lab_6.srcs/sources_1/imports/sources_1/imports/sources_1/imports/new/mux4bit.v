`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2025 05:23:37 PM
// Design Name: 
// Module Name: mux4bit
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


module mux4bit(
    input ld, // load
    input i0,
    input i1, 
    output y
    );
    assign y = (~ld & i0) | (ld & i1);
endmodule

