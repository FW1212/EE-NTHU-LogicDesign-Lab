`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 14:50:19
// Design Name: 
// Module Name: SMUX
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


module SMUX(
    input [3:0] i,
    input freeze_en,
    output [3:0] o,
    input clk,
    input reset
    );
    
reg [3:0] o, o_next;
    
always @(i or freeze_en)
begin
    if(freeze_en)
        o_next = o;
    else 
        o_next = i;
end

always @(posedge clk or negedge reset)
begin
    if (~reset)
        o <= i;
    else
        o <= o_next; 
end

endmodule
