`timescale 1ns / 1ps

module score(
    input clk_i,
    input btnR_i,
    //input four_secs_i,
    input flash_coin_i,
    output [7:0] score_o
    );
        
//    wire startup_latch_d, startup_latch_q, not_startup_w;
//    assign startup_latch_d = 1'b1; // starts by latching 1
    
//    FDRE #(.INIT(1'b0)) ff_startup (
//        .C(clk_i), .R(1'b0), .CE(1'b1), .D(startup_latch_d), .Q(startup_latch_q));
    
//    assign not_startup_w = ~startup_latch_q;
    
    wire [15:0] temp_score_w;
   
    
    counterUD16L count_score(
        .din_i(16'd0),         // existing value from sw
        .up_i(flash_coin_i),                 // increment 0/1
        .dw_i(1'b0),
        .ld_i(btnR_i), //| not_startup_w),                 // load 0/1
        .reset_i(1'b0), 
        .clk_i(clk_i),
        .utc_o(),               // go to led[0]
        .dtc_o(),               // go to led[15]
        .q_o(temp_score_w)           // new count value
    );
    
    assign score_o = temp_score_w[7:0];
    
endmodule
