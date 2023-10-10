`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 16:53:47
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
    output state
    );
    
reg state, next_state;
always @*
begin
    case (state)
    0:
        if (last_change == 9'h05a)
            next_state = 1'b1;
        else
            next_state = 1'b0;
    1:
        if (last_change == 9'h05a)
            next_state = 1'b0;
        else
            next_state = 1'b1;
    default:
        next_state = 1'b0; 
    endcase
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        state <= 0;
    else 
        state <= next_state;
end

endmodule
