`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 16:40:40
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
    inout ps2_data,
    inout ps2_clk,
    input reset,
    input clk,
    output [3:0]ssd_ctrl,
    output [7:0]ssd_out
    );
    
wire clk_1hz;
wire [1:0] refresh;
fre_divider_50M_en CLK0(.clk(clk), .clk_new(clk_1hz), .reset(reset), .enable(refresh));
    
wire [511:0] key_down;
wire [8:0]last_change;
wire key_valid;
wire valid_singal, state;
KeyboardDecoder K0(.key_down(key_down), .last_change(last_change), .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), .rst(~reset), .clk(clk));
assign valid_singal = key_down[last_change];

wire [3:0] dig_0, dig_1, dig_2, dig_3;
wire state;
FSM FSM(.clk(valid_singal), .reset(reset), .last_change(last_change), .state(state));

key_choose C0(.reset(reset), .enable(~state), .clk(clk), .last_change(last_change), .result(dig_0));
key_choose C1(.reset(reset), .enable(state), .clk(clk), .last_change(last_change), .result(dig_1));

dec_adder adder0(.cout(dig_2), .sum(dig_3), .num_0(dig_0), .num_1(dig_1), .clk(clk), .rst(reset));

wire [3:0] dig_choose;
select S0(.a(dig_0), .b(dig_1), .c(dig_2), .d(dig_3), .o(dig_choose), .ssd_ctrl(ssd_ctrl), .enable(refresh));
SSD SSD(.i(dig_choose), .D(ssd_out));

endmodule
