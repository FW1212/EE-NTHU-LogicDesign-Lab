`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:18:25
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
    output [7:0] o_choose,
    output [1:0] ssd_ctrl,
    output [1:0] ssd_ctrl_0
    );
  
wire clk_1hz;
wire clk_10hz;
wire refresh;
wire [3:0] word_front, word_back, word_choose;
    
assign ssd_ctrl_0 = 2'b11;
    
fre_divider_50M_en F0(.clk(clk), .clk_new(clk_1hz), .reset(reset), .enable(refresh));
count_5 F1(.clk(clk_1hz), .clk_new(clk_10hz), .reset(reset));

bcd_count_up C0(.clk(clk_1hz), .reset(reset), .o(word_back));
bcd_count_up C1(.clk(clk_10hz), .reset(reset), .o(word_front));

select S0(.a(word_front), .b(word_back), .enable(refresh), .o(word_choose), .ssd_ctrl(ssd_ctrl));

ssd U0(.i(word_choose), .D(o_choose));
   
endmodule
