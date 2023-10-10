`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:08:42
// Design Name: 
// Module Name: exp_3
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


module exp_3(
    input clk,
    input reset,
    output [7:0] o
    );
    
wire clk_0p5hz;
wire [3:0] b;
    
fre_divider_100M U0(.clk(clk), .clk_new(clk_0p5hz), .reset(reset));
bcd_count_down U1(.clk(clk_0p5hz), .reset(reset), .o(b));
ssd U2(.i(b), .D(o));

endmodule
