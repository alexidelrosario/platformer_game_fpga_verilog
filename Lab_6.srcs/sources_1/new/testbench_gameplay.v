`timescale 1ns / 1ps

module testbench_gameplay();
    

    parameter NUM_FRAMES = 3;

    reg clkin, btnC, btnD, btnU, btnL, btnR;
    reg [15:0] sw;
    wire [15:0] led;
    wire [3:0] an, vgaRed, vgaGreen, vgaBlue;
    wire [6:0] seg;
    wire Hsync, Vsync;
    
    top_level top(
        .clkin(clkin),
        .btnC(btnC),
        .btnD(btnD),
        .btnU(btnU),
        .btnL(btnL), 
        .btnR(btnR), 
        .sw(sw),
        .led(led), // outs
        .an(an),
        .seg(seg),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .Hsync(Hsync),
        .Vsync(Vsync)
    );
        FSM_gameplay game(
        .clk_i(clkin),
        .btnR_i(btnR),
        .life_i(life),
        .touch_coin_i(touch_coin),
        .touch_hole_i(touch_hole),
        .touch_hell_i,
        .coin0_i,
        .dont_fall_i,          // sw[15] no fall in hole
        .flash_player_o,
        .flash_coin_o,
        .life_reset_round_o, 		// resets player address, hole, coin movements, lose life
        .stop_hole_o, 
        .led_o
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
        btnC = 0;
        btnD = 1;
        btnU = 0;
        btnL = 0;
        btnR = 0;
        
        
        #2000 
        btnC = 1;
        #50
        btnC = 0;
        
        btnU = 1;
        
        #300
        btnU = 0;
        
        #2000;
        btnU = 1;
        
        #3000;
        btnU = 0;
        
        #1000
        
        #50

        #2000;
        

        $finish;
    end

endmodule

