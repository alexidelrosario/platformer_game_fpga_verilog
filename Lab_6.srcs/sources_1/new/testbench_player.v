`timescale 1ns / 1ps
module testbench_player();
 
    parameter NUM_FRAMES = 3;

    reg clkin, reset_i, up_i, down_i, ld_i;
    wire [15:0] xpa, xpb, ypa, ypb;

        
    track_player player(
        .clk_i(clkin),
        .up_i(up_i),
        .down_i(down_i),
        .ld_i(ld_i),
       // .reset_i(reset_i),
//        .x_player_a_o(xpa),
//        .x_player_b_o(xpb),
        .y_player_a_o(ypa),
        .y_player_b_o(ypb)
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
    #50
    up_i = 0;
    down_i = 0;
    ld_i = 0;
    #50 
    ld_i = 1;
    
    #50
    ld_i = 0;
    
    #100
    up_i = 1;
    #200
    up_i = 0;
    
    #50 
    down_i = 1;
    #200 
    down_i = 0;
  
    end

endmodule
