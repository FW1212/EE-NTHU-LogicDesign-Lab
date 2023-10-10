`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 19:11:07
// Design Name: 
// Module Name: exp_4
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


module exp_4(
    input clk,
    input reset,
    output [7:0] q
    );
    
wire clk_1hz;

fre_divider_50M C0(.clk(clk), .reset(reset), .clk_new(clk_1hz));
DFF U7(.i(q[6]), .clk(clk_1hz), .o(q[7]), .reset(reset));
DFF_r1 U6(.i(q[5]), .clk(clk_1hz), .o(q[6]), .reset(reset));
DFF U5(.i(q[4]), .clk(clk_1hz), .o(q[5]), .reset(reset));
DFF_r1 U4(.i(q[3]), .clk(clk_1hz), .o(q[4]), .reset(reset));
DFF U3(.i(q[2]), .clk(clk_1hz), .o(q[3]), .reset(reset));
DFF_r1 U2(.i(q[1]), .clk(clk_1hz), .o(q[2]), .reset(reset));
DFF U1(.i(q[0]), .clk(clk_1hz), .o(q[1]), .reset(reset));
DFF_r1 U0(.i(q[7]), .clk(clk_1hz), .o(q[0]), .reset(reset));

endmodule
