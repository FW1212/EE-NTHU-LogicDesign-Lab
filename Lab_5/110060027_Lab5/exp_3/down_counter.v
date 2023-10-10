`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 16:34:01
// Design Name: 
// Module Name: down_counter
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


module down_counter(
    output [3:0] value,
    output borrow,
    input clk,
    input reset,
    input decrease,
    input [3:0] init_value,
    input [3:0] limit,
    input en
    );
    
reg [3:0] value;
reg [3:0] value_tmp;
reg borrow;
    
always @(value or decrease or en or limit)
begin
    if (value == 4'd0 && decrease && en)
    begin
        value_tmp = limit;
        borrow = 1;
    end
    else if (decrease && en)
    begin
        value_tmp = value - 4'd1;
        borrow = 0;
    end
    else if (en)
    begin
        value_tmp = value;
        borrow = 0;
    end
    else
    begin
        value_tmp = 4'd0;
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
