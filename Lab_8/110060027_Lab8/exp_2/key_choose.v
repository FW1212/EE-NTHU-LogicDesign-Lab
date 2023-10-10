`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 16:43:49
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
    input enable,
    input clk,
    output [3:0] result
    );
    
reg [3:0] result, result_next;
always @(last_change)
begin
    case(last_change)
    9'h045: // 0
        result_next[3:0] <= 4'd0;
    9'h016: // 1
        result_next[3:0] <= 4'd1;
    9'h01E: // 2
        result_next[3:0] <= 4'd2;
    9'h026: // 3
        result_next[3:0] <= 4'd3;
    9'h025: // 4
        result_next[3:0] <= 4'd4;
    9'h02E: // 5
        result_next[3:0] <= 4'd5;
    9'h036: // 6
        result_next[3:0] <= 4'd6;
    9'h03D: // 7
        result_next[3:0] <= 4'd7;
    9'h03E: // 8
        result_next[3:0] <= 4'd8;
    9'h046: // 9
        result_next[3:0] <= 4'd9;
    default:
        result_next[3:0] <= result[3:0];
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        result[3:0] <= 4'd0;
    else if(enable)
        result[3:0] <= result_next[3:0];
    else 
        result[3:0] <= result[3:0];
end
 
endmodule
