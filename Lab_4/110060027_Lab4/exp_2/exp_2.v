`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:01:29
// Design Name: 
// Module Name: exp_2
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


module exp_2(
    input clk,
    input reset,
    output [7:0] o
    );

wire clk_1hz;
wire [3:0] b;
    
fre_divider_50M U0(.clk(clk), .clk_new(clk_1hz), .reset(reset));
counter_down U1(.clk(clk_1hz), .reset(reset), .o(b));
ssd U2(.i(b), .D(o));
  
endmodule
