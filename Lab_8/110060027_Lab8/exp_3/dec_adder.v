`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 22:44:33
// Design Name: 
// Module Name: dec_adder
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


module dec_adder(
    cout, 
    num_0, 
    num_1,
    num_2,
    num_3,
    digit_0_out,
    digit_1_out
    );
    output reg [3:0] cout;
    output reg [3:0] digit_0_out, digit_1_out;
    input [3:0] num_0, num_1, num_2, num_3;
    
    reg [3:0] carry_tmp;

    wire [4:0] num_tmp_0, num_tmp_1;

    assign num_tmp_0 = num_1 + num_3;
    assign num_tmp_1 = num_0 + num_2 + carry_tmp;

    always@(*)
    begin
        if (num_tmp_0 > 4'd9)
            begin
            carry_tmp = 4'd1;
            digit_0_out = num_1 + num_3 + 4'd6;
            end
        else
            begin
            carry_tmp = 4'd0;
            digit_0_out = num_1 + num_3;
            end
    end

    always@(*)
    begin
        if (num_tmp_1 > 4'd9)
            begin
            cout = 4'd1;
            digit_1_out = num_0 + num_2 + carry_tmp + 4'd6;
            end
        else
            begin
            cout = 4'd0;
            digit_1_out = num_0 + num_2 + carry_tmp;
            end
    end
endmodule
