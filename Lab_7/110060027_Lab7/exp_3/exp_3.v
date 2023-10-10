`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 14:36:39
// Design Name: 
// Module Name: exp_3
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


module exp_2(
    input clk,
    input reset,
    input switch,
    input botton_L,
    input botton_R,
    input botton_M,
    input botton_U,
    input botton_D,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin
    );
    
// frequency
wire clk_1hz, clk_100hz, refresh;
fre_divider_192Khz F1(.clk(clk), .reset(reset), .clk_new(audio_lrck));
fre_divider_25Mhz F2(.clk(clk), .reset(reset), .clk_new(audio_mclk));
fre_divider_6p25Mhz F3(.clk(clk), .reset(reset), .clk_new(audio_sck));
fre_divider_100hz F4(.clk(clk), .reset(reset), .clk_new(clk_100hz));

// botton
wire debounced_D, debounced_M, debounced_R, debounced_U, debounced_L;
wire op_D, op_M, op_R, op_U, op_L;
debounce D0(.clk(clk_100hz), .reset(reset), .push(botton_D), .push_debounced(debounced_D));
OP OP0(.clk(clk_100hz), .reset(reset), .push_debounced(debounced_D), .push_op(op_D));
debounce D1(.clk(clk_100hz), .reset(reset), .push(botton_M), .push_debounced(debounced_M));
OP OP1(.clk(clk_100hz), .reset(reset), .push_debounced(debounced_M), .push_op(op_M));
debounce D2(.clk(clk_100hz), .reset(reset), .push(botton_R), .push_debounced(debounced_R));
OP OP2(.clk(clk_100hz), .reset(reset), .push_debounced(debounced_R), .push_op(op_R));
debounce D3(.clk(clk_100hz), .reset(reset), .push(botton_U), .push_debounced(debounced_U));
OP OP3(.clk(clk_100hz), .reset(reset), .push_debounced(debounced_U), .push_op(op_U));
debounce D4(.clk(clk_100hz), .reset(reset), .push(botton_L), .push_debounced(debounced_L));
OP OP4(.clk(clk_100hz), .reset(reset), .push_debounced(debounced_L), .push_op(op_L));

// 聲音訊號處理
wire [15:0] audio_in_left, audio_in_right;
note_gen LEFT(.clk(clk), .reset(voice_enable && reset), .note_div(note_div_left), .audio_in(audio_in_left));
note_gen RIGHT(.clk(clk), .reset(voice_enable && reset), .note_div(note_div_right), .audio_in(audio_in_right));

// 訊號輸出
speaker_ctrl SPC(.reset(reset), .clk_small(audio_sck), .clk_big(audio_lrck), .audio_sdin(audio_sdin), .audio_left(audio_in_left), .audio_right(audio_in_right));
 
// 音高控制   
reg [21:0] note_div_left, note_div_right;
reg voice_enable;
always @(debounced_L or debounced_M or debounced_R or debounced_U or debounced_D or switch)
begin 
    // L
    if(switch && debounced_L)
    begin
        note_div_left <= 22'd191571;
        note_div_right <= 22'd151515;
        voice_enable <= 1;
    end
    else if(~switch && debounced_L)
    begin
        note_div_left <= 22'd191571;
        note_div_right <= 22'd191571;
        voice_enable <= 1;
    end
    
    // M
    else if(switch && debounced_M)
    begin
        note_div_left <= 22'd170648;
        note_div_right <= 22'd143266;
        voice_enable <= 1;
    end
    else if(~switch && debounced_M)
    begin
        note_div_left <= 22'd170648;
        note_div_right <= 22'd170648;
        voice_enable <= 1;
    end
    
    // R
    else if(switch && debounced_R)
    begin
        note_div_left <= 22'd151515;
        note_div_right <= 22'd127551;
        voice_enable <= 1;
    end
    else if(~switch && debounced_R)
    begin
        note_div_left <= 22'd151515;
        note_div_right <= 22'd151515;
        voice_enable <= 1;
    end
    
    // U
    else if(switch && debounced_U)
    begin
        note_div_left <= 22'd143266;
        note_div_right <= 22'd113636;
        voice_enable <= 1;
    end
    else if(~switch && debounced_U)
    begin
        note_div_left <= 22'd143266;
        note_div_right <= 22'd143266;
        voice_enable <= 1;
    end
    
    // D
    else if(switch && debounced_D)
    begin
        note_div_left <= 22'd127551;
        note_div_right <= 22'd101215;
        voice_enable <= 1;
    end
    else if(~switch && debounced_D)
    begin
        note_div_left <= 22'd127551;
        note_div_right <= 22'd127551;
        voice_enable <= 1;
    end
    
    // else
    else
    begin
        note_div_left <= 22'd127551;
        note_div_right <= 22'd127551;
        voice_enable <= 0;
    end
end

endmodule
