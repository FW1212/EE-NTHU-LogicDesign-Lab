`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 15:44:05
// Design Name: 
// Module Name: FSM_process
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


module FSM_process(
    input button_op_M,
    input button_debounced_M,
    input KB_op_enter,
    input KB_enter, 
    input SW_op_U_door,  // �}��
    input switch_door,  // �������A
    input downtime_complete_op,  // �����˼�
    input reserve_complete_op,  // �����w��
    input reset,
    input clk,
    output [2:0] state,
    output downtime_reset_2,
    
    output [2:0] LED_water, // ��X���q
    output [2:0] LED_tem, // ��X�ū�
    input [2:0] state_water, // ���J���q
    input [2:0] state_tem, // ���J�ū�

    input [3:0] washtime_dig_min_ten,
    input [3:0] washtime_dig_min_one,
    input [3:0] washtime_dig_hr,
    input [3:0] drytime_dig_min_ten,
    input [3:0] drytime_dig_min_one,
    input [3:0] drytime_dig_hr,
    output [3:0] washtime_downdig_min_ten,
    output [3:0] washtime_downdig_min_one,
    output [3:0] washtime_downdig_hr,
    output [3:0] drytime_downdig_min_ten,
    output [3:0] drytime_downdig_min_one,
    output [3:0] drytime_downdig_hr
    ); 
    
// �N��L�T���P���s�T�����X��
wire activate;
assign activate = button_op_M | KB_op_enter;

reg [49:0] reset_window, reset_window_tmp;
always @*
begin 
    reset_window_tmp[49:0] <= { ~(button_debounced_M | KB_enter), reset_window[49:1]};
end

assign downtime_reset_2 = (state == 3'd0) ? 0 : 1;
    
reg [2:0] state, next_state;
reg [2:0] LED_water, LED_tem;
reg [3:0] washtime_downdig_min_ten, washtime_downdig_min_one, washtime_downdig_hr;
reg [3:0] drytime_downdig_min_ten, drytime_downdig_min_one, drytime_downdig_hr;

always @(state or activate or SW_op_U_door or switch_door or downtime_complete_op or reserve_complete_op or reset_window)
begin
    case(state)
        3'd0: // �_�l���A
        if(activate && ~switch_door) // �������A�~�i�}�l
        begin 
            next_state = 3'd5;
            LED_water = state_water;
            LED_tem = state_tem;
            washtime_downdig_min_ten = washtime_dig_min_ten;
            washtime_downdig_min_one = washtime_dig_min_one;
            washtime_downdig_hr = washtime_dig_hr;
            drytime_downdig_min_ten = drytime_dig_min_ten;
            drytime_downdig_min_one = drytime_dig_min_one;
            drytime_downdig_hr = drytime_dig_hr;
        end
        else if (reserve_complete_op && ~switch_door) // !!!!!!!!! ����n�[�J�w�ƱҰʥ\��
        begin 
            next_state = 3'd5;
            LED_water = state_water;
            LED_tem = state_tem;
            washtime_downdig_min_ten = washtime_dig_min_ten;
            washtime_downdig_min_one = washtime_dig_min_one;
            washtime_downdig_hr = washtime_dig_hr;
            drytime_downdig_min_ten = drytime_dig_min_ten;
            drytime_downdig_min_one = drytime_dig_min_one;
            drytime_downdig_hr = drytime_dig_hr;
        end
        else 
            next_state = 3'd0;
            
        3'd1: // �~�窬�A
        if(reset_window == 50'd1)
            next_state = 3'd0;
        else if(SW_op_U_door || activate) // �~��ɶ}���n�Ȱ�
            next_state = 3'd2;
        else if (downtime_complete_op) 
            next_state = 3'd3;
        else 
            next_state = 3'd1;
        
        3'd2: // �~��Ȱ����A
        if(reset_window == 50'd1)
            next_state = 3'd0;
        else if(activate && ~switch_door)  // �������A�~�i���s�}�l
            next_state = 3'd1;
        else 
            next_state = 3'd2;
       
        3'd3: // �M�窬�A
        if(reset_window == 50'd1)
            next_state = 3'd0;
        else if(SW_op_U_door || activate)  // �M��ɶ}���n�Ȱ�
            next_state = 3'd4;
        else if (downtime_complete_op) 
            next_state = 3'd0;
        else 
            next_state = 3'd3;
       
        3'd4: // �M��Ȱ����A
        if(reset_window == 50'd1)
            next_state = 3'd0;
        else if(activate && ~switch_door)  // �������A�~�i���s�}�l
            next_state = 3'd3;
        else 
            next_state = 3'd4;
            
        3'd5: // �ǳƶ}�l
        if(downtime_complete_op)
            next_state = 3'd1;
        else 
            next_state = 3'd5;
        
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        state = 3'd0;
        reset_window <= {50{1'b1}};
    end
    else
    begin
        state <= next_state;
        reset_window <= reset_window_tmp;
    end
end
    
endmodule

