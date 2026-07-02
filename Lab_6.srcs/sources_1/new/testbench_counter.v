`timescale 1ns / 1ps
module testbench_counter();
    parameter NUM_FRAMES = 3;

    reg clkin, reset_i, up_i, down_i, ld, pixel;
    reg [15:0] din;
    wire [15:0] q;
    wire utc, dtc;
    
    counterUD16L count(
    .din_i(din),         // existing value from 
    .up_i(up_i),                 // increment 0/1
    .dw_i(down_i),
    .ld_i(ld),                 // load 0/1
    .reset_i(reset_i), 
    .clk_i(clkin),
    .utc_o(utc),               // go to led[0]
    .dtc_o(dtc),               // go to led[15
    .q_o(q)           // new count value
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
    din = 16'd360;
    ld = 1;
    down_i = 0;
    up_i = 1;
    reset_i = 0;
    
    
    #20
    ld = 0;
    down_i = 0;
    up_i = 1;
    
    #200
    reset_i = 1;
    
    #20
    reset_i = 0;
    
    end

endmodule



