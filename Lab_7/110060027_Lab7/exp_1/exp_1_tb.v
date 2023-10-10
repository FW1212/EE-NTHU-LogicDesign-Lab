`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 15:09:46
// Design Name: 
// Module Name: exp_1_tb
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


module exp_1_tb();

reg reset, clk;
wire mclk, sck, lrck, sdin;
wire [15:0] audio_in_left, audio_in_right;
    
exp_1 U0(.clk(clk), .reset(reset), .audio_lrck(lrck), .audio_mclk(mclk), .audio_sck(sck), .audio_sdin(sdin), .audio_in_left(audio_in_left), .audio_in_right(audio_in_right));
    

initial clk = 0;
always #0.01 clk = ~clk;

initial
begin
$monitor("%d%d%d%d%d%d", mclk, sck, lrck, sdin, audio_in_left, audio_in_right);
 reset = 0;
 #1 reset = 1;
end
    
endmodule
