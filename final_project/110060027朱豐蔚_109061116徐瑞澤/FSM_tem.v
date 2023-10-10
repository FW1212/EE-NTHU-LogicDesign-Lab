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
    input SW_op_U_1, // �ӽo�~��
    input SW_op_U_2, // �֬~
    input SW_op_U_3, // �p���窫
    output [2:0] state
    );
    
// �N��L�T���P���s�T�����X��    
wire turn_up, turn_down;
assign turn_up = (button_op_R | KB_op_R) & en;     // �n en �~�i����
assign turn_down = (button_op_L | KB_op_L) & en;     // �n en �~�i����

   
reg [2:0] state, next_state;
always @(state or turn_up or turn_down)
begin
    case(state)
        3'd1: // ����
        if (turn_down)
            next_state = 3'd2;
        else 
            next_state = 3'd1;
            
        3'd2: // ����
        if(turn_up)
            next_state = 3'd1;
        else if (turn_down)
            next_state = 3'd4;
        else 
            next_state = 3'd2;
        
        3'd4: // �C��
        if(turn_up)
            next_state = 3'd2;
        else 
            next_state = 3'd4;
        
        default: // �w���U�@
            next_state = 3'd2;

    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 3'd2; // �w�]����
    else if(SW_op_U_1)
        state = 3'd1; // �ӽo�C��
    else if(SW_op_U_2)
        state = 3'd2; // �֬~����
    else if(SW_op_U_3)
        state = 3'd4; // �p������
    else
        state <= next_state;
end

endmodule
