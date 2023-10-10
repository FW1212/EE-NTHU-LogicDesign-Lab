`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 17:34:04
// Design Name: 
// Module Name: exp_3
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


module exp_3(
    input [7:0] a,
    input [7:0] b,
    output [2:0] bulls,
    output [2:0] cows
    );
    
reg [2:0] bulls;
reg [2:0] cows;
    
always @(a or b)
begin
    if ((a[7:4] == b[7:4])&&(a[3:0] == b[3:0]))
        bulls = 3'b100;
    else if ((a[7:4] == b[7:4])||(a[3:0] == b[3:0]))
        bulls = 3'b010;
    else 
        bulls = 3'b001;
    if ((a[7:4] == b[3:0])&&(a[3:0] == b[7:4]))
        cows = 3'b100;
    else if ((a[7:4] == b[3:0])||(a[3:0] == b[7:4]))
        cows = 3'b010;
    else 
        cows = 3'b001;
end

endmodule
