`timescale 1ns / 1ps

module FSM_player(
    input clk_i,
    input btnU_i,               // JUMP
    input btnR_i,               // reset
    input touch_top_i,
    input touch_hole_i,
    input touch_hell_i,
    input max_jump_i,           // peak of jump
    input dont_fall_i,          // sw[15] no fall in hole
    output up_y_player_o,
    output down_y_player_o,
    output up_y_bar_o,
    output down_y_bar_o,
    output [9:5] led_o      // TEST
    );
    
	// onehot encoding 
	// CS[0] = IDLE
	// CS[1] = BAR CHARGE
	// CS[2] = JUMP / BAR DISCHARGE
	// CS[3] = FALL
	// CS[4] = HELL / END
	
	wire [4:0] cs, ns;
	
	FDRE #(.INIT(1'b1)) ff_0 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[0]), .Q(cs[0]));
	FDRE #(.INIT(1'b0)) ff_1 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[1]), .Q(cs[1]));
	FDRE #(.INIT(1'b0)) ff_2 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[2]), .Q(cs[2]));
	FDRE #(.INIT(1'b0)) ff_3 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[3]), .Q(cs[3]));
	FDRE #(.INIT(1'b0)) ff_4 (.C(clk_i), .R(1'b0), .CE(1'b1), .D(ns[4]), .Q(cs[4]));
	
	// IDLE 0
	assign ns[0] = (cs[4] & btnR_i) | 
	   (cs[0] & ~btnU_i & dont_fall_i) | 							// touch hole while idle SW ON
	   (cs[0] & ~btnU_i & ~touch_hole_i & ~touch_hell_i) |					// stay if no jump or hole
	   (cs[1] & ~btnU_i & touch_hole_i & dont_fall_i) |                				// touch hole while charging SW ON 
	   (cs[3] & touch_top_i & ~touch_hole_i) | 							// fall on ground
	   (cs[3] & (touch_hole_i | touch_top_i) & dont_fall_i);                          // prevent fall if switch on

	
	// CS[1] = BAR CHARGE
	assign ns[1] = (cs[0] & btnU_i & ~dont_fall_i & ~touch_hole_i) | 		// btnU from ground
	   (cs[0] & btnU_i & dont_fall_i) | 
	   (cs[1] & btnU_i & ~touch_hole_i) |					// staying in state if no hole and btnU
	   (cs[1] & btnU_i & dont_fall_i & touch_hole_i);
	   
	// CS[2] = JUMP / BAR DISCHARGE
	assign ns[2] = (cs[1] & ~dont_fall_i & ~btnU_i & ~touch_hole_i) | 	// release btnU
	   (cs[1] & dont_fall_i & ~btnU_i) | 
	   (cs[2] & ~max_jump_i);								// stay as long as not max jump
	   
	// CS[3] = FALL
	assign ns[3] = (cs[2] & max_jump_i) |      				// reached peak of jump
	   (cs[1] & touch_hole_i & ~dont_fall_i) |                				// touch hole while charging
	   (cs[0] & touch_hole_i & ~dont_fall_i) | 							// touch hole while idle 
	   (cs[3] & ~touch_top_i & ~touch_hole_i & ~touch_hell_i) | 	// free fall above top
	   (cs[3] & touch_hole_i & ~touch_hell_i & ~dont_fall_i);              // fall in hole 
	   
	// CS[4] = HELL / END	assign 
	assign ns[4] = (cs[3] & touch_hell_i & ~dont_fall_i) | 
	   ((cs[4] & ~btnR_i));               // stay until reset/restart
	   
	// OUTPUTS
	assign up_y_player_o = cs[2];
    assign down_y_player_o = cs[3];
    assign up_y_bar_o = cs[1];
    assign down_y_bar_o = cs[2];
    // assign player_reset_o = cs[0];
    
    // TEST
    assign led_o[5] = cs[0];
    assign led_o[6] = cs[1];
    assign led_o[7] = cs[2];
    assign led_o[8] = cs[3];
    assign led_o[9] = cs[4];
         
endmodule
