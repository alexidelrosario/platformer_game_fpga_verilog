`timescale 1ns / 1ps

module touch(
    input [15:0] x_player_a_i,
    input [15:0] x_player_b_i,
    input [15:0] y_player_a_i,
    input [15:0] y_player_b_i,
    input [15:0] x_hole_a_i,
    input [15:0] x_hole_b_i,
    input [15:0] x_coin_a_i,
    input [15:0] x_coin_b_i,
    input [15:0] y_coin_a_i,
    input [15:0] y_coin_b_i,
    output touch_coin_o,
    output touch_hole_o,
    output touch_top_o,
    output touch_hell_o
    );
    
	// touch TOP
	wire [15:0] y_top_w; 
	assign y_top_w = 16'd360;
    assign touch_top_o = (y_player_a_i == y_top_w);
	
	// touch HOLE
	wire [15:0] x_touch_hole_w;
	assign x_touch_hole_w = (x_player_b_i <= x_hole_b_i) & (x_player_a_i >= x_hole_a_i);
	assign touch_hole_o = (y_player_a_i >= y_top_w) &  x_touch_hole_w;
	
	// touch HELL
	wire [15:0] y_hell_w;
	assign y_hell_w = 16'd471;
	assign touch_hell_o = (y_player_a_i == y_hell_w) | (y_player_a_i == 16'd470);
	
	// touch COIN
	wire y_touch_coin_a_w, x_touch_coin_a_w;
	wire y_touch_coin_b_w, x_touch_coin_b_w;
	assign x_touch_coin_a_w = (x_coin_a_i >= x_player_a_i) & (x_coin_a_i <= x_player_b_i);
	assign x_touch_coin_b_w = (x_coin_b_i >= x_player_a_i) & (x_coin_b_i <= x_player_b_i);
	assign y_touch_coin_a_w = (y_coin_a_i <= y_player_a_i) & (y_coin_a_i >= y_player_b_i);	
	assign y_touch_coin_b_w = (y_coin_b_i <= y_player_a_i) & (y_coin_b_i >= y_player_b_i);	
	assign touch_coin_o = (x_touch_coin_a_w | x_touch_coin_b_w) & (y_touch_coin_a_w | y_touch_coin_b_w);
	
endmodule