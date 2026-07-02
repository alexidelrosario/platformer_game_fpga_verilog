`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 02:02:11 PM
// Design Name: 
// Module Name: ringCounter
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


// TODO connect clock and digsel from labCnt_clks

module ringCounter(
    input digsel_i,
    input clk_i,
    output [3:0] sel_o
    );
    
    wire [0:0] a3, a2, a1, a0;
    
    assign advance = digsel_i;
    
    FDRE #(.INIT(1'b0) ) a_ff_0 (
    .C(clk_i),      // Clock
    .R(1'b0),       // reset == 0
    .CE(advance),   // Clock Enable == advance
    .D(~a3),        // output from 4th FF inverted
    .Q(a0)
    );
    
    assign sel_o[0] = ~a0;
    
    FDRE #(.INIT(1'b0) ) a_ff_1 (
    .C(clk_i),      // Clock
    .R(1'b0),       // reset == 0
    .CE(advance),   // Clock Enable == advance
    .D(~a0),        // output from 1st FF inverted
    .Q(a1)
    );
    
    assign sel_o[1] = a1;
    
    FDRE #(.INIT(1'b0) ) a_ff_2 (
    .C(clk_i),      // Clock
    .R(1'b0),       // reset == 0
    .CE(advance),   // Clock Enable == advance
    .D(a1),         // output from 2nd FF 
    .Q(a2)      
    );
    
    assign sel_o[2] = a2; 
    
    FDRE #(.INIT(1'b0) ) a_ff_3 (
    .C(clk_i),      // Clock
    .R(1'b0),       // reset == 0
    .CE(advance),   // Clock Enable == advance
    .D(a2),         // output from 3rd FF
    .Q(a3)
    );
    
    assign sel_o[3] = a3;
    
    
endmodule