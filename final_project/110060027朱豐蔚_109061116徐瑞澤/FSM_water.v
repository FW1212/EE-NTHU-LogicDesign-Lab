`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 16:12:54
// Design Name: 
// Module Name: FSM_water
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


module FSM_water(
    input en,
    input button_op_L,
    input button_op_R,
    input clk,
    input reset,
    input KB_op_L,
    input KB_op_R,
    input SW_op_U_1, // 細緻洗衣
    input SW_op_U_2, // 快洗
    input SW_op_U_3, // 厚重衣物
    output [2:0] state
    );
    
// 將鍵盤訊號與按鈕訊號做合併    
wire turn_up, turn_down;
assign turn_up = (button_op_R | KB_op_R) & en;     // 要 en 才可切換
assign turn_down = (button_op_L | KB_op_L) & en;     // 要 en 才可切換

   
reg [2:0] state, next_state;
always @(state or turn_up or turn_down)
begin
    case(state)
        3'd1: // 多水
        if (turn_down)
            next_state = 3'd2;
        else 
            next_state = 3'd1;
            
        3'd2: // 中水
        if(turn_up)
            next_state = 3'd1;
        else if (turn_down)
            next_state = 3'd4;
        else 
            next_state = 3'd2;
        
        3'd4: // 少水
        if(turn_up)
            next_state = 3'd2;
        else 
            next_state = 3'd4;
        
        default: // 預防萬一
            next_state = 3'd2;

    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 3'd2; // 預設中水
    else if(SW_op_U_1)
        state = 3'd1; // 細緻少水
    else if(SW_op_U_2)
        state = 3'd2; // 快洗中水
    else if(SW_op_U_3)
        state = 3'd4; // 厚重多水
    else
        state <= next_state;
end

endmodule
