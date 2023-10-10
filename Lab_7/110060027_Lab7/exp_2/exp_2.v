`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 16:51:21
// Design Name: 
// Module Name: exp_2
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
    input botton_L,
    input botton_R,
    input botton_M,
    input botton_U,
    input botton_D,
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin,
    output [7:0] ssd_out,
    output [3:0] ssd_ctrl
    );
    
// frequency
wire clk_1hz, clk_100hz, refresh;
fre_divider_1hz_en F0(.clk(clk), .reset(reset), .clk_new(clk_1hz), .enable(refresh));
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
note_gen Ung(.clk(clk), .reset(voice_enable && reset), .note_div(note_div), .audio_left(audio_in_left), .audio_right(audio_in_right),
             .volumn_min(volumn_min), .volumn_max(volumn_max));
      
// FSM  與 音量控制
wire [3:0] state, dig_1, dig_0;
wire [15:0] volumn_max, volumn_min;
FSM FSM(.clk(clk_100hz), .reset(reset), .op_D(op_D), .op_U(op_U), .state(state));
state_to_number STM(.state(state), .dig_1(dig_1), .dig_0(dig_0), .volumn_max(volumn_max), .volumn_min(volumn_min));

// 訊號輸出
speaker_ctrl SPC(.reset(reset), .clk_small(audio_sck), .clk_big(audio_lrck), .audio_sdin(audio_sdin), .audio_left(audio_in_left), .audio_right(audio_in_right));

// 數字顯示
wire [3:0] dig_choose;
select SSD0(.a(dig_0), .b(dig_1), .o(dig_choose), .enable(refresh), .ssd_ctrl(ssd_ctrl));
SSD SSD1(.i(dig_choose), .D(ssd_out));
 
// 音高控制   
reg [21:0] note_div;
reg voice_enable;
always @(debounced_L or debounced_M or debounced_R)
begin 
    if(debounced_L)
    begin
        note_div <= 22'd191571;
        voice_enable <= 1;
    end
    else if(debounced_M)
    begin
        note_div <= 22'd170648;
        voice_enable <= 1;
    end
    else if(debounced_R)
    begin
        note_div <= 22'd151515;
        voice_enable <= 1;
    end
    else
    begin
        note_div <= 22'd151515;
        voice_enable <= 0;
    end
end

endmodule
