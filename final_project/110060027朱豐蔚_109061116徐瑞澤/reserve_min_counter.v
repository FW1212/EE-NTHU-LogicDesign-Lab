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
    output total_borrow, // 讓前一位加一
    output total_de_borrow, // 讓前一位減一
    input en,
    input clk,
    input reset,
    input button_op_L,
    input button_op_R,
    input KB_op_L,
    input KB_op_R,
    input decrease
    );
    
// 將鍵盤訊號與按鈕訊號做合併        
wire add, sub;
assign add = (button_op_R | KB_op_R) & en;     // 要 en 才可切換
assign sub = ((button_op_L | KB_op_L) & en) | decrease;     // 要 en 才可切換，或是在非 stop 的時候 decrease
    
reg [3:0] value_ten, value_ten_tmp;
reg [3:0] value_one, value_one_tmp;
reg total_borrow, total_de_borrow;

    always @(value_ten or value_one or add or sub)
    begin
        if (value_ten == 4'd5 && value_one == 4'd9 && add)     // 若已經 59 了，又再加，則進位 
            begin
                value_ten_tmp = 4'd0;
                value_one_tmp = 4'd0;
                total_borrow = 1;
                total_de_borrow = 0;
            end
        else if (value_ten == 4'd0 && value_one == 4'd0 && sub)     // 若已經 00 了，又再減，則退位 
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
