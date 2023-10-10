`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 19:38:59
// Design Name: 
// Module Name: normal_limit_counter
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


module normal_limit_counter(
    output [3:0] value,
    output borrow,
    input clk,
    input reset,
    input increase,
    input [3:0] init_value,
    input [3:0] limit,
    input en
    );
    
reg [3:0] value;
reg [3:0] value_tmp;
reg borrow;
    
always @(value or increase or en or limit)
begin
    if (value == limit && increase && en)
    begin
        value_tmp = 4'd0;
        borrow = 1;
    end
    else if (increase && en)
    begin
        value_tmp = value + 4'd1;
        borrow = 0;
    end
    else if (en)
    begin
        value_tmp = value;
        borrow = 0;
    end
    else
    begin
        value_tmp = value;
        borrow = 0;
    end
end
   
always @(posedge clk or negedge reset)
begin
    if(~reset)
        value <= init_value;
    else
        value <= value_tmp;
end

endmodule
