`timescale 1ns / 1ps

module testbench(); // for pixel_address
   parameter NUM_FRAMES = 3;

    reg clkin;
    wire [9:5] led_w;
    reg btnU_w, btnR_w, touch_top_w, touch_hole_w, touch_hell_w, max_jump_w, reset_FSM_player_w;
    wire up_y_player_w, down_y_player_w, up_y_bar_w, down_y_bar_w, player_reset_w;

    FSM_player play(
        .clk_i(clkin),
        .btnU_i(btnU_w),
        .btnR_i(btnR_w),
        .touch_top_i(touch_top_w),
        .touch_hole_i(touch_hole_w),
        .touch_hell_i(touch_hell_w),
        .max_jump_i(max_jump_w),
        .reset_FSM_player_i(reset_FSM_player_w),
        .up_y_player_o(up_y_player_w),
        .down_y_player_o(down_y_player_w),
        .up_y_bar_o(up_y_bar_w),
        .down_y_bar_o(down_y_bar_w),
        .player_reset_o(player_reset_w),
        .led_o(led_w)      // TEST
    );
   // Generate Basys3 clock
   parameter PERIOD = 10;
   parameter real DUTY_CYCLE = 0.5;
   parameter OFFSET = 2;
   initial
   begin
      clkin = 1'b0;
      #OFFSET
      clkin = 1'b1;
      forever
      begin
         #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
      end
   end

    initial begin
        btnU_w = 0;
        btnR_w = 0;
        touch_top_w = 1;
        touch_hell_w = 0;
        reset_FSM_player_w = 0;
        # 500
        btnU_w = 1;
        # 500 
        #50


        #20000;

        $finish;
    end

endmodule
