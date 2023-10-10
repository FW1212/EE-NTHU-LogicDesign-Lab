`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/06 21:49:01
// Design Name: 
// Module Name: prelab_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module prelab_tb();

reg CLK, RST_N, IN;
wire STATE;
wire [3:0] DC0, DC1;

prelab U0(.clk(CLK), .reset(RST_N), .bottom(IN), .bottom_reset(0), .digit_0(DC0), .digit_1(DC1), .led16(STATE));

initial CLK = 0;
always #5 CLK = ~CLK;

initial
begin
$monitor("%d%d", DC1, DC0);
 RST_N = 0; IN = 0;
 #10 RST_N = 1; IN = 1;
 #50 RST_N = 0; IN = 0;
 #30 RST_N = 1;
 #10 IN = 1;
 #20 IN = 0;
 #60 IN = 1;
 #20 IN = 0;
 #100 IN = 1;
 #20 IN = 0;
end

endmodule
