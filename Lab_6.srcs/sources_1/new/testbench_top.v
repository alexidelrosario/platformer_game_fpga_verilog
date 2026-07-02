`timescale 1ns / 1ps


module testbench_top();
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
        btnD = 0;
        btnU = 0;
        btnL = 0;
        btnR = 0;
        sw = 0;
        
        
        #2000 
        btnC = 1;
        btnL = 1;
        #50
        btnC = 0;
        btnL = 0;
       
        
        #1000
        
        #50

        #2000;
        

        $finish;
    end

endmodule
