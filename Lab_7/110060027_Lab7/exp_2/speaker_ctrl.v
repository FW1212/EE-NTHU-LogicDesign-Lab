`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 17:27:01
// Design Name: 
// Module Name: speaker_ctrl
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


module speaker_ctrl(
    input clk_small,
    input clk_big,
    input reset,
    output audio_sdin,
    input [15:0] audio_left,
    input [15:0] audio_right
    );
    
reg [31:0] sdin_window_next, sdin_window;
reg audio_sdin, audio_sdin_next;
reg clk_big_dalay;

always @*
begin 
    sdin_window_next[31:0] <= {sdin_window[30:0], 1'b0};
    audio_sdin_next <= sdin_window[31];
end

always @(negedge clk_small or negedge reset)
begin
    if(~reset)
    begin
        audio_sdin <= 0; 
        sdin_window <= 32'd0; 
    end
    else
    begin
        audio_sdin <= audio_sdin_next;
        clk_big_dalay <= clk_big;
        if(~clk_big && clk_big_dalay)
            sdin_window <= {audio_left[15:0], audio_right[15:0]};
        else 
            sdin_window <= sdin_window_next;
    end
end
 
endmodule
