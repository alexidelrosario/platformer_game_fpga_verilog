`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2025 02:59:07 PM
// Design Name: 
// Module Name: edgeDetector
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


module edgeDetector(
    input clk_i,
    input D_i, 
    output Q_o
    );
    
    wire curr_w, prev_w;
    
    // FF with current value
    FDRE #(.INIT(1'b0) ) a_ff_curr (
        .C(clk_i), 
        .R(1'b0), 
        .CE(1'b1), 
        .D(D_i), 
        .Q(curr_w)
    );
    
    // FF with previous value
    FDRE #(.INIT(1'b0) ) a_ff_prev (
        .C(clk_i), 
        .R(1'b0), 
        .CE(1'b1), 
        .D(curr_w), 
        .Q(prev_w)
    );
    
    // EDGEDETECTOR = curr & ~prev
    // 0 -> 1
    assign Q_o = curr_w & ~prev_w;

    
endmodule
