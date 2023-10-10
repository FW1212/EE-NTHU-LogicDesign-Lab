`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 18:10:58
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk,
    input reset,
    input push,
    output push_debounced
    );
    
reg push_debounced;
reg [3:0] push_window;

always @(posedge clk or negedge reset)
begin
    if (~reset)
    begin
        push_window <= 4'd0000;
        push_debounced <= 0;
    end
    else
    begin
        push_window <= {push, push_window[3:1]};
        if (push_window[3:0] == 4'b1111)
        begin
            push_debounced = 1;
        end
        else
            push_debounced = 0;
        begin
        end
    end
end

endmodule
