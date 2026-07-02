`timescale 1ns / 1ps

module coin_track(
	input clk_i,
    input move_sub_i,		// tell me to decrease/move coin
    input ld_i,
    output [15:0] y_coin_a_o,
    output [15:0] y_coin_b_o,
    output [15:0] x_coin_a_o,
    output [15:0] x_coin_b_o
    );
		
    //////////////////////////////////// LFSR //////////////////////////////////////////
	wire [7:0] coin_height_w;
	lfsr coin_height(
        .clk_i(clk_i),
        .reset_i(1'b0),     // turn off for randomness
        .q_o(coin_height_w)  // 8 bits, so max height is 255 need to mod 53
    );
    

	// latch that starts at 1, goes to 0 after it loads 1st value
    wire latch_Q, latch_D;
    assign latch_D = latch_Q & (x_coin_a_o == 16'd632);
    
    FDRE #(.INIT(1'b1)) ff_latch (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(latch_D),
        .Q(latch_Q)
    );
    
    wire ed_ld_pulse;
    
    // detect when load is done, keeps curr random width
    edgeDetector ed_load_coin(
        .clk_i(clk_i),
        .D_i(latch_Q),
        .Q_o(ed_ld_pulse)
    );
    
    // so random number doesnt keep changing 
    wire change_height_w;
	wire [7:0] latch_height_w;
    
   // update when xA is at address 8 (binary 0000_0000_0000_1000)
    assign change_height_w = ed_ld_pulse | (x_coin_b_o == 16'd7) | ld_i; 

    FDRE #(.INIT(1'b0)) ff_latch_w0 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[0]),
        .Q(latch_height_w[0])
    );
    
    FDRE #(.INIT(1'b0)) ff_latch_w1 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[1]),
        .Q(latch_height_w[1])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w2 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[2]),
        .Q(latch_height_w[2])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w3 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[3]),
        .Q(latch_height_w[3])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w4 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[4]),
        .Q(latch_height_w[4])
    );
	        FDRE #(.INIT(1'b0)) ff_latch_w5 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[5]),
        .Q(latch_height_w[5])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w6 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[6]),
        .Q(latch_height_w[6])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w7 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_height_w),
        .D(coin_height_w[7]),
        .Q(latch_height_w[7])
    );
    
    /////////////////////////////////////////////// MOD //////////////////////////////////////////////////
	wire [7:0] mod_coin_height_w;
	mod53 mod(
        .value_i(latch_height_w),
        .remainder_o(mod_coin_height_w)
    ); 
    
	//////////////////////////////////// CONTINUE //////////////////////////////////////

    // coin new height
	assign y_coin_a_o = 8'd192 + mod_coin_height_w; // pixel 192 + random num, max 252 pixel
	assign y_coin_b_o = 8'd199 + mod_coin_height_w;	// added 7 pixels for coin height


    counterUD16L count_hole_xa(
        .din_i(16'd632),                    // start left side hole at right border (pixel 631)
        .up_i(1'b0),            			// no increasing size, just reset
		.dw_i(move_sub_i & (x_coin_a_o > 16'd0)),				// one frame per decrease
        .reset_i(1'b0), 					
        .ld_i(ed_ld_pulse | ld_i),          // reset loads starting value
        .clk_i(clk_i),                      // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(x_coin_a_o)                    // new left side of hole
    );

    counterUD16L count_hole_xb(
        .din_i(16'd639),                    // start left side hole at right border (pixel 631)
        .up_i(1'b0),            			// no increasing size, just reset
		.dw_i(move_sub_i),				// one frame per decrease
        .reset_i(1'b0), 					
        .ld_i(ed_ld_pulse | ld_i),          // reset loads starting value
        .clk_i(clk_i),                      // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(x_coin_b_o)                    // new left side of hole
    );
    
endmodule
