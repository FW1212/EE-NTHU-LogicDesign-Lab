`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 21:27:33
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
        sum, 
        num_0, 
        num_1,
        clk,
        rst
    );
    output reg [3:0] cout;
    output reg [3:0] sum;
    input [3:0] num_0, num_1;
    input clk, rst;

    reg [3:0] cout_tmp, sum_tmp;

    wire [4:0] num_tmp;
    
    assign num_tmp = num_0 + num_1;

    always@(*)
    begin
        if (num_tmp > 4'd9)
            begin
            cout_tmp = 4'd1;
            sum_tmp = num_0 + num_1 + 4'd6;
            end
        else
            begin
            cout_tmp = 4'd0;
            sum_tmp = num_0 + num_1;
            end
    end

    always @(posedge clk or negedge rst)
        if (~rst)
            begin
            cout <= 4'd0;
            sum <= 4'd0;
            end
        else
            begin
            cout <= cout_tmp;
            sum <= sum_tmp;
            end
endmodule

