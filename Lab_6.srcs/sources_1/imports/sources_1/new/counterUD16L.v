`timescale 1ns / 1ps

module counterUD16L(
    input [15:0] din_i,         // existing value from sw
    input up_i,                 // increment 0/1
    input dw_i,
    input ld_i,                 // load 0/1
    input reset_i, 
    input clk_i,
    output utc_o,               // go to led[0]
    output dtc_o,               // go to led[15]
    output [15:0] q_o           // new count value
    );
    
    wire [3:0] utc_w, dtc_w;
    
    countUD4L count_0 (
        .clk_i(clk_i),          // standard for all
        .up_i(up_i),            // add
        .dw_i(dw_i),            // sub
        .ld_i(ld_i),            // standard for all
        .reset_i(reset_i),
        .din_i(din_i[3:0]),     // first 4 bits
        .q_o(q_o[3:0]),         // new 4 bits
        .utc_o(utc_w[0]),       // wire to NEXT UP
        .dtc_o(dtc_w[0])        // wire to NEXT DW
    );
    
    countUD4L count_1 (
        .clk_i(clk_i),          // standard for all
        .up_i(utc_w[0] & up_i),        // from count_0 and btnU/C
        .dw_i(dtc_w[0] & dw_i),            // sub
        .ld_i(ld_i),            // standard for all
        .reset_i(reset_i),
        .din_i(din_i[7:4]),     // second 4 bits
        .q_o(q_o[7:4]),         // new 4 bits
        .utc_o(utc_w[1]),       // wire to NEXT UP
        .dtc_o(dtc_w[1])        // wire to NEXT DW
    );
    
    countUD4L count_2 (
        .clk_i(clk_i),          // standard for all
        .up_i(utc_w[1] & utc_w[0] & up_i),        // from all prev
        .dw_i(dtc_w[1] & dtc_w[0] & dw_i),        // from all prev
        .ld_i(ld_i),            // standard for all
        .reset_i(reset_i),
        .din_i(din_i[11:8]),    // third 4 bits
        .q_o(q_o[11:8]),        // new 4 bits
        .utc_o(utc_w[2]),       // wire to NEXT UP
        .dtc_o(dtc_w[2])        // wire to NEXT DW
    );
    
    countUD4L count_3 (
        .clk_i(clk_i),          // standard for all
        .up_i(utc_w[2] & utc_w[1] & utc_w[0] & up_i),        // from all prev
        .dw_i(dtc_w[2] & dtc_w[1] & dtc_w[0] & dw_i),        // from all prev
        .ld_i(ld_i),            // standard for all
        .reset_i(reset_i),
        .din_i(din_i[15:12]),   // last 4 bits
        .q_o(q_o[15:12]),       // new 4 bits
        .utc_o(utc_w[3]),       // wire to NEXT UP
        .dtc_o(dtc_w[3])        // wire to NEXT DW
    );
    
    assign utc_o = utc_w[3];
    assign dtc_o = dtc_w[3];
    
endmodule
