`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 22:17:15
// Design Name: 
// Module Name: FSM_display
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


module FSM_display(
    input button_op_U,
    input button_op_D,
    input KB_op_U,
    input KB_op_D,
    input reset,
    input clk,
    output reg [2:0] state
    );
    
// 將鍵盤訊號與按鈕訊號做合併
wire turn_up, turn_down;
assign turn_up = button_op_U | KB_op_U;
assign turn_down = button_op_D | KB_op_D;
    
reg [2:0] next_state;
always @(state or turn_up or turn_down)
begin
    case(state)
        3'd0: // 顯示倒數狀態
        if(turn_up)
            next_state = 3'd5;
        else if (turn_down)
            next_state = 3'd1;
        else 
            next_state = 3'd0;
            
        3'd1: // 顯示洗衣時間
        if(turn_up)
            next_state = 3'd0;
        else if (turn_down)
            next_state = 3'd2;
        else 
            next_state = 3'd1;
        
        3'd2: // 顯示水量
        if(turn_up)
            next_state = 3'd1;
        else if (turn_down)
            next_state = 3'd3;
        else 
            next_state = 3'd2;
       
        3'd3: // 顯示烘衣時間
        if(turn_up)
            next_state = 3'd2;
        else if (turn_down)
            next_state = 3'd4;
        else 
            next_state = 3'd3;
       
        3'd4: // 顯示溫度
        if(turn_up)
            next_state = 3'd3;
        else if (turn_down)
            next_state = 3'd5;
        else 
            next_state = 3'd4;
        
        3'd5: // 顯示排程時間
        if(turn_up)
            next_state = 3'd4;
        else if (turn_down)
            next_state = 3'd0;
        else 
            next_state = 3'd5;
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 3'd0;
    else
        state <= next_state;
end
    
endmodule
