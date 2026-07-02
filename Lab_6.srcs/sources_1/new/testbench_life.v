`timescale 1ns / 1ps

module testbench_life();

    parameter NUM_FRAMES = 3;

    reg clkin, btnL, btnR, touch_hole;
    wire [2:0] q;
    
    life test_lives(
        .clk_i(clkin),
        .btnR_i(btnR),           // resets everything
        .btnL_i(btnL),           // turns on life functionality
        .touch_hole_i(touch_hole),     // lose life if touch hole
        .q_o(q)        // start w 3 lives
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
        
        btnR = 0;
        btnL = 0;
        touch_hole = 0;
        
        #1000
        btnL = 1;
        
        #100
        btnL = 0;
        
        #200
        touch_hole = 1;
        #20
        touch_hole = 0;
        
        #200
        btnR = 1;
        #50
        btnR = 0;
        
        #100
        btnL = 1;
        #100
        btnL = 0;

        #2000;

        $finish;
    end

endmodule

