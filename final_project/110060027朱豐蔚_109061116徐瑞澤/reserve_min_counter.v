`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 15:03:50
// Design Name: 
// Module Name: reserve_min_counter
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


module reserve_min_counter(
    output [3:0] value_ten,
    output [3:0] value_one,
    output total_borrow, // ���e�@��[�@
    output total_de_borrow, // ���e�@���@
    input en,
    input clk,
    input reset,
    input button_op_L,
    input button_op_R,
    input KB_op_L,
    input KB_op_R,
    input decrease
    );
    
// �N��L�T���P���s�T�����X��        
wire add, sub;
assign add = (button_op_R | KB_op_R) & en;     // �n en �~�i����
assign sub = ((button_op_L | KB_op_L) & en) | decrease;     // �n en �~�i�����A�άO�b�D stop ���ɭ� decrease
    
reg [3:0] value_ten, value_ten_tmp;
reg [3:0] value_one, value_one_tmp;
reg total_borrow, total_de_borrow;

    always @(value_ten or value_one or add or sub)
    begin
        if (value_ten == 4'd5 && value_one == 4'd9 && add)     // �Y�w�g 59 �F�A�S�A�[�A�h�i�� 
            begin
                value_ten_tmp = 4'd0;
                value_one_tmp = 4'd0;
                total_borrow = 1;
                total_de_borrow = 0;
            end
        else if (value_ten == 4'd0 && value_one == 4'd0 && sub)     // �Y�w�g 00 �F�A�S�A��A�h�h�� 
            begin
                value_ten_tmp = 4'd5;
                value_one_tmp = 4'd9;
                total_borrow = 0;
                total_de_borrow = 1;
            end
        else if (value_one == 4'd9 && add)     
            begin
                value_ten_tmp =  value_ten + 4'd1;
                value_one_tmp = 4'd0;
                total_borrow = 0;
                total_de_borrow = 0;
            end
        else if (value_one == 4'd0 && sub)
            begin
                value_ten_tmp =  value_ten - 4'd1;
                value_one_tmp = 4'd9;
                total_borrow = 0;
                total_de_borrow = 0;
            end
        else if (add)     
            begin
                value_ten_tmp =  value_ten;
                value_one_tmp = value_one + 4'd1;
                total_borrow = 0;
                total_de_borrow = 0;
            end
        else if (sub)     
            begin
                value_ten_tmp =  value_ten;
                value_one_tmp = value_one - 4'd1;
                total_borrow = 0;
                total_de_borrow = 0;
            end
        else
            begin
                value_one_tmp = value_one;
                value_ten_tmp =  value_ten;
                total_borrow = 0;
                total_de_borrow = 0;
            end
    end

    always @(posedge clk or negedge reset)
    begin
        if(~reset)
            begin
                value_ten <= 4'd0;
                value_one <= 4'd0;
            end
        else
            begin
                value_one <= value_one_tmp;
                value_ten <= value_ten_tmp;
            end
    end
    
endmodule
