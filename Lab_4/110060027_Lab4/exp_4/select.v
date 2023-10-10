`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:43:48
// Design Name: 
// Module Name: select
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


module select(
    input [3:0] a,
    input [3:0] b,
    output [3:0] o,
    output [1:0] ssd_ctrl,
    input enable
    );

reg [3:0] o;
reg [1:0] ssd_ctrl;

always @(a or b or enable)
begin
    if(enable)
    begin
        o[3:0] <= a[3:0];
        ssd_ctrl[1:0] <= 2'b01;
    end
    else
    begin
        o[3:0] <= b[3:0];
        ssd_ctrl[1:0] <= 2'b10;
    end
end

endmodule
