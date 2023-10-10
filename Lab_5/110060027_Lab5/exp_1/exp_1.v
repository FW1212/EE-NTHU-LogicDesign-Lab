`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 17:30:33
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
    input bottom_reset,
    input bottom,
    output [7:0] ssd_out,
    output [3:0] ssd_ctrl,
    output [15:0] led,
    output led16
    );
    
wire clk_1hz, clk_p04hz, decrease_en, bottom_reset_debounced, bottom_debounced, bottom_reset_op, bottom_op;
wire refresh, br_0, br_1, loss;
wire [3:0] digit_0, digit_1, digit_choose;
reg [14:0] led;
reg stop;

fre_divider_50M_en C0(.clk(clk), .reset(reset), .enable(refresh), .clk_new(clk_1hz));
fre_divider_2M_en C1(.clk(clk), .reset(reset), .enable(loss), .clk_new(clk_p04hz));

debounce D0(.reset(reset), .clk(clk_p04hz), .push(bottom_reset), .push_debounced(bottom_reset_debounced));
debounce D1(.reset(reset), .clk(clk_p04hz), .push(bottom), .push_debounced(bottom_debounced));
OP O0(.reset(reset), .clk(clk_p04hz), .push_op(bottom_reset_op), .push_debounced(bottom_reset_debounced));
OP O1(.reset(reset), .clk(clk_p04hz), .push_op(bottom_op), .push_debounced(bottom_debounced));

FSM F0(.clk(clk_p04hz), .reset(~stop & ~bottom_reset_op), .count_en(decrease_en), .in(bottom_op));

num_counter N_one(.clk(clk_1hz), .reset(~bottom_reset_op & reset), .value(digit_0), .init_value(4'd0), .en(1), .limit(4'd9), .borrow(br_0), .decrease(decrease_en));
num_counter N_ten(.clk(clk_1hz), .reset(~bottom_reset_op & reset), .value(digit_1), .init_value(4'd4), .en(1), .limit(4'd0), .borrow(br_1), .decrease(br_0));
    
select S0(.a(digit_0), .b(digit_1), .enable(refresh), .o(digit_choose), .ssd_ctrl(ssd_ctrl));

ssd S1(.i(digit_choose), .D(ssd_out));

assign led16 = decrease_en;

always @(digit_0 or digit_1)
begin
    if(digit_0 == 4'd0 && digit_1 == 4'd0)
    begin
        led <= 15'b111111111111111;
        stop <= 1;
    end
    else
    begin
        led <= 15'd0;
        stop <= 0;
    end
end
   
endmodule
