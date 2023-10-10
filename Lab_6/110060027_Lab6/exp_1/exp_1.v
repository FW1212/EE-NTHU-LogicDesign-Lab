`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 13:57:38
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
    input buttom_left,
    input buttom_mid,
    input buttom_right,
    input clk,
    input reset,
    input switch_alarm,
    input switch_mode_left,
    input switch_mode_right,
    output stw_work,
    output [7:0] led_alarm,
    output [3:0] ssd_ctrl,
    output [7:0] ssd_out,
    output [2:0] led_display,
    output [3:0] led_set
    );
    
wire [1:0] refresh;
wire [4:0] state;
wire [3:0] final_digit_choose, final_dig_0, final_dig_1, final_dig_2, final_dig_3;
wire clk_1hz, clk_10000hz, clk_100hz;
wire bl_debounced, bl_op;
wire bm_debounced, bm_op;
wire br_debounced, br_op;
wire sl_turn_up, sl_turn_down;
wire sr_turn_up, sr_turn_down;
wire stw_count_en, stw_br_0, stw_br_1, stw_br_2, stw_br_3, stw_reset, stw_freeze;
wire [3:0] stw_dig_0, stw_dig_1, stw_dig_2, stw_dig_3, stw_final_dig_0, stw_final_dig_1, stw_final_dig_2, stw_final_dig_3;
wire [3:0] alarm_dig_0, alarm_dig_1, alarm_dig_2, alarm_dig_3;
wire alarm_br_0, alarm_br_1, alarm_br_2;
wire [3:0] sec_0, sec_1, min_0, min_1, hr_0, hr_1, month_0, month_1, year_0, year_1;
wire [3:0] day_0, day_1;
wire sec_br_0, sec_br_1, min_br_0, min_br_1, hr_br, day_br, month_br, year_br_0, year_br_1; 
wire set_mode, big_year;
reg [7:0] led_alarm;
wire [3:0] day_limit_0, day_limit_1;

// 除頻器
fre_divider_50M_en C0(.clk(clk), .reset(reset), .clk_new(clk_1hz), .enable(refresh));
fre_divider_500K C1(.clk(clk), .reset(reset), .clk_new(clk_100hz));
fre_divider_5M C2(.clk(clk), .reset(reset), .clk_new(clk_10000hz));

// debounce and one-paulse
debounce D0(.clk(clk_100hz), .reset(reset), .push(buttom_left), .push_debounced(bl_debounced));
OP OP0(.clk(clk_100hz), .reset(reset), .push_debounced(bl_debounced), .push_op(bl_op));
debounce D1(.clk(clk_100hz), .reset(reset), .push(buttom_mid), .push_debounced(bm_debounced));
OP OP1(.clk(clk_100hz), .reset(reset), .push_debounced(bm_debounced), .push_op(bm_op));
debounce D2(.clk(clk_100hz), .reset(reset), .push(buttom_right), .push_debounced(br_debounced));
OP OP2(.clk(clk_100hz), .reset(reset), .push_debounced(br_debounced), .push_op(br_op));

switch_op S0(.clk(clk_100hz), .reset(reset), .switch(switch_mode_left), .turn_up(sl_turn_up), .turn_down(sl_turn_down));
switch_op S1(.clk(clk_100hz), .reset(reset), .switch(switch_mode_right), .turn_up(sr_turn_up), .turn_down(sr_turn_down));
    
// FSM
FSM F0(.reset(reset), .clk(clk_100hz), .sl_turn_up(sl_turn_up), .sl_turn_down(sl_turn_down), .sr_turn_up(sr_turn_up), .sr_turn_down(sr_turn_down),
        .bl_debounced(bl_debounced), .bm_debounced(bm_debounced), .bl_op(bl_op), .br_op(br_op), .bm_op(bm_op), .state(state),
        .stw_count_en(stw_count_en), .stw_freeze(stw_freeze), .stw_reset(stw_reset));

// stopwatch function    
stw_counter stw_sec_one(.clk(clk_1hz), .reset(~stw_reset & reset), .value(stw_dig_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(stw_br_0), .increase(stw_count_en));
stw_counter stw_sec_ten(.clk(clk_1hz), .reset(~stw_reset & reset), .value(stw_dig_1), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(stw_br_1), .increase(stw_br_0));
stw_counter stw_min_one(.clk(clk_1hz), .reset(~stw_reset & reset), .value(stw_dig_2), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(stw_br_2), .increase(stw_br_1));
stw_counter stw_min_ten(.clk(clk_1hz), .reset(~stw_reset & reset), .value(stw_dig_3), .init_value(4'd0), .en(1), .limit(4'd5), .borrow(stw_br_3), .increase(stw_br_2));
    
stw_freeze_ctrl stw_f_0(.clk(clk), .reset(reset), .i(stw_dig_0), .o(stw_final_dig_0), .freeze_en(stw_freeze));
stw_freeze_ctrl stw_f_1(.clk(clk), .reset(reset), .i(stw_dig_1), .o(stw_final_dig_1), .freeze_en(stw_freeze));
stw_freeze_ctrl stw_f_2(.clk(clk), .reset(reset), .i(stw_dig_2), .o(stw_final_dig_2), .freeze_en(stw_freeze));
stw_freeze_ctrl stw_f_3(.clk(clk), .reset(reset), .i(stw_dig_3), .o(stw_final_dig_3), .freeze_en(stw_freeze));

// 最終輸出選擇
select_5to1 select0(.state(state), .a(month_0), .b(hr_0), .c(sec_0), .stw(stw_final_dig_0), .alarm(alarm_dig_0), .o(final_dig_0));
select_5to1 select1(.state(state), .a(month_1), .b(hr_1), .c(sec_1), .stw(stw_final_dig_1), .alarm(alarm_dig_1), .o(final_dig_1));
select_5to1 select2(.state(state), .a(year_0), .b(day_0_final), .c(min_0), .stw(stw_final_dig_2), .alarm(alarm_dig_2), .o(final_dig_2));
select_5to1 select3(.state(state), .a(year_1), .b(day_1_final), .c(min_1), .stw(stw_final_dig_3), .alarm(alarm_dig_3), .o(final_dig_3));

// alarm function
alarm_counter alarm_min_one(.clk(br_op), .reset(reset), .value(alarm_dig_0), .init_value(4'd1), .en(state[3] & ~state[2] & ~state[1]), .limit(4'd9), .borrow(alarm_br_0), .increase(1));
alarm_counter alarm_min_ten(.clk(br_op), .reset(reset), .value(alarm_dig_1), .init_value(4'd3), .en(state[3] & ~state[2] & ~state[1]), .limit(4'd5), .borrow(alarm_br_1), .increase(alarm_br_0));

oddlimit_two_digit_up_counter alarm_hr(.clk(bl_op), .reset(reset), .en(state[3] & ~state[2] & ~state[1]), .increase(1),
    .init_value_one(4'd7), .total_limit_one(4'd4), .value_one(alarm_dig_2), .br_finish_one(4'd0),
    .init_value_ten(4'd1), .total_limit_ten(4'd2), .value_ten(alarm_dig_3), .br_finish_ten(4'd0), .total_borrow(alarm_br_2));

// display and set function
normal_limit_counter sec_one(.clk((state[3] & state[2] & ~state[1] & br_op)|(~set_mode & clk_1hz)), .reset(reset), .value(sec_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(sec_br_0), .increase(1));
normal_limit_counter sec_ten(.clk((state[3] & state[2] & ~state[1] & br_op)|(~set_mode & clk_1hz)), .reset(reset), .value(sec_1), .init_value(4'd3), .en(1), .limit(4'd5), .borrow(sec_br_1), .increase(sec_br_0));

normal_limit_counter min_one(.clk((state[3] & state[2] & ~state[1] & bl_op)|(~set_mode & clk_1hz)), .reset(reset), .value(min_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(min_br_0), .increase((state[3] & state[2] & ~state[1])|(~set_mode & sec_br_1)));
normal_limit_counter min_ten(.clk((state[3] & state[2] & ~state[1] & bl_op)|(~set_mode & clk_1hz)), .reset(reset), .value(min_1), .init_value(4'd3), .en(1), .limit(4'd5), .borrow(min_br_1), .increase(min_br_0));

oddlimit_two_digit_up_counter hr(.clk((state[3] & state[2] & state[1] & br_op)|(~set_mode & clk_1hz)), .reset(reset), .en(1), .increase((state[3] & state[2] & state[1])|(~set_mode & min_br_1)),
    .init_value_one(4'd7), .total_limit_one(4'd4), .value_one(hr_0), .br_finish_one(4'd0),
    .init_value_ten(4'd1), .total_limit_ten(4'd2), .value_ten(hr_1), .br_finish_ten(4'd0), .total_borrow(hr_br));

oddlimit_two_digit_up_counter day(.clk((state[3] & state[2] & state[1] & bl_op)|(~set_mode & clk_1hz)), .reset(reset), .en(1), .increase((state[3] & state[2] & state[1])|(~set_mode & hr_br)),
    .init_value_one(4'd7), .total_limit_one(day_limit_0), .value_one(day_0), .br_finish_one(4'd1),
    .init_value_ten(4'd0), .total_limit_ten(day_limit_1), .value_ten(day_1), .br_finish_ten(4'd0), .total_borrow(day_br));

oddlimit_two_digit_up_counter month(.clk((state[3] & ~state[2] & state[1] & br_op)|(~set_mode & clk_1hz)), .reset(reset), .en(1), .increase((state[3] & ~state[2] & state[1])|(~set_mode & day_br)),
    .init_value_one(4'd4), .total_limit_one(4'd3), .value_one(month_0), .br_finish_one(4'd1),
    .init_value_ten(4'd0), .total_limit_ten(4'd1), .value_ten(month_1), .br_finish_ten(4'd0), .total_borrow(month_br));
    
normal_limit_counter year_one(.clk((state[3] & ~state[2] & state[1] & bl_op)|(~set_mode & clk_1hz)), .reset(reset), .value(year_0), .init_value(4'd2), .en(1), .limit(4'd9), .borrow(year_br_0), .increase((state[3] & ~state[2] & state[1])|(~set_mode & month_br)));
normal_limit_counter year_ten(.clk((state[3] & ~state[2] & state[1] & bl_op)|(~set_mode & clk_1hz)), .reset(reset), .value(year_1), .init_value(4'd2), .en(1), .limit(4'd9), .borrow(year_br_1), .increase(year_br_0));

// ssd display
ssd_refresh SSD0(.a(final_dig_3), .b(final_dig_2), .c(final_dig_1), .d(final_dig_0), .enable(refresh), .o(final_digit_choose), .ssd_ctrl(ssd_ctrl));

SSD SSD1(.i(final_digit_choose), .D(ssd_out));

// 閏年閏月判斷
big_year BIG(.year_0(year_0), .year_1(year_1), .big_year(big_year));
how_many_day H0(.month_0(month_0), .month_1(month_1), .day_0(day_limit_0), .day_1(day_limit_1), .big_year(big_year));

// LED control
assign stw_work = state[4];
assign set_mode = ~state[4] & state[3];
assign led_display[0] = (~state[4] & ~state[3] & ~state[2] & ~state[1]) | state[0];
assign led_display[1] = (~state[4] & ~state[3] & ~state[2] & state[1]) | state[0];
assign led_display[2] = (~state[4] & ~state[3] & state[2] & ~state[1]) | state[0];
assign led_set[0] = ~state[4] & state[3] & ~state[2] & ~state[1];
assign led_set[1] = ~state[4] & state[3] & ~state[2] & state[1];
assign led_set[2] = ~state[4] & state[3] & state[2] & state[1];
assign led_set[3] = ~state[4] & state[3] & state[2] & ~state[1];

always @(min_0 or min_1 or hr_0 or hr_1 or alarm_dig_0 or alarm_dig_1 or alarm_dig_2 or alarm_dig_3 or switch_alarm or state)
begin
    if (min_0 == alarm_dig_0 && min_1 == alarm_dig_1 && hr_0 == alarm_dig_2 && hr_1 == alarm_dig_3 && switch_alarm && ~state[4])
        led_alarm <= 8'b11111111;
    else
        led_alarm <= 8'd0;
end

// 閏月除錯
reg [3:0] day_0_final, day_1_final;
reg [3:0] day_0_next, day_1_next;

always @(day_0 or day_1 or month_0 or month_1)
begin
    if(day_0 == 4'd0 && day_1 == 4'd3 && month_0 == 4'd2 && month_1 == 4'd0)
    begin
        day_0_next <= 4'd1;
        day_1_next <= 4'd0;
    end
    else
    begin
        day_0_next <= day_0;
        day_1_next <= day_1;
    end
end

always @(posedge clk)
begin
    day_0_final <= day_0_next;
    day_1_final <= day_1_next;
end
    
endmodule
