`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 22:57:59
// Design Name: 
// Module Name: dec_multiplier
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


module dec_multiplier(
    num_0, 
    num_1,
    num_2,
    num_3,
    digit_0_out,
    digit_1_out,
    digit_2_out,
    digit_3_out
    );

    output reg [3:0] digit_0_out, digit_1_out, digit_2_out, digit_3_out;
    input [3:0] num_0, num_1, num_2, num_3;
    
    reg [13:0] final_value;

    wire [13:0] value_0;
    wire [13:0] value_1;
    
    assign value_0 = num_3 * 14'd10 + num_2;
    assign value_1 = num_1 * 14'd10 + num_0;

    always @*
        final_value = value_0 * value_1;
    
    always @*
        begin
            digit_3_out = final_value / 14'd1000;
            digit_2_out = (final_value % 14'd1000) / 14'd100;
            digit_1_out = (final_value % 14'd100) / 14'd10;
            digit_0_out = final_value % 14'd10;
        end
endmodule
