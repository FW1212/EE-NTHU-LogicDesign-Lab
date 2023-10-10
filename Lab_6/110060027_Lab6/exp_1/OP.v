`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 18:18:58
// Design Name: 
// Module Name: OP
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


module OP(
    input clk,
    input reset,
    input push_debounced,
    output push_op
    );
    
reg push_op_next, push_debounced_delay, push_op;

always @*
begin
    push_op_next <= push_debounced & ~push_debounced_delay;
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        push_op <= 0;
        push_debounced_delay <= 0;
    end
    else
    begin
        push_op <= push_op_next;
        push_debounced_delay <= push_debounced;
    end
end
    
endmodule
