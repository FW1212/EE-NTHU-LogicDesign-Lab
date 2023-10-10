`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 16:32:51
// Design Name: 
// Module Name: switch_op
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


module switch_op(
    input switch,
    input clk,
    input reset,
    output turn_up,
    output turn_down
    );
    
reg turn_up_next, turn_up;
reg turn_down_next, turn_down;
reg switch_delay;

always @*
begin
    turn_up_next <= switch & ~switch_delay;
    turn_down_next <= ~switch & switch_delay;
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        turn_up <= 0;
        turn_down <= 0;
        switch_delay <= 0;
    end
    else
    begin
        turn_up <= turn_up_next;
        turn_down <= turn_down_next;
        switch_delay <= switch;
    end
end
    
endmodule
