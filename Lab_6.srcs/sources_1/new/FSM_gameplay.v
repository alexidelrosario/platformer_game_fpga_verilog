`timescale 1ns / 1ps

module FSM_gameplay(
    input clk_i,
    input btnR_i,
    input btnC_i,
    input life_i,
    input touch_coin_i,
    input touch_hole_i,
    input touch_hell_i,
    input coin0_i,
    input dont_fall_i,          // sw[15] no fall in hole
    // input hole0_i,
    output flash_player_o,
    output flash_coin_o,
    output score_point_o,
    output life_reset_round_o, 		// resets player address, hole, coin movements, lose life
    output start_movement_o,
	// reset_FSM_player_o,
    // output start_hole_o,
    // output start_coin_o,
    output stop_hole_o, 
    output [4:0] led_o
    );
	
	wire [5:0] cs, ns;
	
	// onehot encoding 
	// CS[0] = IDLE
	// CS[1] = COIN
	// CS[2] = HOLE
	// CS[3] = HELL
	// CS[4] = SAVED
	
	FDRE #(.INIT(1'b0)) ff_0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[0]), .Q(cs[0]));
	FDRE #(.INIT(1'b0)) ff_1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[1]), .Q(cs[1]));
	FDRE #(.INIT(1'b0)) ff_2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[2]), .Q(cs[2]));
	FDRE #(.INIT(1'b0)) ff_3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[3]), .Q(cs[3]));
	FDRE #(.INIT(1'b0)) ff_4 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[4]), .Q(cs[4]));
    FDRE #(.INIT(1'b1)) ff_5 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[5]), .Q(cs[5]));

    assign ns[5] = (cs[5] & ~btnC_i);
    
	// IDLE
	assign ns[0] = 
	    (cs[0] & (~touch_hole_i & ~touch_coin_i) )| 	// stay if no touchy
		(cs[4] & life_i) | 		// restart round if have lives
		(cs[0] & dont_fall_i & touch_hole_i & ~touch_coin_i) | 
		(cs[1] & dont_fall_i& coin0_i) | 
		(cs[1] & ~dont_fall_i & ~touch_hole_i & coin0_i) | 
		(cs[5] & btnC_i);
	
	// COIN 
	assign ns[1] = 
	    (cs[0] & touch_coin_i) | 
		//(cs[0] & dont_fall_i & touch_coin_i & ~coin0_i) |
		(cs[1] & dont_fall_i & ~coin0_i) | 
		(cs[1] & ~touch_hole_i & ~touch_hell_i & ~coin0_i);
	
	// HOLE
	assign ns[2] = 
	    (cs[0] & touch_hole_i & ~dont_fall_i) | 	// touch hole in game
		(cs[1] & touch_hole_i & ~dont_fall_i) |					// touch coin then hole
		(cs[2] & ~touch_hell_i);
		
	// HELL
	assign ns[3] = (cs[2] & touch_hell_i) | 	
		(cs[3] & ~life_i) | 
		(cs[3] & life_i & ~coin0_i);
		
	// SAVED
	assign ns[4] = (cs[3] & life_i & coin0_i);	// reset everything if life on

	/////////////////////////////////////////// OUTPUTS ///////////////////////////////////////////////

		assign flash_coin_o = cs[1];
		
		// losing outputs	
		assign flash_player_o = cs[2] | cs[3];
		assign stop_hole_o = cs[2] | cs[3];
		
		// assign reset_FSM_player_o = cs[0];
		assign life_reset_round_o = cs[4];
		
		assign start_movement_o = cs[5] & btnC_i;
		assign score_point_o = cs[1] & coin0_i;

		
		assign led_o[0] = cs[0];
		assign led_o[1] = cs[1];
		assign led_o[2] = cs[2];
		assign led_o[3] = cs[3];
		assign led_o[4] = cs[4];
		
endmodule
			