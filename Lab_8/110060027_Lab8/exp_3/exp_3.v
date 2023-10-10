`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 21:46:21
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
    inout ps2_data,
    inout ps2_clk,
    input reset,
    input clk,
    output [3:0] ssd_ctrl,
    output [7:0] ssd_out
    );
    
wire clk_1hz, clk_100hz;
wire [1:0] refresh;
fre_divider_50M_en CLK0(.clk(clk), .clk_new(clk_1hz), .reset(reset), .enable(refresh));
fre_divider_500K(.clk(clk), .clk_new(clk_100hz), .reset(reset));
    
wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
wire valid_singal;
KeyboardDecoder K0(.key_down(key_down), .last_change(last_change), .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), .rst(~reset), .clk(clk));
assign valid_singal = key_down[last_change];

// wire op;
// delay_op OP(.clk(clk_100hz), .reset(reset), .in(valid_singal), .out(op));
    
/*
wire [3:0] decode_result;
key_choose K1(.result(decode_result), .last_change(last_change), .clk(clk), .reset(reset));
*/
wire [2:0] state;
wire [1:0] intro;
FSM FSM(.intro(intro), .clk(valid_singal), .state(state), .reset(reset), .last_change(last_change));

wire [3:0] dig_0, dig_1, dig_2, dig_3;
// value_temp_reg V0(.digit_0(dig_0), .digit_1(dig_1), .digit_2(dig_2), .digit_3(dig_3), .state_sel(state), .valid(valid_signal), .decoded_input(decode_result), .rst(reset));
key_choose C0(.reset(reset), .enable(~state[2] & ~state[1] & ~state[0]), .clk(valid_singal), .last_change(last_change), .result(dig_3));
key_choose C1(.reset(reset), .enable(~state[2] & ~state[1] & state[0]), .clk(valid_singal), .last_change(last_change), .result(dig_2));
key_choose C2(.reset(reset), .enable(~state[2] & state[1] & state[0]), .clk(valid_singal), .last_change(last_change), .result(dig_1));
key_choose C3(.reset(reset), .enable(state[2] & ~state[1] & ~state[0]), .clk(valid_singal), .last_change(last_change), .result(dig_0));


// 加法
wire [3:0] add_digit_2, add_digit_1, add_digit_0;
dec_adder D0(.cout(add_digit_2), .num_0(dig_3), .num_1(dig_2), .num_2(dig_1), .num_3(dig_0), .digit_0_out(add_digit_0), .digit_1_out(add_digit_1));

// 減法
wire [3:0] subtract_digit_1, subtract_digit_0;
wire [6:0] value_0, value_1;
dec_substractor D1(.num_0(dig_0), .num_1(dig_1), .num_2(dig_2), .num_3(dig_3), .digit_0_out(subtract_digit_0), .digit_1_out(subtract_digit_1), .value_0(value_0), .value_1(value_1));

// 乘法
wire [3:0] multiply_digit_3, multiply_digit_2, multiply_digit_1, multiply_digit_0;
dec_multiplier D2(.num_0(dig_0), .num_1(dig_1), .num_2(dig_2), .num_3(dig_3), .digit_0_out(multiply_digit_0), .digit_1_out(multiply_digit_1), .digit_2_out(multiply_digit_2), .digit_3_out(multiply_digit_3));



reg [3:0] display_tmp_3, display_tmp_2, display_tmp_1, display_tmp_0;
    always @*
        if (state == 3'd6 && intro == 2'd0)
            begin
                display_tmp_3 = 4'd0;
                display_tmp_2 = add_digit_2;
                display_tmp_1 = add_digit_1;
                display_tmp_0 = add_digit_0;
            end
        else if (state == 3'd6 && intro == 2'd1 && (value_1 >= value_0))
            begin
                display_tmp_3 = 4'd0;
                display_tmp_2 = 4'd0;
                display_tmp_1 = subtract_digit_1;
                display_tmp_0 = subtract_digit_0;
            end
        else if (state == 3'd6 && intro == 2'd1 && (value_1 < value_0))
            begin
                display_tmp_3 = 4'd10;
                display_tmp_2 = 4'd0; //negative
                display_tmp_1 = subtract_digit_1;
                display_tmp_0 = subtract_digit_0;
            end
        else if (state == 3'd6 && intro == 2'd2)
            begin
                display_tmp_3 = multiply_digit_3;
                display_tmp_2 = multiply_digit_2;
                display_tmp_1 = multiply_digit_1;
                display_tmp_0 = multiply_digit_0;
            end
            
        else if (state == 3'd5)
            begin
                display_tmp_3 = dig_3;
                display_tmp_2 = dig_2;
                display_tmp_1 = dig_1;
                display_tmp_0 = dig_0;
            end
        
        else if (state == 3'd4)
            begin
                display_tmp_3 = 4'd15;
                display_tmp_2 = dig_3;
                display_tmp_1 = dig_2;
                display_tmp_0 = dig_1;
            end
        else if (state == 3'd3)
            begin
                display_tmp_3 = 4'd15;
                display_tmp_2 = 4'd15;
                display_tmp_1 = dig_3;
                display_tmp_0 = dig_2;
            end
        else if (state == 3'd2)
            begin
                display_tmp_3 = 4'd15;
                display_tmp_2 = 4'd15;
                display_tmp_1 = dig_3;
                display_tmp_0 = dig_2;
            end
        else if (state == 3'd1)
            begin
                display_tmp_3 = 4'd15;
                display_tmp_2 = 4'd15;
                display_tmp_1 = 4'd15;
                display_tmp_0 = dig_3;
            end
            
        else
            begin
                display_tmp_3 = 4'd15;
                display_tmp_2 = 4'd15;
                display_tmp_1 = 4'd15;
                display_tmp_0 = 4'd15;
            end
            

wire [3:0] dig_choose;
select S0(.a(display_tmp_3), .b(display_tmp_2), .c(display_tmp_1), .d(display_tmp_0), .o(dig_choose), .ssd_ctrl(ssd_ctrl), .enable(refresh));
SSD SSD(.i(dig_choose), .D(ssd_out));
    
endmodule
