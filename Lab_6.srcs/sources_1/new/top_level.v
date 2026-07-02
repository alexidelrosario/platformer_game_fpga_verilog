`timescale 1ns / 1ps

module top_level(
    input clkin,
    input btnC,                 // starts game
    input btnD,                 // load player
    input btnU,                 // JUMP
    input btnL,                 // life option
    input btnR,                 // GLOBAL RESET
    input [15:0] sw,
    output [15:0] led,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync
    );

    wire clk;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    
    wire [15:0] y_address_w, x_address_w;
    pixel_address curr_address(
        .clk_i(clk),
        .reset_i(btnR),
        .v_o(y_address_w), 
        .h_o(x_address_w),
        .one_frame_o(one_frame_w),
        .half_frame_o(half_frame_w),
        .quarter_frame_o(quarter_frame_w)
    );
    
    wire hsync_w, vsync_w;
    
    syncs sync_hv(
        .v_i(y_address_w),
        .h_i(x_address_w),
        .hsync_o(hsync_w),
        .vsync_o(vsync_w)
    );
    
    FDRE #(.INIT(1'b1)) ff_Hsync (.C(clk), .R(btnR), .CE(1'b1), .D(hsync_w), .Q(Hsync));
    FDRE #(.INIT(1'b1)) ff_Vsync (.C(clk), .R(btnR), .CE(1'b1), .D(vsync_w), .Q(Vsync));
   
    wire flash_player_w, timer_4secs_w, flash_coin_w, life_reset_round_w, 
        start_hole_w, start_coin_w, stop_hole_w;
    
    
/////////////////////////////////////////////////// JUMPING LOGIC ///////////////////////////////////////////////////////
    wire [15:0] x_bar_a_w, x_bar_b_w, y_bar_a_w, y_bar_b_w;
        bar_track power_bar(
            .clk_i(clk),
            .up_i(up_y_bar_w & one_frame_w),
            .down_i(down_y_bar_w & one_frame_w),
            .reset_i(btnR),
            .x_bar_a_o(x_bar_a_w),
            .x_bar_b_o(x_bar_b_w),
            .y_bar_a_o(y_bar_a_w),
            .y_bar_b_o(y_bar_b_w)
            );
       
    wire [15:0] bar_height_w = (y_bar_b_w - y_bar_a_w);    // height of power bar
   
    wire btnU_prev;
    FDRE #(.INIT(1'b0)) ff_btnU (
        .C(clk),
        .R(1'b0),
        .CE(1'b1),
        .D(btnU),
        .Q(btnU_prev)  
    );
       
    wire btnU_falling_edge = btnU_prev & ~btnU;
   
    wire [6:0] jump_strength_w;

    FDRE #(.INIT(1'b0)) ff_jump_0 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[0]), .Q(jump_strength_w[0]));
    FDRE #(.INIT(1'b0)) ff_jump_1 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[1]), .Q(jump_strength_w[1]));
    FDRE #(.INIT(1'b0)) ff_jump_2 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[2]), .Q(jump_strength_w[2]));
    FDRE #(.INIT(1'b0)) ff_jump_3 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[3]), .Q(jump_strength_w[3]));
    FDRE #(.INIT(1'b0)) ff_jump_4 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[4]), .Q(jump_strength_w[4]));
    FDRE #(.INIT(1'b0)) ff_jump_5 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[5]), .Q(jump_strength_w[5]));
    FDRE #(.INIT(1'b0)) ff_jump_6 (.C(clk), .R(1'b0), .CE(btnU_falling_edge), .D(bar_height_w[6]), .Q(jump_strength_w[6]));
    
    wire [15:0] x_player_a_w, x_player_b_w, y_player_a_w, y_player_b_w;
    
//    wire stop_fall_switch_w;
//    assign stop_fall_switch_w = (sw[15] & touch_top_w);   
    
    track_player player_address(
        .clk_i(clk),
        .ld_i(life_reset_round_w),        // LOADS base player position (touch top) player_reset_w), 
//        .up_i(btnU),            // JUMP
//        .down_i(btnL),          // FALL
        .up_i(up_y_player_w & (one_frame_w | half_frame_w)),        // JUMP
        .down_i(down_y_player_w & (one_frame_w | half_frame_w)),    // FALL
        .prevent_hole_i(sw[14]),        // prevents all falling
        .y_player_a_o(y_player_a_w),
        .y_player_b_o(y_player_b_w)
    );

////    // test
//    assign y_player_a_w = 16'd190;
//    assign y_player_b_w = 16'd250;
    assign x_player_a_w = 16'd200;
    assign x_player_b_w = 16'd215;
	
    wire [15:0] player_height_w = (16'd360 - y_player_a_w);    // height of player jump
    wire [15:0] double_jump_w;                       
    assign double_jump_w = {8'd0, jump_strength_w, 1'b0};           // player will jump 2x powerbar
    
    wire max_jump_w = (player_height_w == double_jump_w);           // did player reach jump height?

// LATCH for starting coin? 
//    wire start_coin_latch_d, start_coin_latch_q, start_coin_reset_w;
	
	wire [15:0] x_coin_a_w, x_coin_b_w, y_coin_a_w, y_coin_b_w;
//	assign start_coin_latch_d = start_coin_latch_q | start_coin_w;
    
    
    wire start_movement_w;


    wire latch_Q, latch_D;
    assign latch_D = latch_Q | start_movement_w;
    
    FDRE #(.INIT(1'b0)) ff_latch (
        .C(clk),
        .R(1'b0),
        .CE(1'b1),
        .D(latch_D),
        .Q(latch_Q)
    );
    
    wire move_item_w;
    assign move_item_w = latch_Q;
    
	assign coin0_w = (x_coin_b_w == 16'd7);
	coin_track coin_address(
		.clk_i(clk),
		.move_sub_i(move_item_w & (one_frame_w | half_frame_w | quarter_frame_w)), 
		.ld_i(start_movement_w | coin0_w | life_reset_round_w),
		.y_coin_a_o(y_coin_a_w),
		.y_coin_b_o(y_coin_b_w),
		.x_coin_a_o(x_coin_a_w),
		.x_coin_b_o(x_coin_b_w)
    );
    
    // FDRE to store state
//    FDRE #(.INIT(1'b0)) coin_latch (.C(clk), .R(reset_AB_w), .CE(1'b1), .D(start_coin_latch_d), .Q(start_coin_latch_q));
//    assign start_coin_reset_w = (x_coin_a_w == 16'd8);
                
//    assign x_coin_a_w = 16'd30;
//    assign x_coin_b_w = 16'd40;
//    assign y_coin_a_w = 16'd30;
//    assign y_coin_b_w = 16'd40;
    //coin and hole at border
	assign hole0_w = (x_hole_b_w == 16'd0);

	wire [15:0] x_hole_a_w, x_hole_b_w, y_hole_a_w, y_hole_b_w;
	hole_track hole_address(
		.clk_i(clk),
		.move_sub_i(move_item_w & ~stop_hole_w  & one_frame_w),
		.ld_i(start_movement_w | hole0_w | life_reset_round_w),              // load/ restart hole position 
		.x_hole_a_o(x_hole_a_w),
		.x_hole_b_o(x_hole_b_w),
		.y_hole_a_o(y_hole_a_w), 
		.y_hole_b_o(y_hole_b_w)
    );
    
//    assign x_hole_a_w = 16'd20;
//    assign x_hole_b_w = 16'd60;  
//    assign y_hole_a_w = 16'd360;
//	assign y_hole_b_w = 16'd471;

	wire touch_coin_w, touch_hole_w, touch_top_w, touch_hell_w;
    touch touch_stuff(
		.x_player_a_i(x_player_a_w),
		.x_player_b_i(x_player_b_w),
		.y_player_a_i(y_player_a_w),
		.y_player_b_i(y_player_b_w),
		.x_hole_a_i(x_hole_a_w),
		.x_hole_b_i(x_hole_b_w),
		.x_coin_a_i(x_coin_a_w),
		.x_coin_b_i(x_coin_b_w),
		.y_coin_a_i(y_coin_a_w),
		.y_coin_b_i(y_coin_b_w),
		.touch_coin_o(touch_coin_w),
		.touch_hole_o(touch_hole_w),
		.touch_top_o(touch_top_w),
		.touch_hell_o(touch_hell_w)
    );
    //////////////// 
//        wire coin_flash_latch_D, coin_flash_latch_Q;
//        wire reset_coin_latch_w;
        
//        // COIN will stay flashing until coin0 is on
//        assign coin_flash_latch_D = coin_flash_latch_Q | coin0_w;
        
//        FDRE #(.INIT(1'b0)) ff_coin_LATCH (.C(clk), .R(reset_coin_latch_w), .CE(1'b1), .D(coin_flash_latch_D), .Q(coin_flash_latch_Q));
		
	wire [2:0] life_w;
	life track_life(
		.clk_i(clk),
		.btnR_i(btnR),           // resets everything
		.btnL_i(btnL),           // turns on life functionality
		.touch_hole_i(life_reset_round_w),     // lose life if touch hole in active life state
		.q_o(life_w)      		  // start w 3 lives
    );
	
	// TEST
	assign led[13:11] = life_w;
	
    /////////////////////////////////////////// STATE MACHINES ////////////////////////////////////////////////////////////////////////
    wire score_point_w;
    FSM_gameplay gameplay(
        .clk_i(clk),
        .btnR_i(btnR),
        .btnC_i(btnC),
		.life_i(life_w[0]),
		.touch_coin_i(touch_coin_w),
		.touch_hole_i(touch_hole_w),
		.touch_hell_i(touch_hell_w),
		.coin0_i(coin0_w),
		.dont_fall_i(sw[15]),
		.flash_player_o(flash_player_w),
		.flash_coin_o(flash_coin_w),
		.score_point_o(score_point_w),
		.start_movement_o(start_movement_w),
		.life_reset_round_o(life_reset_round_w), // resets player address, hole, coin movements, lose life
		.stop_hole_o(stop_hole_w), 
		.led_o(led[4:0])                          // TEST
    );
	
	wire up_y_player_w, down_y_player_w, up_y_bar_w, down_y_bar_w; // player_reset_w;
	
	FSM_player player_movement(
	    .clk_i(clk),
		.btnU_i(btnU),            // CHARGE BAR to JUMP
		.btnR_i(btnR | life_reset_round_w),            // RESET STATES
		.touch_top_i(touch_top_w),
		.touch_hole_i(touch_hole_w),
		.touch_hell_i(touch_hell_w),
		// .reset_FSM_player_i(reset_FSM_player_w), DONT THINK ITS NEEDED?
        .max_jump_i(max_jump_w),
        .dont_fall_i(sw[15]),
		.up_y_player_o(up_y_player_w),
		.down_y_player_o(down_y_player_w),
		.up_y_bar_o(up_y_bar_w),
		.down_y_bar_o(down_y_bar_w),
		// .player_reset_o(player_reset_w),
		.led_o(led[9:5])                              // TEST
    );
	
    wire [7:0] score_w;
	

	score score_points(
		.clk_i(clk),
		.btnR_i(btnR),
		.flash_coin_i(score_point_w),
		.score_o(score_w)
    );
    
    //assign led[15] = score_w; 

//    assign score_w = 8'd5;
    //////////////////////////////////////////// FLASHING LOGIC ////////////////////////////
    wire [15:0] frame_count_w;    
    wire clear_counter_w = (frame_count_w == 16'd20);
    counterUD16L count_flash(
        .din_i(16'd0),        
        .up_i(one_frame_w & ~clear_counter_w),    
        .dw_i(1'b0),
        .ld_i(clear_counter_w),    
        .reset_i(), 
        .clk_i(clk),
        .utc_o(),  
        .dtc_o(),  
        .q_o(frame_count_w) 
    );
    
    wire count_20_w = (frame_count_w == 16'd20);
        
    wire black_coin_latch_Q, black_coin_latch_D, reset_coin_flash;
    assign black_coin_latch_D = black_coin_latch_Q ^ count_20_w;
    assign reset_coin_flash = ~flash_coin_w;
    
    FDRE #(.INIT(1'b0)) ff_flash_coin (
        .C(clk),
        .R(reset_coin_flash),
        .CE(flash_coin_w & count_20_w),
        .D(black_coin_latch_D),
        .Q(black_coin_latch_Q)
    );
	
	wire blackout_coin_w;
	assign blackout_coin_w = black_coin_latch_Q;
	
	/////////
	wire black_player_latch_Q, black_player_latch_D, reset_player_flash;
    assign black_player_latch_D = black_player_latch_Q ^ count_20_w;
    assign reset_player_flash = ~flash_player_w;
    
    FDRE #(.INIT(1'b0)) ff_flash_player (
        .C(clk),
        .R(reset_player_flash),
        .CE(flash_player_w & count_20_w),
        .D(black_player_latch_D),
        .Q(black_player_latch_Q)
    );
	
	wire blackout_player_w;
	assign blackout_player_w = black_player_latch_Q;
    

    //////////////////////////////////////////// FPGA DISPLAY////////////////////////////////////////////
	assign yellow_coin = ((x_address_w >= x_coin_a_w) & (x_address_w <= x_coin_b_w)) & 
		((y_address_w >= y_coin_a_w) & (y_address_w <= y_coin_b_w));
	assign black_hole = ((x_address_w >= x_hole_a_w) & (x_address_w <= x_hole_b_w)) & 
		((y_address_w >= y_hole_a_w) & (y_address_w <= y_hole_b_w));
	assign player_spot = ((x_address_w >= x_player_a_w) & (x_address_w <= x_player_b_w)) &
		((y_address_w <= y_player_a_w) & (y_address_w >= y_player_b_w));
    assign platform_base = (y_address_w <= 471 & y_address_w >= 381) & (x_address_w > 7 & x_address_w < 632) & ~black_hole;
    assign platform_top = (y_address_w <= 380 & y_address_w >= 361) & (x_address_w > 7 & x_address_w < 632) & ~black_hole;
    
    assign charge_bar = ((x_address_w >= x_bar_a_w) & (x_address_w <= x_bar_b_w)) & 
        ((y_address_w >= y_bar_a_w) & (y_address_w <= y_bar_b_w));
    
    assign border_red = (y_address_w >=0 & y_address_w <= 7) |                  // left border
        (x_address_w >= 0 & x_address_w <= 7) |                                 // TOP border
        (y_address_w >= 472 & y_address_w <= 479) |                             // bottom border
        (x_address_w >= 632 & x_address_w <= 639);                              // right border
    
    assign flash_coin = yellow_coin & ~blackout_coin_w;
    assign flash_player = player_spot & ~blackout_player_w;
    
    // w/o flash
//    assign vgaRed[0] = border_red | yellow_coin | player_spot;
//    assign vgaRed[1] = border_red | yellow_coin | platform_base;
//    assign vgaRed[2] = border_red | yellow_coin;
//    assign vgaRed[3] = border_red | yellow_coin | player_spot;
//    assign vgaGreen[0] = (charge_bar | yellow_coin) & ~border_red;
//    assign vgaGreen[1] = (charge_bar | yellow_coin) & ~border_red;
//    assign vgaGreen[2] = (charge_bar | yellow_coin | platform_base) & ~border_red;
//    assign vgaGreen[3] = (charge_bar | yellow_coin) & ~border_red;
//    assign vgaBlue[0] = platform_top & ~border_red;
//    assign vgaBlue[1] = (platform_top | player_spot) & ~border_red;
//    assign vgaBlue[2] = (platform_top | player_spot | platform_base) & ~border_red;
//    assign vgaBlue[3] = (platform_top | player_spot) & ~border_red;

// NEW FLASH
    assign vgaRed[0] = border_red | flash_coin | flash_player;
    assign vgaRed[1] = border_red | flash_coin | platform_base;
    assign vgaRed[2] = border_red | flash_coin;
    assign vgaRed[3] = border_red | flash_coin | flash_player;
    assign vgaGreen[0] = (charge_bar | flash_coin) & ~border_red;
    assign vgaGreen[1] = (charge_bar | flash_coin) & ~border_red;
    assign vgaGreen[2] = (charge_bar | flash_coin | platform_base) & ~border_red;
    assign vgaGreen[3] = (charge_bar | flash_coin) & ~border_red;
    assign vgaBlue[0] = platform_top & ~border_red;
    assign vgaBlue[1] = (platform_top | flash_player) & ~border_red;
    assign vgaBlue[2] = (platform_top | flash_player | platform_base) & ~border_red;
    assign vgaBlue[3] = (platform_top | flash_player) & ~border_red;
    
    // w/ flashing logic
//    assign vgaRed[0] = border_red | (yellow_coin & blackout_coin_w) | (player_spot & blackout_player_w);
//    assign vgaRed[1] = border_red | (yellow_coin & blackout_coin_w) | platform_base;
//    assign vgaRed[2] = border_red | (yellow_coin & blackout_coin_w);
//    assign vgaRed[3] = border_red | (yellow_coin & blackout_coin_w) | (player_spot & blackout_player_w);
//    assign vgaGreen[0] = (yellow_coin & blackout_coin_w) & ~border_red;
//    assign vgaGreen[1] = (yellow_coin & blackout_coin_w) & ~border_red;
//    assign vgaGreen[2] = ((yellow_coin & blackout_coin_w) | platform_base) & ~border_red;
//    assign vgaGreen[3] = (yellow_coin & blackout_coin_w) & ~border_red;
//    assign vgaBlue[0] = platform_top & ~border_red;
//    assign vgaBlue[1] = (platform_top | (player_spot & blackout_player_w)) & ~border_red;
//    assign vgaBlue[2] = (platform_top | (player_spot & blackout_player_w) | platform_base) & ~border_red;
//    assign vgaBlue[3] = (platform_top | (player_spot & blackout_player_w)) & ~border_red;
    
    //////////////////////////////////////////////// ANODE DISPLAY /////////////////////////////////////////////////
    wire[3:0] ring_out_w, selector_out_w;

    ringCounter ring (
        .digsel_i(digsel),
        .clk_i(clk),
        .sel_o(ring_out_w)
    );
    
    assign an = ~ring_out_w;
    wire [15:0] q_w = {8'b0, score_w};

    selector select (
        .N(q_w),            // from counterUD16L
        .sel(ring_out_w),   // from ringCounter.v
        .H(selector_out_w)
    );
    
    hex7seg hex (
        .n(selector_out_w),  // from selector
        .seg(seg)           // to output
    );

	
endmodule