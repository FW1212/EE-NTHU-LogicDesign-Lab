`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/05 13:56:28
// Design Name: 
// Module Name: reserve_sec_counter
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


module reserve_sec_counter(
    output [3:0] value_ten,
    output [3:0] value_one,
    output total_de_borrow, // 讓前一位減一
    input stop,
    input decrease,
    input clk,
    input reset
    );
    
wire sub;
assign sub = decrease & ~stop;     // 要非 stop 才可減少
    
reg [3:0] value_ten, value_ten_tmp;
reg [3:0] value_one, value_one_tmp;
reg total_de_borrow;

    always @(value_ten or value_one or sub)
    begin
        if (value_ten == 4'd0 && value_one == 4'd0 && sub)     // 若已經 00 了，又再減，則退位 
            begin
                value_ten_tmp = 4'd5;
                value_one_tmp = 4'd9;
                total_de_borrow = 1;
            end
        else if (value_one == 4'd0 && sub)
            begin
                value_ten_tmp =  value_ten - 4'd1;
                value_one_tmp = 4'd9;
                total_de_borrow = 0;
            end
        else if (sub)     
            begin
                value_ten_tmp =  value_ten;
                value_one_tmp = value_one - 4'd1;
                total_de_borrow = 0;
            end
        else
            begin
                value_one_tmp = value_one;
                value_ten_tmp =  value_ten;
                total_de_borrow = 0;
            end
    end

    always @(posedge clk or negedge reset)
    begin
        if(~reset)
            begin
                value_ten <= 4'd0;
                value_one <= 4'd1;
            end
        else
            begin
                value_one <= value_one_tmp;
                value_ten <= value_ten_tmp;
            end
    end
    
endmodule
