`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 16:48:11
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
    input in_start,
    input in_pause,
    input reset,
    output count_reset,
    output count_en,
    input clk
    );
   
reg count_en, count_reset;
reg [1:0] state, next_state;

always @(state or in_start or in_pause)
begin
    case(state)
        2'b00:
        begin
            if (in_start)
            begin
                next_state = 2'b01;
                count_en = 1;
                count_reset = 0;
            end
            else
            begin
                next_state = 2'b00;
                count_en = 0;
                count_reset = 1;
            end
        end
        
        2'b01:
        begin
            if (in_start)
            begin
                next_state = 2'b00;
                count_en = 0;
                count_reset = 1;
            end
            else if (in_pause)
            begin
                next_state = 2'b10;
                count_en = 0;
                count_reset = 0;
            end
            else
            begin
                next_state = 2'b01;
                count_en = 1;
                count_reset = 0;
            end
        end
        
        2'b10:
        begin
            if (in_start)
            begin
                next_state = 2'b00;
                count_en = 0;
                count_reset = 1;
            end
            else if (in_pause)
            begin
                next_state = 2'b01;
                count_en = 1;
                count_reset = 0;
            end
            else
            begin
                next_state = 2'b10;
                count_en = 0;
                count_reset = 0;
            end
        end
    endcase
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 2'b00;
    else
        state <= next_state;
end
    
endmodule
