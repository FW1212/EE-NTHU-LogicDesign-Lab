`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 21:52:37
// Design Name: 
// Module Name: main
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


module main(
    input button_U,
    input button_D,
    input button_M,
    input button_L,
    input button_R,
    input clk,
    input switch_door,
    input switch_power,
    input switch_mode_1, // 細緻洗衣
    input switch_mode_2, // 快洗
    input switch_mode_3, // 厚重衣物
    inout ps2_data,
    inout ps2_clk,
    output [3:0] ssd_ctrl,
    output [7:0] ssd_out,
    output [2:0] LED_water, // 表示水量選擇
    output [2:0] LED_tem, // 表示溫度選擇
    output [2:0] LED_mode, // 表示洗衣模式
    output [1:0] LED_state, // 表示洗衣、烘衣
    output audio_mclk,
    output audio_lrck,
    output audio_sck,
    output audio_sdin,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output hsync,
    output vsync
    );

// 將 Power 定義成 reset
wire reset;
assign reset = switch_power;

// 各頻率控制
wire clk_1hz, clk_100hz, clk_25Mhz;
wire [1:0] refresh;     // 用來更新 SSD
fre_divider_1hz_en FRE0(.clk(clk), .reset(reset), .clk_new(clk_1hz), .enable(refresh));     // 1Hz 訊號，且更新 SSD
fre_divider_192Khz FRE1(.clk(clk), .reset(reset), .clk_new(audio_lrck));
fre_divider_25Mhz FRE2(.clk(clk), .reset(reset), .clk_new(audio_mclk));
fre_divider_25Mhz FRE3(.clk(clk), .reset(reset), .clk_new(clk_25Mhz));
fre_divider_6p25Mhz FRE4(.clk(clk), .reset(reset), .clk_new(audio_sck));
fre_divider_100hz FRE5(.clk(clk), .reset(reset), .clk_new(clk_100hz));     // 100Hz 訊號，用於 FSM 與 OP

//  按鈕前處理
wire button_debounced_D, button_debounced_M, button_debounced_R, button_debounced_U, button_debounced_L;
debounce DE0(.clk(clk_100hz), .reset(reset), .push(button_D), .push_debounced(button_debounced_D));
debounce DE1(.clk(clk_100hz), .reset(reset), .push(button_M), .push_debounced(button_debounced_M));
debounce DE2(.clk(clk_100hz), .reset(reset), .push(button_R), .push_debounced(button_debounced_R));
debounce DE3(.clk(clk_100hz), .reset(reset), .push(button_U), .push_debounced(button_debounced_U));
debounce DE4(.clk(clk_100hz), .reset(reset), .push(button_L), .push_debounced(button_debounced_L));
wire button_op_D, button_op_M, button_op_R, button_op_U, button_op_L;
OP OP0(.clk(clk_100hz), .reset(reset), .push_debounced(button_debounced_D), .push_op(button_op_D));
OP OP1(.clk(clk_100hz), .reset(reset), .push_debounced(button_debounced_M), .push_op(button_op_M));
OP OP2(.clk(clk_100hz), .reset(reset), .push_debounced(button_debounced_R), .push_op(button_op_R));
OP OP3(.clk(clk_100hz), .reset(reset), .push_debounced(button_debounced_U), .push_op(button_op_U));
OP OP4(.clk(clk_100hz), .reset(reset), .push_debounced(button_debounced_L), .push_op(button_op_L));

// 開關前處理
wire SW_op_U_1, SW_op_U_2, SW_op_U_3, SW_op_D_1, SW_op_D_2, SW_op_D_3;     // 處理 mode 開關的打開、關閉判斷
switch_op OP5(.clk(clk_100hz), .reset(reset), .switch(switch_mode_1), .turn_up(SW_op_U_1), .turn_down(SW_op_D_1));
switch_op OP6(.clk(clk_100hz), .reset(reset), .switch(switch_mode_2), .turn_up(SW_op_U_2), .turn_down(SW_op_D_2));
switch_op OP7(.clk(clk_100hz), .reset(reset), .switch(switch_mode_3), .turn_up(SW_op_U_3), .turn_down(SW_op_D_3));
wire SW_op_U_door, SW_op_D_door;     // 處理 door 開關的打開、關閉判斷
switch_op OP8(.clk(clk_100hz), .reset(reset), .switch(switch_door), .turn_up(SW_op_U_door), .turn_down(SW_op_D_door));

// 鍵盤前處理
wire [511:0] key_down;
wire [8:0]last_change;
wire key_valid;
KeyboardDecoder KB0(.key_down(key_down), .last_change(last_change), .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), .rst(~reset), .clk(clk));     // 鍵盤讀取

// 過濾所需按鍵，並轉換為所需脈衝型態
wire KB_enter, KB_U, KB_D, KB_L, KB_R;
assign KB_enter = key_down[9'h05A];
assign KB_U = key_down[9'h075];
assign KB_D = key_down[9'h072];
assign KB_L = key_down[9'h06B];
assign KB_R = key_down[9'h174];
wire KB_op_enter, KB_op_U, KB_op_D, KB_op_L, KB_op_R;
OP OP9(.clk(clk_100hz), .reset(reset), .push_debounced(KB_enter), .push_op(KB_op_enter));
OP OP10(.clk(clk_100hz), .reset(reset), .push_debounced(KB_U), .push_op(KB_op_U));
OP OP11(.clk(clk_100hz), .reset(reset), .push_debounced(KB_D), .push_op(KB_op_D));
OP OP12(.clk(clk_100hz), .reset(reset), .push_debounced(KB_L), .push_op(KB_op_L));
OP OP13(.clk(clk_100hz), .reset(reset), .push_debounced(KB_R), .push_op(KB_op_R));

//  SSD 顯示項目的 FSM
wire [2:0] state_display;
FSM_display FSM0(.button_op_U(button_op_U), .button_op_D(button_op_D), .KB_op_U(KB_op_U), .KB_op_D(KB_op_D),
                 .reset(reset), .clk(clk_100hz), .state(state_display));

// SSD 控制
wire [3:0] final_dig_choose, final_dig_0, final_dig_1, final_dig_2, final_dig_3;
SMUX_final_digit SMUX0(.final_dig_0(final_dig_0), .final_dig_1(final_dig_1), .final_dig_2(final_dig_2), .final_dig_3(final_dig_3), .state_display(state_display),     // 根據 state_display，控制 SSD
                       .state_water(state_water), .state_tem(state_tem),
                       .washtime_dig_min_ten(washtime_dig_min_ten), .washtime_dig_min_one(washtime_dig_min_one), .washtime_dig_hr(washtime_dig_hr),
                       .drytime_dig_min_ten(drytime_dig_min_ten), .drytime_dig_min_one(drytime_dig_min_one), .drytime_dig_hr(drytime_dig_hr),
                       .downtime_dig_min_ten(downtime_dig_min_ten), .downtime_dig_min_one(downtime_dig_min_one), .downtime_dig_hr(downtime_dig_hr),
                       .downtime_dig_sec_ten(downtime_dig_sec_ten), .downtime_dig_sec_one(downtime_dig_sec_one),
                       .reservetime_dig_min_ten(reservetime_dig_min_ten), .reservetime_dig_min_one(reservetime_dig_min_one), .reservetime_dig_hr(reservetime_dig_hr));  
ssd_refresh SSD0(.a(final_dig_3), .b(final_dig_2), .c(final_dig_1), .d(final_dig_0), .enable(refresh), .o(final_dig_choose), .ssd_ctrl(ssd_ctrl));     // 更新 SSD
SSD SSD1(.i(final_dig_choose), .D(ssd_out)); 

// 洗衣時間控制
wire [3:0] washtime_dig_min_ten, washtime_dig_min_one, washtime_dig_hr;
wire washtime_borrow, washtime_de_borrow;
wire en_washtime;
assign en_washtime = ~state_display[2] & ~state_display[1] & state_display[0];     // 當 state_display 為 3'd1 時，才可切換洗衣時間
setting_min_counter C0(.value_ten(washtime_dig_min_ten), .value_one(washtime_dig_min_one), .en(en_washtime), .clk(clk_100hz), .reset(reset),
                       .total_borrow(washtime_borrow), .total_de_borrow(washtime_de_borrow),  
                       .button_op_L(button_op_L), .button_op_R(button_op_R), .KB_op_L(KB_op_L), .KB_op_R(KB_op_R),
                       .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));
setting_hr_counter C1(.value(washtime_dig_hr), .clk(clk_100hz), .reset(reset), .add(washtime_borrow), .sub(washtime_de_borrow),
                      .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));

// 水量控制
wire [2:0] state_water;
wire en_water;
assign en_water = ~state_display[2] & state_display[1] & ~state_display[0];     // 當 state_display 為 3'd2 時，才可切換水量
FSM_water FSM1(.en(en_water), .clk(clk_100hz), .reset(reset), .state(state_water),
               .button_op_L(button_op_L), .button_op_R(button_op_R), .KB_op_L(KB_op_L), .KB_op_R(KB_op_R),
               .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));

// 烘衣時間控制
wire [3:0] drytime_dig_min_ten, drytime_dig_min_one, drytime_dig_hr;
wire drytime_borrow, drytime_de_borrow;
wire en_drytime;
assign en_drytime = ~state_display[2] & state_display[1] & state_display[0];     // 當 state_display 為 3'd3 時，才可切換烘衣時間
setting_min_counter C2(.value_ten(drytime_dig_min_ten), .value_one(drytime_dig_min_one), .en(en_drytime), .clk(clk_100hz), .reset(reset),
                       .total_borrow(drytime_borrow), .total_de_borrow(drytime_de_borrow),  
                       .button_op_L(button_op_L), .button_op_R(button_op_R), .KB_op_L(KB_op_L), .KB_op_R(KB_op_R),
                       .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));
setting_hr_counter C3(.value(drytime_dig_hr), .clk(clk_100hz), .reset(reset), .add(drytime_borrow), .sub(drytime_de_borrow),
                      .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));

// 溫度控制
wire [2:0] state_tem;
wire en_tem;
assign en_tem = state_display[2] & ~state_display[1] & ~state_display[0];     // 當 state_display 為 3'd4 時，才可切換水量
FSM_tem FSM2(.en(en_tem), .clk(clk_100hz), .reset(reset), .state(state_tem),
             .button_op_L(button_op_L), .button_op_R(button_op_R), .KB_op_L(KB_op_L), .KB_op_R(KB_op_R),
             .SW_op_U_1(SW_op_U_1), .SW_op_U_2(SW_op_U_2), .SW_op_U_3(SW_op_U_3));

// 排程時間控制
wire [3:0] reservetime_dig_sec_ten, reservetime_dig_sec_one, reservetime_dig_min_ten, reservetime_dig_min_one, reservetime_dig_hr;
wire reservetime_borrow, reservetime_de_borrow;
wire reservetime_sec_de_borrow, reservetime_sec_de_borrow_op;
switch_op OP14(.clk(clk_100hz), .reset(reset), .switch(reservetime_sec_de_borrow), .turn_up(reservetime_sec_de_borrow_op), .turn_down());
wire en_reservetime;
assign en_reservetime = state_display[2] & ~state_display[1] & state_display[0];     // 當 state_display 為 3'd5 時，才可切換排程時間
wire reservetime_stop;
assign reservetime_stop = (reservetime_dig_sec_ten == 4'd0 && reservetime_dig_sec_one == 4'd1 && reservetime_dig_min_ten == 4'd0 && reservetime_dig_min_one == 4'd0 && reservetime_dig_hr == 4'd0) ? 1 : 0; 
wire reservetime_complete, reservetime_complete_op;
assign reservetime_complete = (reservetime_dig_sec_ten == 4'd0 && reservetime_dig_sec_one == 4'd2 && reservetime_dig_min_ten == 4'd0 && reservetime_dig_min_one == 4'd0 && reservetime_dig_hr == 4'd0) ? 1 : 0; 
switch_op OP15(.clk(clk_100hz), .reset(reset), .switch(reservetime_complete), .turn_up(reservetime_complete_op), .turn_down());
reserve_sec_counter C4(.value_ten(reservetime_dig_sec_ten), .value_one(reservetime_dig_sec_one), .stop(reservetime_stop),
                       .total_de_borrow(reservetime_sec_de_borrow), .decrease(1), .clk(clk_1hz), .reset(reset));
reserve_min_counter C5(.value_ten(reservetime_dig_min_ten), .value_one(reservetime_dig_min_one), .en(en_reservetime), .clk(clk_100hz), .reset(reset),
                       .total_borrow(reservetime_borrow), .total_de_borrow(reservetime_de_borrow), .decrease(reservetime_sec_de_borrow_op),
                       .button_op_L(button_op_L), .button_op_R(button_op_R), .KB_op_L(KB_op_L), .KB_op_R(KB_op_R));
reserve_hr_counter C6(.value(reservetime_dig_hr), .clk(clk_100hz), .reset(reset), .borrow(reservetime_borrow), .deborrow(reservetime_de_borrow),
                      .button_debounced_L(button_debounced_L), .button_debounced_R(button_debounced_R), .KB_L(KB_L), .KB_R(KB_R));
                      
// 進程 FSM 設置
wire [2:0] state_process;
wire [3:0] washtime_downdig_min_ten, washtime_downdig_min_one, washtime_downdig_hr;     // 固定洗衣倒數時間
wire [3:0] drytime_downdig_min_ten, drytime_downdig_min_one, drytime_downdig_hr;     // 固定烘衣倒數時間
wire downtime_reset_2;
FSM_process FSM3(.button_op_M(button_op_M), .button_debounced_M(button_debounced_M), .KB_op_enter(KB_op_enter), .KB_enter(KB_enter), 
                 .SW_op_U_door(SW_op_U_door), .switch_door(switch_door), .downtime_complete_op(downtime_complete_op), .reserve_complete_op(reservetime_complete_op),
                 .LED_water(LED_water), .LED_tem(LED_tem), .state_water(state_water), .state_tem(state_tem), .downtime_reset_2(downtime_reset_2),
                 .washtime_dig_min_ten(washtime_dig_min_ten), .washtime_dig_min_one(washtime_dig_min_one), .washtime_dig_hr(washtime_dig_hr),
                 .drytime_dig_min_ten(drytime_dig_min_ten), .drytime_dig_min_one(drytime_dig_min_one), .drytime_dig_hr(drytime_dig_hr),
                 .washtime_downdig_min_ten(washtime_downdig_min_ten), .washtime_downdig_min_one(washtime_downdig_min_one), .washtime_downdig_hr(washtime_downdig_hr),
                 .drytime_downdig_min_ten(drytime_downdig_min_ten), .drytime_downdig_min_one(drytime_downdig_min_one), .drytime_downdig_hr(drytime_downdig_hr),
                 .reset(reset), .clk(clk_100hz), .state(state_process));
assign LED_state[1] = (state_process == 4'd1 || state_process == 4'd2) ? 1 : 0;     // 當 state_display 為 3'd1 或 3'd2 時，顯示洗衣狀態
assign LED_state[0] = (state_process == 4'd3 || state_process == 4'd4) ? 1 : 0;     // 當 state_display 為 3'd3 或 3'd4 時，顯示烘衣狀態

// 倒數控制
wire [3:0] downtime_dig_sec_ten, downtime_dig_sec_one, downtime_dig_min_ten, downtime_dig_min_one, downtime_dig_hr;
wire downtime_sec_de_borrow,  downtime_min_de_borrow;
wire en_downtime;
assign en_downtime = state_process[0];     // 當 state_display 為 3'd1 或 3'd3 或 3'd5 時 (共同點是第三位都為 1 )，才可倒數
reg [3:0] downtime_dig_min_ten_init, downtime_dig_min_one_init, downtime_dig_hr_init;
always @*
begin
    if(state_process == 3'd0)     // 等待
    begin 
        downtime_dig_min_ten_init = 4'd0;
        downtime_dig_min_one_init = 4'd0;
        downtime_dig_hr_init = 4'd0;
    end
    else if(state_process == 3'd1)     // 洗衣
    begin 
        downtime_dig_min_ten_init = washtime_downdig_min_ten;
        downtime_dig_min_one_init = washtime_downdig_min_one;
        downtime_dig_hr_init = washtime_downdig_hr;
    end
    else if(state_process == 3'd3)     // 烘衣
    begin 
        downtime_dig_min_ten_init = drytime_downdig_min_ten;
        downtime_dig_min_one_init = drytime_downdig_min_one;
        downtime_dig_hr_init = drytime_downdig_hr;
    end
    else     // 除錯
    begin
        downtime_dig_min_ten_init = 4'd0;
        downtime_dig_min_one_init = 4'd0;
        downtime_dig_hr_init = 4'd0;
    end
end

sec_down_counter C7(.value_ten(downtime_dig_sec_ten), .value_one(downtime_dig_sec_one), .value_ten_init(4'd0), .value_one_init(4'd2), 
                    .total_de_borrow(downtime_sec_de_borrow), .en(en_downtime), .decrease(1), .clk(clk_1hz), .reset(reset & downtime_reset & downtime_reset_2));
min_down_counter C8(.value_ten(downtime_dig_min_ten), .value_one(downtime_dig_min_one), .value_ten_init(downtime_dig_min_ten_init), .value_one_init(downtime_dig_min_one_init), 
                    .total_de_borrow(downtime_min_de_borrow), .en(en_downtime), .decrease(downtime_sec_de_borrow), .clk(clk_1hz), .reset(reset & downtime_reset & downtime_reset_2));
hr_down_counter C9(.value(downtime_dig_hr), .value_init(downtime_dig_hr_init),
                   .en(en_downtime), .decrease(downtime_min_de_borrow), .clk(clk_1hz), .reset(reset & downtime_reset & downtime_reset_2));

wire downtime_complete;
assign downtime_complete = (downtime_dig_sec_ten == 4'd0 && downtime_dig_sec_one == 4'd0 && downtime_dig_min_ten == 4'd0 && downtime_dig_min_one == 4'd0 && downtime_dig_hr == 4'd0) ? 1 : 0; 
wire downtime_complete_op;
switch_op OP16(.clk(clk_100hz), .reset(reset), .switch(downtime_complete), .turn_up(downtime_complete_op), .turn_down());
wire downtime_reset;
assign downtime_reset = (downtime_dig_sec_ten == 4'd5 && downtime_dig_sec_one == 4'd9 && downtime_dig_min_ten == 4'd5 && downtime_dig_min_one == 4'd9 && downtime_dig_hr == 4'd9) ? 0 : 1; 

// mode 燈號控制
assign LED_mode[0] = (washtime_dig_min_ten == 4'd3 && washtime_dig_min_one == 4'd0 && washtime_dig_hr == 4'd0 && 
                      drytime_dig_min_ten == 4'd3 && drytime_dig_min_one == 4'd0 && drytime_dig_hr == 4'd0 &&
                      state_water == 3'd1 && state_tem == 3'd1) ? 1 : 0;
assign LED_mode[1] = (washtime_dig_min_ten == 4'd1 && washtime_dig_min_one == 4'd5 && washtime_dig_hr == 4'd0 && 
                      drytime_dig_min_ten == 4'd1 && drytime_dig_min_one == 4'd5 && drytime_dig_hr == 4'd0 &&
                      state_water == 3'd2 && state_tem == 3'd2) ? 1 : 0;
assign LED_mode[2] = (washtime_dig_min_ten == 4'd0 && washtime_dig_min_one == 4'd0 && washtime_dig_hr == 4'd1 && 
                      drytime_dig_min_ten == 4'd0 && drytime_dig_min_one == 4'd0 && drytime_dig_hr == 4'd1 &&
                      state_water == 3'd4 && state_tem == 3'd4) ? 1 : 0;                                    

// 控制音高、音量
wire [15:0] audio_in_left, audio_in_right;
wire voice_enable;
assign voice_enable = (downtime_dig_sec_ten == 4'd0 && downtime_dig_sec_one == 4'd1 && downtime_dig_min_ten == 4'd0 && downtime_dig_min_one == 4'd0 && downtime_dig_hr == 4'd0 && state_process != 3'd5) ? 1 : 0; 
wire [21:0] note_div;
assign note_div = (state_process == 3'd1) ? 22'd151515 : 22'd191571; // 暫時
wire [15:0] volumn_max, volumn_min;
assign volumn_max = 16'b0011_1111_1111_1111;
assign volumn_min = 16'b1100_0000_0000_0000;
note_gen NG0(.clk(clk), .reset(voice_enable & reset), .note_div(note_div), .audio_left(audio_in_left), .audio_right(audio_in_right),
             .volumn_min(volumn_min), .volumn_max(volumn_max));     // 產生左右聲道音訊
             
// 音效輸出
speaker_ctrl SPC0(.reset(reset), .clk_small(audio_sck), .clk_big(audio_lrck), .audio_sdin(audio_sdin), .audio_left(audio_in_left), .audio_right(audio_in_right));

// VGA 輸出
wire valid;    
wire [9:0] h_cnt, v_cnt; // 640 x 480
vga_controller VGA0(.pclk(clk_25Mhz), .reset(reset), .hsync(hsync), .vsync(vsync), .valid(valid), .h_cnt(h_cnt), .v_cnt(v_cnt));
wire [16:0] pixel_addr;
mem_addr_gen mem_addr(.h_cnt(h_cnt), .v_cnt(v_cnt), .pixel_addr(pixel_addr));

wire [11:0] data, pixel_0;
wire [11:0] pixel_close_door, pixel_open_door, pixel_back;
wire [11:0] pixel_wash_0, pixel_wash_1, pixel_dry_0, pixel_dry_1;
wire [11:0] pixel_ssd_0, pixel_ssd_1, pixel_ssd_2, pixel_ssd_3, pixel_ssd_4, pixel_ssd_5, pixel_ssd_6, pixel_ssd_7, pixel_ssd_8, pixel_ssd_9;
wire [11:0] pixel_ssd_10, pixel_ssd_11, pixel_ssd_12, pixel_ssd_13, pixel_ssd_14;

blk_mem_gen_0 background(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_back)
);

blk_mem_gen_1 wash_0(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_wash_0)
);

blk_mem_gen_2 wash_1(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_wash_1)
);

blk_mem_gen_3 close_door(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_close_door)
);

blk_mem_gen_4 open_door(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_open_door)
);

blk_mem_gen_5 dry_0(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_dry_0)
);

blk_mem_gen_6 dry_1(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_dry_1)
);

// Digit memory

blk_mem_ssd_0 ssd_0(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_0)
);

blk_mem_ssd_1 ssd_1(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_1)
);

blk_mem_ssd_2 ssd_2(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_2)
);

blk_mem_ssd_3 ssd_3(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_3)
);

blk_mem_ssd_4 ssd_4(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_4)
);

blk_mem_ssd_5 ssd_5(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_5)
);

blk_mem_ssd_6 ssd_6(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_6)
);

blk_mem_ssd_7 ssd_7(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_7)
);

blk_mem_ssd_8 ssd_8(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_8)
);

blk_mem_ssd_9 ssd_9(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_9)
);

blk_mem_ssd_10 ssd_10(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_10)
);

blk_mem_ssd_11 ssd_11(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_11)
);

blk_mem_ssd_12 ssd_12(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_12)
);

blk_mem_ssd_13 ssd_13(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_13)
);

blk_mem_ssd_14 ssd_14(
    .clka(clk_25Mhz),
    .wea(0),
    .addra(pixel_addr),
    .dina(data[11:0]),
    .douta(pixel_ssd_14)
);

reg [3:0] vgaRed, vgaGreen, vgaBlue;
// Digit memory end
always @*
begin
    if (h_cnt > 320)
        if (v_cnt < 160)
            if (v_cnt > 99 && v_cnt < 140)
                if (h_cnt > 517 && h_cnt < 558)
                    case (LED_state)
                        2'b01:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hf00 : 12'h0;
                        2'b10:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h00f : 12'h0;
                        default:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                    endcase
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0; 
            else
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0; 
        else if (v_cnt > 160 && v_cnt < 320)
            if (v_cnt > 198 && v_cnt < 220)
                if (h_cnt > 380 && h_cnt < 420) // 模式3
                    if (LED_mode == 3'b100)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 480 && h_cnt < 520) // 溫度3
                    if (LED_tem == 3'b100)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 577 && h_cnt < 618) // 水量3
                    if (LED_water == 3'b100)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
            else if (v_cnt > 238 && v_cnt < 260)
                if (h_cnt > 380 && h_cnt < 420) // 模式2
                    if (LED_mode == 3'b010)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 480 && h_cnt < 520) // 溫度2
                    if (LED_tem == 3'b010)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 577 && h_cnt < 618) // 水量2
                    if (LED_water == 3'b010)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
            else if (v_cnt > 278 && v_cnt < 300)
                if (h_cnt > 380 && h_cnt < 420) // 模式1
                    if (LED_mode == 3'b001)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 480 && h_cnt < 520) // 溫度1
                    if (LED_tem == 3'b001)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else if (h_cnt > 577 && h_cnt < 618) // 水量1
                    if (LED_water == 3'b001)
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'h0f0 : 12'h0;
                    else
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
            else
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
        else
            if (v_cnt > 377 && v_cnt < 438)
                if (h_cnt > 370 && h_cnt < 410)
                    case (final_dig_3)
                    4'd0:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_0 : 12'h0;
                    4'd11:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_11 : 12'h0;
                    4'd12:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_12 : 12'h0;
                    4'd13:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_13 : 12'h0;
                    default:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
                    endcase
                else if (h_cnt > 430 && h_cnt < 470)
                    case (final_dig_2)
                    4'd0:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_0 : 12'h0;
                    4'd1:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_1 : 12'h0;
                    4'd2:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_2 : 12'h0;
                    4'd3:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_3 : 12'h0;
                    4'd4:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_4 : 12'h0;
                    4'd5:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_5 : 12'h0;
                    4'd6:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_6 : 12'h0;
                    4'd7:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_7 : 12'h0;
                    4'd8:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_8 : 12'h0;
                    4'd9:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_9 : 12'h0;
                    4'd10:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_10 : 12'h0;
                    4'd14:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_14 : 12'h0;
                    default:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
                    endcase
                else if (h_cnt > 490 && h_cnt < 530)
                    case (final_dig_1)
                    4'd0:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_0 : 12'h0;
                    4'd1:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_1 : 12'h0;
                    4'd2:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_2 : 12'h0;
                    4'd3:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_3 : 12'h0;
                    4'd4:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_4 : 12'h0;
                    4'd5:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_5 : 12'h0;
                    4'd6:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_6 : 12'h0;
                    4'd7:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_7 : 12'h0;
                    4'd8:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_8 : 12'h0;
                    4'd9:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_9 : 12'h0;
                    4'd10:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_10 : 12'h0;
                    4'd14:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_14 : 12'h0;
                    default:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
                    endcase
                else if (h_cnt > 530 && h_cnt < 550 || h_cnt > 590 && h_cnt < 610)
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
                else if (h_cnt > 550 && h_cnt < 590)
                    case (final_dig_0)
                    4'd0:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_0 : 12'h0;
                    4'd1:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_1 : 12'h0;
                    4'd2:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_2 : 12'h0;
                    4'd3:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_3 : 12'h0;
                    4'd4:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_4 : 12'h0;
                    4'd5:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_5 : 12'h0;
                    4'd6:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_6 : 12'h0;
                    4'd7:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_7 : 12'h0;
                    4'd8:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_8 : 12'h0;
                    4'd9:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_9 : 12'h0;
                    4'd10:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_10 : 12'h0;
                    4'd14:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_ssd_14 : 12'h0;
                    default:
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
                    endcase
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
        else
            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_back : 12'h0;
    else if (h_cnt > 80 && h_cnt < 240)
            if (v_cnt > 160 && v_cnt < 320)
                if (switch_door == 0)
                    case (state_process)
                    3'd0: // 等待
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_close_door : 12'h0;
                    3'd1: // 洗衣
                        case (clk_1hz)
                        1'd0:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_wash_0 : 12'h0;
                        1'd1:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_wash_1 : 12'h0;
                        default:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_wash_0 : 12'h0;
                        endcase
                    3'd2: // 暫停
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_close_door : 12'h0;
                    3'd3: // 烘衣
                        case (clk_1hz)
                        1'd0:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_dry_0 : 12'h0;
                        1'd1:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_dry_1 : 12'h0;
                        default:
                            {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_dry_0 : 12'h0;
                        endcase
                    3'd4: // 暫停 
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_close_door : 12'h0;
                    3'd5: // 準備 
                        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_close_door : 12'h0;
                    default: 
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;  
                    endcase
                else
                    {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? pixel_open_door : 12'h0;
            else
                {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
    else
        {vgaRed, vgaGreen, vgaBlue} = (valid == 1'b1) ? 12'hfff : 12'h0;
end

endmodule


