`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 16:42:20
// Design Name: 
// Module Name: FSM_tem
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


module FSM_tem(
    input en,
    input button_op_L,
    input button_op_R,
    input clk,
    input reset,
    input KB_op_L,
    input KB_op_R,
    input SW_op_U_1, // 灿給瑍︾
    input SW_op_U_2, // е瑍
    input SW_op_U_3, // 玴︾
    output [2:0] state
    );
    
// 盢龄絃癟腹籔秙癟腹暗ㄖ    
wire turn_up, turn_down;
assign turn_up = (button_op_R | KB_op_R) & en;     // 璶 en ち传
assign turn_down = (button_op_L | KB_op_L) & en;     // 璶 en ち传

   
reg [2:0] state, next_state;
always @(state or turn_up or turn_down)
begin
    case(state)
        3'd1: // 蔼放
        if (turn_down)
            next_state = 3'd2;
        else 
            next_state = 3'd1;
            
        3'd2: // い放
        if(turn_up)
            next_state = 3'd1;
        else if (turn_down)
            next_state = 3'd4;
        else 
            next_state = 3'd2;
        
        3'd4: // 放
        if(turn_up)
            next_state = 3'd2;
        else 
            next_state = 3'd4;
        
        default: // 箇ň窾
            next_state = 3'd2;

    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 3'd2; // 箇砞い放
    else if(SW_op_U_1)
        state = 3'd1; // 灿給放
    else if(SW_op_U_2)
        state = 3'd2; // е瑍い放
    else if(SW_op_U_3)
        state = 3'd4; // 玴蔼放
    else
        state <= next_state;
end

endmodule
