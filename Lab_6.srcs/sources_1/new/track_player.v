`timescale 1ns / 1ps


module track_player(
    input clk_i,
    input ld_i,
    input up_i,
    input down_i,
    input prevent_hole_i,              // if switch 15 is on
    //output [15:0] x_player_a_o,
    //output [15:0] x_player_b_o,
    output [15:0] y_player_a_o,
    output [15:0] y_player_b_o
    );
    
    wire [15:0] temp_y_b; 
    
    wire startup_latch_d, startup_latch_q, startup_pulse_w, not_startup_w;
    assign startup_latch_d = 1'b1; // starts by latching 1
    
    FDRE #(.INIT(1'b0)) ff_startup (
        .C(clk_i), .R(1'b0), .CE(1'b1), .D(startup_latch_d), .Q(startup_latch_q));
    
    assign not_startup_w = ~startup_latch_q;
    
    

    counterUD16L count_player(
        //.pixels_i(4'd2),
        .din_i(16'd345),                    // player starts 360
        .up_i(down_i & ~prevent_hole_i),        // stop_fall_switch_w),            			// falling
		.dw_i(up_i),							// jumping
		.ld_i(ld_i | not_startup_w),              // ld_pulse | reset_i
        .reset_i(1'b0), 					
        .clk_i(clk_i),                      // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(temp_y_b) 
    );
    
    assign y_player_a_o = (16'd15 + temp_y_b);             // bottom pixel
	assign y_player_b_o = temp_y_b;    // On TOP if pixel 359
	assign x_player_a_o = 16'd200;
	assign x_player_b_o = 16'd215;
    
endmodule
