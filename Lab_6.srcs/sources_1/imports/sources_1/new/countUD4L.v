`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 02:01:28 PM
// Design Name: 
// Module Name: countUD4L
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


module countUD4L(
    input clk_i,        // clock
    input up_i,         // increment
    input dw_i,         // decrement 
	input reset_i,
    input ld_i,         // load control
    input [3:0] din_i,  // 4bit vector din thats loaded on the clock edge if LD is high
    output [3:0] q_o,   // current value held by counter
    output utc_o,       // up terminal count == 1 when countUD4L = 1'b1111 = 15
    output dtc_o        // down terminal count == 1 when countUD4L = 4'b0000 = 0
    );
    
    wire [3:0] mux_out_w;       // mux output
    wire [3:0] add_sub_out_w;   // addSub8 output
    wire [3:0] q_w;
    
    // clock enable FF if one is active
    wire ce_w = (up_i & ~dw_i) | (dw_i & ~up_i) | ld_i;
    
    wire sub = ~up_i & dw_i;  // 1 if decrement/DW
    
    assign q_w = q_o;
    
    addSub8 inc_dec (
        .A(q_w),          // current counter val
        .B(4'b0001),        // add or sub 1
        //.B(pixels_i),       // 1, 2 or 4
        .sub(sub),          // 1 if subtracting
        .S(add_sub_out_w)   // new value
    );
//    mux4bit load(
//        .ld(ld_i), // load
//        .i0(din_i),
//        .i1(add_sub_out_w), 
//        .y(mux_out_w)
//    );
    assign mux_out_w[0] = (ld_i & din_i[0]) | (~ld_i & add_sub_out_w[0]);
    assign mux_out_w[1] = (ld_i & din_i[1]) | (~ld_i & add_sub_out_w[1]);
    assign mux_out_w[2] = (ld_i & din_i[2]) | (~ld_i & add_sub_out_w[2]);
    assign mux_out_w[3] = (ld_i & din_i[3]) | (~ld_i & add_sub_out_w[3]);


    // assign mux_out_w = (~ld & q_o) | (ld & din_i);  
    
    FDRE #(.INIT(1'b0) ) a_ff_0 (
        .C(clk_i),          // Clock
        .R(reset_i),           // reset == 0
        .CE(ce_w),          // Clock Enable?
        .D(mux_out_w[0]),        
        .Q(q_o[0])
   );
   
   FDRE #(.INIT(1'b0) ) a_ff_1 (
        .C(clk_i),          // Clock
        .R(reset_i),           // reset == 0
        .CE(ce_w),          // Clock Enable?
        .D(mux_out_w[1]),        
        .Q(q_o[1])
   );
   
   FDRE #(.INIT(1'b0) ) a_ff_2 (
        .C(clk_i),          // Clock
        .R(reset_i),           // reset == 0
        .CE(ce_w),          // Clock Enable?
        .D(mux_out_w[2]),        
        .Q(q_o[2])
   );
   
   FDRE #(.INIT(1'b0) ) a_ff_3 (
        .C(clk_i),          // Clock
        .R(reset_i),           // reset == 0
        .CE(ce_w),          // Clock Enable?
        .D(mux_out_w[3]),        
        .Q(q_o[3])
   );
   
   assign utc_o = q_o[0] & q_o[1] & q_o[2] & q_o[3];
   assign dtc_o = ~q_o[0] & ~q_o[1] & ~q_o[2] & ~q_o[3];
 
endmodule
