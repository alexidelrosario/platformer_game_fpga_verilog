`timescale 1ns / 1ps

module testbench_score();
   parameter NUM_FRAMES = 3;

    reg clkin;
    wire [7:0] score;
    reg btnR_w, flash_coin;

    score test_score(
        .clk_i(clkin),
        .btnR_i(btnR_w),
        .flash_coin_i(flash_coin),
        .score_o(score)
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
        flash_coin = 0;
        btnR_w = 0;
        
        #100
        flash_coin = 1;
        #40
        
        flash_coin = 0;

        #20000;

        $finish;
    end

endmodule

