`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 15:05:51
// Design Name: 
// Module Name: exp_1
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


module exp_1(
    input clk,
    input reset,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin,
    output [15:0] audio_in_left,
    output [15:0] audio_in_right
    );
    
// frequency
wire clk_100hz;
fre_divider_192Khz F1(.clk(clk), .reset(reset), .clk_new(audio_lrck));
fre_divider_25Mhz F2(.clk(clk), .reset(reset), .clk_new(audio_mclk));
fre_divider_6p25Mhz F3(.clk(clk), .reset(reset), .clk_new(audio_sck));
fre_divider_100hz F4(.clk(clk), .reset(reset), .clk_new(clk_100hz));

// 聲音訊號處理
wire [15:0] audio_in_left, audio_in_right;
note_gen Ung(.clk(clk), .reset(reset), .note_div(22'd5000), .audio_left(audio_in_left), .audio_right(audio_in_right));

// 訊號輸出
speaker_ctrl SPC(.reset(reset), .clk_small(audio_sck), .clk_big(audio_lrck), .audio_sdin(audio_sdin), .audio_left(audio_in_left), .audio_right(audio_in_right));

endmodule
