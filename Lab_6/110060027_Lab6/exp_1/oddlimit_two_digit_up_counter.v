`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/07 17:15:25
// Design Name: 
// Module Name: oddlimit_two_digit_up_counter
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


module oddlimit_two_digit_up_counter(
    output [3:0] value_ten,
    output [3:0] value_one,
    output total_borrow,
    input clk,
    input reset,
    input increase,
    input [3:0] total_limit_ten,
    input [3:0] total_limit_one,
    input [3:0] init_value_ten,
    input [3:0] init_value_one,
    input [3:0] br_finish_ten,
    input [3:0] br_finish_one,
    input en
);

    reg [3:0] value_ten, value_ten_tmp;
    reg [3:0] value_one, value_one_tmp;
    reg total_borrow;

    always @(total_limit_ten or total_limit_one or value_ten or value_one or increase or en)
    begin
        if (value_ten == total_limit_ten && total_limit_one == 4'd0 && increase && en)
            begin
                value_ten_tmp = br_finish_ten;
                value_one_tmp = br_finish_one + 4'd1;
                total_borrow = 0;
            end
        else if (value_ten == total_limit_ten && value_one == total_limit_one - 4'd1 && increase && en)
            begin
                value_ten_tmp = br_finish_ten;
                value_one_tmp = br_finish_one;
                total_borrow = 1;
            end
        else if (value_one == 4'd9 && increase && en)
            begin
                value_one_tmp = 4'd0;
                value_ten_tmp =  value_ten + 4'd1;
                total_borrow = 0;
            end
        else if (increase && en)
            begin
                value_one_tmp = value_one + 4'd1;
                value_ten_tmp =  value_ten;
                total_borrow = 0;
            end
        else if (en)
            begin
                value_one_tmp = value_one;
                value_ten_tmp =  value_ten;
                total_borrow = 0;
            end
        else
            begin
                value_one_tmp = value_one;
                value_ten_tmp =  value_ten;
                total_borrow = 0;
            end
    end

    always @(posedge clk or negedge reset)
    begin
        if(~reset)
            begin
                value_ten <= init_value_ten;
                value_one <= init_value_one;
            end
        else
            begin
                value_one <= value_one_tmp;
                value_ten <= value_ten_tmp;
            end
    end

endmodule
