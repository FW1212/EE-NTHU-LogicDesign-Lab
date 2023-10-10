`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 18:01:06
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
    input in,
    input reset,
    output count_en,
    input clk
    );
   
reg count_en;
reg state, next_state;

always @(state or in)
begin
    case(state)
        0:
        begin
            if (in)
            begin
                next_state = 1;
                count_en = 1;
            end
            else
            begin
               next_state = 0;
               count_en = 0;
            end 
        end
        
        1:
        begin
            if (in)
            begin
                next_state = 0;
                count_en = 0;
            end
            else
            begin
                next_state = 1;
                count_en = 1;
            end
        end 
    endcase
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state = 0;
    else
        state <= next_state;
end
    
endmodule
