`timescale 1ns / 1ps

module hole_track(
    input clk_i,
    input move_sub_i,          // move hole (sub x address)
    // maybe when x goes high, load switch off the lfsr ?
    input ld_i,         // indicate when to LOAD starting x address 
    output [15:0] x_hole_a_o,
    output [15:0] x_hole_b_o,
	output [15:0] y_hole_a_o, 
	output [15:0] y_hole_b_o
    );
    
    //////////////////////////////////// LFSR //////////////////////////////////////////
	wire [4:0] hole_width_w;
	lfsr hole_width(
        .clk_i(clk_i),
        .reset_i(1'b0),
        .q_o(hole_width_w)  // 5 bits, so max width to add is 31
    );
    
        // latch that starts at 1, goes to 0 after it loads 1st value IT WORKS********* not sure if necessary
    wire latch_Q, latch_D;
    assign latch_D = latch_Q & (x_hole_a_o == 16'd631);
    
    FDRE #(.INIT(1'b1)) ff_latch (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(latch_D),
        .Q(latch_Q)
    );
    
    wire ed_ld_pulse;
    
    // detect when load is done, keeps curr random width
    edgeDetector ed_load_hole(
        .clk_i(clk_i),
        .D_i(latch_Q), 
        .Q_o(ed_ld_pulse)
    );
    
    // so random number doesnt keep changing 
    wire change_width_w;
	wire [4:0] latch_width_w;
    
    // update when xA is at address 8 (binary 0000_0000_0000_1000)
    assign change_width_w = ed_ld_pulse | (x_hole_a_o == 16'd8) | ld_i;

    FDRE #(.INIT(1'b0)) ff_latch_w0 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_width_w),
        .D(hole_width_w[0]),
        .Q(latch_width_w[0])
    );
    
    FDRE #(.INIT(1'b0)) ff_latch_w1 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_width_w),
        .D(hole_width_w[1]),
        .Q(latch_width_w[1])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w2 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_width_w),
        .D(hole_width_w[2]),
        .Q(latch_width_w[2])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w3 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_width_w),
        .D(hole_width_w[3]),
        .Q(latch_width_w[3])
    );
    
        FDRE #(.INIT(1'b0)) ff_latch_w4 (
        .C(clk_i),
        .R(1'b0),
        .CE(change_width_w),
        .D(hole_width_w[4]),
        .Q(latch_width_w[4])
    );
    
    //////////////////////////////////// CONTINUE //////////////////////////////////////

    
    // HOLE WIDTH
	wire [15:0] real_hole_width_w, x_midpt_w;                        // becomes 16 bits after addition
	assign real_hole_width_w = 15'd41 + latch_width_w;  // 41 + random within 31 = max 71
	
	assign y_hole_a_o = 16'd360;
	assign y_hole_b_o = 16'd471;
	
    
    // LEFT SIDE OF HOLE
    counterUD16L count_hole_a(
        .din_i(16'd632),                    // start left side hole at right border (pixel 632)
        .up_i(1'b0),            			// no increasing size, just reset
		.dw_i(move_sub_i & (x_hole_a_o > 16'd0)),							// something will say to sub and stop at 0
        .reset_i(1'b0), 					// RESET when told by FSM Gameplay
        .ld_i(ed_ld_pulse | ld_i),              // ld_pulse | reset_i),
        .clk_i(clk_i),                      // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(x_hole_a_o)                 // new left side of hole
    );
    assign x_midpt_w = 16'd673 + real_hole_width_w;

	counterUD16L count_hole_midpt(
        .din_i(x_midpt_w),                    // start left side hole at right border (pixel 632)
        .up_i(1'b0),            			// no increasing size, just reset
		.dw_i(move_sub_i),							// something will say to sub
        .reset_i(1'b0), 					// RESET when told by FSM Gameplay
        .ld_i(ed_ld_pulse | ld_i),              // ld_pulse | reset_i),
        .clk_i(clk_i),                      // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(x_hole_b_o)                 // new left side of hole
    );
    
endmodule
