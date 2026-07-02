`timescale 1ns / 1ps

module testbench_hole(); // for pixel_address
   parameter NUM_FRAMES = 3;

    reg clkin;
    reg reset_i, x;
    wire [15:0] xpa, xpb, ypa, ypb;

    hole_track hole(
        .clk_i(clkin),
       // input [4:0] hole_width_i,	// from LFSR
        .x_i(x),
        .reset_i(reset_i),
        .x_hole_a_o(xpa),
        .x_hole_b_o(xpb),
        .y_hole_a_o(ypa), 
        .y_hole_b_o(ypb)
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
        x = 0;
        reset_i = 0;
        #100
        x = 1; 
        #2000

        $finish;
    end

endmodule