`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 14:05:32
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
    input bottom_stop,
    input bottom_lap,
    output [7:0] ssd_out,
    output [3:0] ssd_ctrl
    );
    
wire clk_1hz, clk_p04hz, increase_en, bottom_stop_debounced, bottom_lap_debounced, bottom_stop_op, bottom_lap_op, freeze_en, count_reset;
wire [1:0] refresh, loss;
wire br_0, br_1, br_2, br_3;
wire [3:0] digit_0, digit_1, digit_2, digit_3, digit_choose;
wire [3:0] digit_0_s, digit_1_s, digit_2_s, digit_3_s;

fre_divider_50M_en C0(.clk(clk), .reset(reset), .enable(refresh), .clk_new(clk_1hz));
fre_divider_2M_en C1(.clk(clk), .reset(reset), .enable(loss), .clk_new(clk_p04hz));

debounce D0(.reset(reset), .clk(clk_p04hz), .push(bottom_stop), .push_debounced(bottom_stop_debounced));
debounce D1(.reset(reset), .clk(clk_p04hz), .push(bottom_lap), .push_debounced(bottom_lap_debounced));
OP O0(.reset(reset), .clk(clk_p04hz), .push_op(bottom_stop_op), .push_debounced(bottom_stop_debounced));
OP O1(.reset(reset), .clk(clk_p04hz), .push_op(bottom_lap_op), .push_debounced(bottom_lap_debounced));

FSM F0(.clk(clk_p04hz), .reset(reset), .count_en(increase_en), .in_stop(bottom_stop_op), .in_lap(bottom_lap_op), .in_lap_debounced(bottom_lap_debounced), .freeze_en(freeze_en), .count_reset(count_reset));

num_counter N_sec_one(.clk(clk_1hz), .reset(~count_reset & reset), .value(digit_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(br_0), .increase(increase_en));
num_counter N_sec_ten(.clk(clk_1hz), .reset(~count_reset & reset), .value(digit_1), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(br_1), .increase(br_0));
num_counter N_min_one(.clk(clk_1hz), .reset(~count_reset & reset), .value(digit_2), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(br_2), .increase(br_1));
num_counter N_min_ten(.clk(clk_1hz), .reset(~count_reset & reset), .value(digit_3), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(br_3), .increase(br_2));
    
SMUX SMUX0(.clk(clk), .reset(reset), .i(digit_0), .o(digit_0_s), .freeze_en(freeze_en));
SMUX SMUX1(.clk(clk), .reset(reset), .i(digit_1), .o(digit_1_s), .freeze_en(freeze_en));
SMUX SMUX2(.clk(clk), .reset(reset), .i(digit_2), .o(digit_2_s), .freeze_en(freeze_en));
SMUX SMUX3(.clk(clk), .reset(reset), .i(digit_3), .o(digit_3_s), .freeze_en(freeze_en));
    
select S0(.a(digit_3_s), .b(digit_2_s), .c(digit_1_s), .d(digit_0_s), .enable(refresh), .o(digit_choose), .ssd_ctrl(ssd_ctrl));

ssd S1(.i(digit_choose), .D(ssd_out));

endmodule
