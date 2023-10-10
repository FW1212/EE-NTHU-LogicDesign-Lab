`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 23:21:20
// Design Name: 
// Module Name: ssd_refresh
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


module ssd_refresh(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output [3:0] o,
    output [3:0] ssd_ctrl,
    input [1:0] enable
    );

reg [3:0] o;
reg [3:0] ssd_ctrl;

always @(a or b or c or d or enable)
begin
    case(enable)
        2'b00:
        begin
            o[3:0] <= a[3:0];
            ssd_ctrl[3:0] <= 4'b0111;
        end
        2'b01:
        begin
            o[3:0] <= b[3:0];
            ssd_ctrl[3:0] <= 4'b1011;
        end
        2'b10:
        begin
            o[3:0] <= c[3:0];
            ssd_ctrl[3:0] <= 4'b1101;
        end
        2'b11:
        begin
            o[3:0] <= d[3:0];
            ssd_ctrl[3:0] <= 4'b1110;
        end
    endcase
end

endmodule
