`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 16:46:46
// Design Name: 
// Module Name: exp_1
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


module exp_1(
    input clk,
    input reset,
    output [3:0] b
    );

wire clk_1hz;
   
fre_divider_50M U0(.clk(clk), .clk_new(clk_1hz), .reset(reset));
counter_down U1(.clk(clk_1hz), .reset(reset), .o(b));
    
endmodule
