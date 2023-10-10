`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 17:06:17
// Design Name: 
// Module Name: note_gen
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


module note_gen(
    input clk,
    input reset,
    input [21:0] note_div,
    output [15:0] audio_left,
    output [15:0] audio_right,
    input [15:0] volumn_min,
    input [15:0] volumn_max
    );
    
reg [21:0] clk_cnt_next, clk_cnt;
reg b_clk;

assign audio_left = (b_clk == 1'b0) ? volumn_min : volumn_max;
assign audio_right = (b_clk == 1'b0) ? volumn_min : volumn_max;

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin 
        clk_cnt <= 22'd0;
        b_clk <= 0;
    end
    else
    begin
        clk_cnt <= clk_cnt_next;
        if (clk_cnt == note_div - 22'd1)
        begin
            clk_cnt <= 22'd0;
            b_clk <= ~b_clk;
        end
    end
end

always @*
begin
    clk_cnt_next <= clk_cnt + 22'd1;
end

endmodule
