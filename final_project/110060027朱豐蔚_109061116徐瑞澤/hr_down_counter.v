`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/04 14:12:45
// Design Name: 
// Module Name: hr_down_counter
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


module hr_down_counter(
    output [3:0] value,
    input [3:0] value_init,
    input en,
    input decrease,
    input clk,
    input reset
    );
    
wire sub;
assign sub = decrease & en;     // 要 en 才可減少
    
reg [3:0] value, value_tmp;

    always @(value or sub)
    begin
        if (value == 4'd0 && sub)     // 若已經 0 了，又再減，則退位 
            value_tmp = 4'd9;
        else if (sub)     
            value_tmp = value - 4'd1;
        else
            value_tmp = value;
    end

    always @(posedge clk or negedge reset)
    begin
        if(~reset)
            value <= value_init;
        else
            value <= value_tmp;
    end
    
endmodule
