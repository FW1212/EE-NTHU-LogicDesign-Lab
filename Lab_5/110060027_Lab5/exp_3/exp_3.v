`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 16:30:26
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
    input bottom_min,
    input bottom_sec,
    input bottom_start,
    input bottom_pause,
    input mode,
    output [7:0] ssd_out,
    output [3:0] ssd_ctrl,
    output [15:0] led
    );
    
wire clk_1hz, clk_p04hz, decrease_en, bottom_start_debounced, bottom_pause_debounced, bottom_start_op, bottom_pause_op, count_reset;
wire bottom_min_debounced, bottom_sec_debounced, bottom_min_op, bottom_sec_op;
wire [1:0] refresh, loss;
wire br_0, br_1, br_2, br_3;
wire init_br_0, init_br_1, init_br_2, init_br_3;
wire [3:0] init_dig_0, init_dig_1, init_dig_2, init_dig_3;
wire [3:0] digit_0_s, digit_1_s, digit_2_s, digit_3_s, digit_choose;
reg [15:0] led;
reg stop;

fre_divider_50M_en C0(.clk(clk), .reset(reset), .enable(refresh), .clk_new(clk_1hz));
fre_divider_2M_en C1(.clk(clk), .reset(reset), .enable(loss), .clk_new(clk_p04hz));

debounce D0(.reset(reset), .clk(clk_p04hz), .push(bottom_start), .push_debounced(bottom_start_debounced));
debounce D1(.reset(reset), .clk(clk_p04hz), .push(bottom_pause), .push_debounced(bottom_pause_debounced));
OP O0(.reset(reset), .clk(clk_p04hz), .push_op(bottom_start_op), .push_debounced(bottom_start_debounced));
OP O1(.reset(reset), .clk(clk_p04hz), .push_op(bottom_pause_op), .push_debounced(bottom_pause_debounced));
debounce D2(.reset(reset), .clk(clk_p04hz), .push(bottom_min), .push_debounced(bottom_min_debounced));
debounce D3(.reset(reset), .clk(clk_p04hz), .push(bottom_sec), .push_debounced(bottom_sec_debounced));
OP O2(.reset(reset), .clk(clk_p04hz), .push_op(bottom_min_op), .push_debounced(bottom_min_debounced));
OP O3(.reset(reset), .clk(clk_p04hz), .push_op(bottom_sec_op), .push_debounced(bottom_sec_debounced));

FSM F0(.clk(clk_p04hz), .reset(~mode & reset), .count_en(decrease_en), .in_start(bottom_start_op), .in_pause(bottom_pause_op), .count_reset(count_reset));

down_counter D_sec_one(.clk(clk_1hz), .reset(~mode & ~count_reset & reset), .value(digit_0_s), .init_value(init_dig_0), .en(1), .limit(4'd9), .borrow(br_0), .decrease(~stop & decrease_en));
down_counter D_sec_ten(.clk(clk_1hz), .reset(~mode & ~count_reset & reset), .value(digit_1_s), .init_value(init_dig_1), .en(1), .limit(4'd5), .borrow(br_1), .decrease(br_0));
down_counter D_min_one(.clk(clk_1hz), .reset(~mode & ~count_reset & reset), .value(digit_2_s), .init_value(init_dig_2), .en(1), .limit(4'd9), .borrow(br_2), .decrease(br_1));
down_counter D_min_ten(.clk(clk_1hz), .reset(~mode & ~count_reset & reset), .value(digit_3_s), .init_value(init_dig_3), .en(1), .limit(4'd5), .borrow(br_3), .decrease(br_2));
    
up_counter U_sec_one(.clk(bottom_start_op), .reset(reset), .value(init_dig_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(init_br_0), .increase(mode));
up_counter U_sec_ten(.clk(bottom_start_op), .reset(reset), .value(init_dig_1), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(init_br_1), .increase(init_br_0));
up_counter U_min_one(.clk(bottom_pause_op), .reset(reset), .value(init_dig_2), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(init_br_2), .increase(mode));
up_counter U_min_ten(.clk(bottom_pause_op), .reset(reset), .value(init_dig_3), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(init_br_3), .increase(init_br_2));
    
select S0(.a(digit_3_s), .b(digit_2_s), .c(digit_1_s), .d(digit_0_s), .enable(refresh), .o(digit_choose), .ssd_ctrl(ssd_ctrl));

ssd S1(.i(digit_choose), .D(ssd_out));

always @(digit_0_s or digit_1_s or digit_2_s or digit_3_s)
begin
    if(digit_0_s == 4'd0 && digit_1_s == 4'd0 && digit_2_s == 4'd0 && digit_3_s == 4'd0 & ~mode)
    begin
        led <= 16'b1111111111111111;
        stop <= 1;
    end
    else
    begin
        led <= 16'd0;
        stop <= 0;
    end
end

endmodule
