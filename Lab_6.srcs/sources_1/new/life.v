`timescale 1ns / 1ps

// life wont work after reset, stays at 0... 
module life(
    input clk_i,
    input btnR_i,           // resets everything
    input btnL_i,           // turns on life functionality
    input touch_hole_i,     // lose life if touch hole
    output [2:0] q_o        // start w 3 lives
    );
    
    wire [2:0] loser_w;
    
        wire life_latch_d, life_latch_q, reset_latch_w;
        assign life_latch_d = life_latch_q | btnL_i;        // latch when pressed
        
        // FDRE to store state, resets when lose lives
        FDRE #(.INIT(1'b0)) led8_latch (.C(clk_i), .R(btnR_i), .CE(1'b1), .D(life_latch_d), .Q(life_latch_q));
        // assign reset_latch_w = ~q_o[0];
    
    FDRE #(.INIT(1'b1) ) ff2 (
        .C(clk_i), 
        .R(btnR_i), 
        .CE(touch_hole_i), 
        .D(1'b0),					// insert 0 every loss
        .Q(loser_w[2])
    );
    
    FDRE #(.INIT(1'b1) ) ff1 (
        .C(clk_i),
        .R(btnR_i),
        .CE(~loser_w[2] & touch_hole_i),
        .D(1'b0),					// insert 0 if q[2] is 0 and lose
        .Q(loser_w[1])
    );
    
    FDRE #(.INIT(1'b1) ) ff0 (
        .C(clk_i),
        .R(btnR_i),
        .CE(~loser_w[1] & touch_hole_i),
        .D(1'b0),					// insert 0 if q[1] is 0 and lose
        .Q(loser_w[0])
    );
    
	assign q_o[2] = loser_w[2] & life_latch_q;
	assign q_o[1] = loser_w[1] & life_latch_q;
	assign q_o[0] = loser_w[0] & life_latch_q;

endmodule