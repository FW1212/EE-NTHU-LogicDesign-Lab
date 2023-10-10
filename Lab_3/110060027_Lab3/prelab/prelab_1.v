`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 18:12:26
// Design Name: 
// Module Name: prelab_1
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


module prelab_1(
    input clk,
    output [3:0] q,
    input reset
    );
    
reg [3:0] q;
reg [3:0] next;

always @(q)
begin
    next = q + 4'd1;
end

always @(posedge clk or negedge reset)
begin
    if (~reset)
    begin
        q = 4'd0;
    end
    else 
        q = next;
end

endmodule
