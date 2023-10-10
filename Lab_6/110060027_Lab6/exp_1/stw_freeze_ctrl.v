`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 16:40:31
// Design Name: 
// Module Name: stw_freeze_ctrl
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


module stw_freeze_ctrl(
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
