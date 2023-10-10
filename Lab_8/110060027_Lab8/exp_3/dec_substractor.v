`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 22:49:56
// Design Name: 
// Module Name: dec_substractor
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


module dec_substractor(
    num_0, 
    num_1,
    num_2,
    num_3,
    digit_0_out,
    digit_1_out,
    value_0,
    value_1
    );

    output reg [3:0] digit_0_out, digit_1_out;
    output [6:0] value_0, value_1;
    input [3:0] num_0, num_1, num_2, num_3;
    
    reg [3:0] borrow;
   

    assign value_1 = num_3 * 7'd10 + num_2;
    assign value_0 = num_1 * 7'd10 + num_0;

    always@(*)
        if (value_1 > value_0)
            begin
            if (num_2 < num_0)
                begin
                borrow = 4'd1;
                digit_0_out = num_2 + 4'd10 - num_0;
                end
            else
                begin
                borrow = 4'd0;
                digit_0_out = num_2 - num_0;
                end
            end
        else
            begin
            if (num_0 < num_2)
                begin
                borrow = 4'd1;
                digit_0_out = num_0 + 4'd10 - num_2;
                end
            else
                begin
                borrow = 4'd0;
                digit_0_out = num_0 - num_2;
                end
            end

    always @*
        if (value_1 > value_0)
            digit_1_out = num_3 - num_1 - borrow;
        else
            digit_1_out = num_1 - num_3 - borrow;
   
endmodule
