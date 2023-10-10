`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 21:58:18
// Design Name: 
// Module Name: key_choose
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


module key_choose(
    input [8:0] last_change,
    input reset,
    input clk,
    output [3:0] result,
    input enable
    );
    
reg [3:0] result, result_next;
always @(last_change)
begin
    case(last_change)
    9'h070: // 0
        result_next[3:0] <= 4'd0;
    9'h069: // 1
        result_next[3:0] <= 4'd1;
    9'h072: // 2
        result_next[3:0] <= 4'd2;
    9'h07A: // 3
        result_next[3:0] <= 4'd3;
    9'h06B: // 4
        result_next[3:0] <= 4'd4;
    9'h073: // 5
        result_next[3:0] <= 4'd5;
    9'h074: // 6
        result_next[3:0] <= 4'd6;
    9'h06C: // 7
        result_next[3:0] <= 4'd7;
    9'h075: // 8
        result_next[3:0] <= 4'd8;
    9'h07D: // 9
        result_next[3:0] <= 4'd9;
    default:
        result_next[3:0] <= result[3:0];
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        result[3:0] <= 4'd15;
    else if(enable)
        result[3:0] <= result_next[3:0];
    else 
        result[3:0] <= result[3:0];
end
 
endmodule

