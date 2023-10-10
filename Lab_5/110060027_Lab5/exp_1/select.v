`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 18:28:35
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
    output [3:0] ssd_ctrl,
    input enable
    );

reg [3:0] o;
reg [3:0] ssd_ctrl;

always @(a or b or enable)
begin
    if(enable)
    begin
        o[3:0] <= a[3:0];
        ssd_ctrl[3:0] <= 4'b1110;
    end
    else
    begin
        o[3:0] <= b[3:0];
        ssd_ctrl[3:0] <= 4'b1101;
    end
end

endmodule
