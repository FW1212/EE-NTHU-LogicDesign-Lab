`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/24 22:10:51
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clk,
    input reset,
    input [8:0] last_change,
    output [2:0] state,
    output [1:0] intro
    );
    
reg [2:0] state, next_state;
reg [1:0] intro, next_intro;
always @*
begin
    case (state)
    3'b000: //  第一位
        if (last_change == 9'h070 ||last_change == 9'h069 ||
            last_change == 9'h072 ||last_change == 9'h07A ||
            last_change == 9'h06B ||last_change == 9'h073 ||
            last_change == 9'h074 ||last_change == 9'h06C ||
            last_change == 9'h075 ||last_change == 9'h07D )
        begin
            next_state[2:0] = 3'b001;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b000;
            next_intro = intro;
        end
        
    3'b001: //  第二位
        if (last_change == 9'h070 ||last_change == 9'h069 ||
            last_change == 9'h072 ||last_change == 9'h07A ||
            last_change == 9'h06B ||last_change == 9'h073 ||
            last_change == 9'h074 ||last_change == 9'h06C ||
            last_change == 9'h075 ||last_change == 9'h07D )
        begin
            next_state[2:0] = 3'b010;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b001;
            next_intro = intro;
        end
        
    3'b010: //  操作
        if (last_change == 9'h079)
        begin
            next_state[2:0] = 3'b011;
            next_intro[1:0] = 2'b00;
        end
        else if (last_change == 9'h07B)
        begin
            next_state[2:0] = 3'b011;
            next_intro[1:0] = 2'b01;
        end
        else if (last_change == 9'h07C)
        begin
            next_state[2:0] = 3'b011;
            next_intro[1:0] = 2'b10;
        end
        else
        begin
            next_state[2:0] = 3'b010;
            next_intro = intro;
        end
        
    3'b011: //  第三位
        if (last_change == 9'h070 ||last_change == 9'h069 ||
            last_change == 9'h072 ||last_change == 9'h07A ||
            last_change == 9'h06B ||last_change == 9'h073 ||
            last_change == 9'h074 ||last_change == 9'h06C ||
            last_change == 9'h075 ||last_change == 9'h07D )
        begin
            next_state[2:0] = 3'b100;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b011;
            next_intro = intro;
        end
        
    3'b100: //  第四位
        if (last_change == 9'h070 ||last_change == 9'h069 ||
            last_change == 9'h072 ||last_change == 9'h07A ||
            last_change == 9'h06B ||last_change == 9'h073 ||
            last_change == 9'h074 ||last_change == 9'h06C ||
            last_change == 9'h075 ||last_change == 9'h07D )
        begin
            next_state[2:0] = 3'b101;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b100;
            next_intro = intro;
        end
        
    3'b101: //  等待
        if (last_change == 9'h05A)
        begin
            next_state[2:0] = 3'b110;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b101;
            next_intro = intro;
        end
        
    3'b110: //  展示
        if (last_change == 9'h05A)
        begin
            next_state[2:0] = 3'b000;
            next_intro = intro;
        end
        else
        begin
            next_state[2:0] = 3'b110;
            next_intro = intro;
        end
        
    default:
        begin
            next_state = state;
            next_intro = intro;
        end
        
    endcase
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        state[2:0] <= 3'b000;
        intro[1:0] <= 2'b00;
    end
    else 
    begin
        state <= next_state;
        intro <= next_intro;
    end
end

endmodule
