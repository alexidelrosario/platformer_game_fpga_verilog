`timescale 1ns / 1ps

module bar_track(
    input clk_i,
    input up_i,
    input down_i,
    input reset_i,
    output [15:0] x_bar_a_o,
    output [15:0] x_bar_b_o,
    output [15:0] y_bar_a_o,
    output [15:0] y_bar_b_o
    );

    wire [15:0] top_bar_w, bottom_bar_w;
    //assign max_bar_w = 16'd37; // 64 pixels
    assign top_bar_w = 16'd36;
    assign bottom_bar_w = 16'd101;
    
    // latch that starts at 1, goes to 0 after it loads 1st value
    wire latch_Q, latch_D;
    assign latch_D = latch_Q & (y_bar_a_o == bottom_bar_w);
    
    FDRE #(.INIT(1'b1)) ff_latch (
        .C(clk_i),
        .R(1'b0),
        .CE(1'b1),
        .D(latch_D),
        .Q(latch_Q)
    );
    
    wire ld_pulse = latch_Q;

    counterUD16L count_bar(
        .din_i(bottom_bar_w),                   
        .up_i(down_i & (y_bar_a_o <= bottom_bar_w)),     // discharge power bar            			
		.dw_i(up_i & (y_bar_a_o > top_bar_w)),		  // charge power bar until max
		.ld_i(ld_pulse | reset_i),
        .reset_i(1'b0), 					
        .clk_i(clk_i),                              // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(y_bar_a_o)          
    );
    
	//assign y_bar_a_o = {1'b0{temp_y_a}};
	assign y_bar_b_o = 16'd100;
	assign x_bar_a_o = 16'd30;
	assign x_bar_b_o = 16'd45;

endmodule