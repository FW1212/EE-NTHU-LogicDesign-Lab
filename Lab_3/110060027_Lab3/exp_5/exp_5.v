`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/14 18:04:24
// Design Name: 
// Module Name: exp_5
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


module exp_5(
    input clk,
    input reset,
    output [7:0] final_output,
    output [3:0] ctrl
    );
    
wire [7:0] line_12, line_23, line_34, line_45, line_56, line_67, line_78, line_89, line_91;
wire [1:0] refresh;
wire clk_1hz, clk_10Khz;
    
fre_divider_50M C0(.clk(clk), .reset(reset), .clk_new(clk_1hz));
fre_divider_5K C1(.clk(clk), .reset(reset), .clk_new(clk_10Khz));

DFF_n D1(.clk(clk_1hz), .reset(reset), .i(line_12), .o(line_91));
DFF_t D2(.clk(clk_1hz), .reset(reset), .i(line_23), .o(line_12));
DFF_h D3(.clk(clk_1hz), .reset(reset), .i(line_34), .o(line_23));
DFF_u D4(.clk(clk_1hz), .reset(reset), .i(line_45), .o(line_34));
DFF_space D5(.clk(clk_1hz), .reset(reset), .i(line_56), .o(line_45));
DFF_e D6(.clk(clk_1hz), .reset(reset), .i(line_67), .o(line_56));
DFF_e D7(.clk(clk_1hz), .reset(reset), .i(line_78), .o(line_67));
DFF_c D8(.clk(clk_1hz), .reset(reset), .i(line_89), .o(line_78));
DFF_s D9(.clk(clk_1hz), .reset(reset), .i(line_91), .o(line_89));

count_4 CNT0(.clk(clk_10Khz), .reset(reset), .o(refresh));

select_4_to_1 S0(.select(refresh), .o(final_output), .a(line_91), .b(line_12), .c(line_23), .d(line_34));

enable E0(.select(refresh), .o(ctrl));
    
endmodule
