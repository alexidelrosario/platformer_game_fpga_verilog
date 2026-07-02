`timescale 1ns / 1ps

module pixel_address(
    input clk_i,
    input reset_i,
    output [15:0] v_o, 
    output [15:0] h_o,
    output one_frame_o, 
    output half_frame_o, 
    output quarter_frame_o
    );
    
    wire restart_v_w, restart_h_w;       
    //wire inc_v_count_w;
    wire [15:0] count_val_v_w, count_val_h_w;
    
    counterUD16L count_v(
        .din_i(16'b0),                       // start at all 0
        //.pixels_i(4'd1),                // count up by 1
        .up_i(restart_h_w),                // when H reaches end, enable countV
        .dw_i(1'b0),
        .ld_i(reset_i | (restart_v_w & restart_h_w)),
        .reset_i(reset_i | restart_v_w),     // restart when v = 524 or global
        .clk_i(clk_i),                       // 25mHz
        .utc_o(),            
        .dtc_o(),            
        .q_o(count_val_v_w)                  // new count value
    );
    
    counterUD16L count_h(
        .din_i(16'b0),                       // start at all 0
        //.pixels_i(4'd1),
        .up_i(1'b1),                         // always increase H until reset
        .dw_i(1'b0),
        .ld_i(reset_i | restart_h_w),
        .reset_i(reset_i | restart_h_w),     // restart when h = 799 or global reset
        .clk_i(clk_i),
        .utc_o(),         
        .dtc_o(),          
        .q_o(count_val_h_w)                  // new count value
    );    
    
    // reset V when 524
    assign restart_v_w = (count_val_v_w == 16'd524);     // restart V when = 524 (end of all regions)
    
    // reset H at 799
    assign restart_h_w = (count_val_h_w == 16'd799);     // restart H when = 799 
    
    assign one_frame_o = (count_val_h_w == 16'd0) && (count_val_v_w == 16'd523); 
    assign half_frame_o = (count_val_h_w == 16'd0) && (count_val_v_w == 16'd262); 
    assign quarter_frame_o = (count_val_h_w == 16'd0) && (count_val_v_w == 16'd131); 
    
    assign v_o = count_val_v_w;
    assign h_o = count_val_h_w;
    


    
endmodule
