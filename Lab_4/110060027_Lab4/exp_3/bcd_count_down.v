`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:13:42
// Design Name: 
// Module Name: bcd_count_down
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


module bcd_count_down(
    input clk,
    input reset,
    output [3:0] o
    );
    
reg [3:0] o;
reg [3:0] o_tmp;
    
always @(o)
begin
    if(o[3:0] == 0)
        o_tmp[3:0] <= 4'b1001;
    else 
        o_tmp[3:0] <= o[3:0] - 4'd1; 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        o[3:0] <= 4'b0000;
    else
        o[3:0] <= o_tmp[3:0];
end
    
endmodule
