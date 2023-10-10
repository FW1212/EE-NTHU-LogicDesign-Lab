`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 17:48:35
// Design Name: 
// Module Name: fre_divider
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


module fre_divider(
    input clk,
    output clk_new,
    input reset
    );

reg clk_new;
reg [26:0] count_total;
reg [25:0] count_back;
    
always @(clk_new or count_back)
begin
    count_total = {clk_new,count_back} + 27'd1; 
end 
   
always @(posedge clk or negedge reset)
begin
    if (~reset)
    begin
        count_back = 26'd0;
        clk_new = 0;
    end
    else
        {clk_new,count_back} = count_total;
end

endmodule
