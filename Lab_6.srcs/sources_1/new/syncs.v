`timescale 1ns / 1ps

module syncs(
    input [15:0] v_i,
    input [15:0] h_i,
    output hsync_o,
    output vsync_o
    );
    
    assign hsync_o = ~((h_i >= 16'd655) & (h_i <= 16'd750)); // hsync is 0 between 655-750
    assign vsync_o = ~((v_i >= 16'd488) & (v_i <= 16'd490)); // vsync is 0 489-490
    
endmodule
