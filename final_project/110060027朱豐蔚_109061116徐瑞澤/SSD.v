`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 23:20:44
// Design Name: 
// Module Name: SSD
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


module SSD(
    input [3:0] i,
    output [7:0] D
    );
    

reg [7:0] D;
always @(i)
    case (i)
    4'd0 : D = 8'b00000011;
    4'd1 : D = 8'b10011111;
    4'd2 : D = 8'b00100101;
    4'd3 : D = 8'b00001101;
    4'd4 : D = 8'b10011001;
    4'd5 : D = 8'b01001001;
    4'd6 : D = 8'b01000001;
    4'd7 : D = 8'b00011111;
    4'd8 : D = 8'b00000001;
    4'd9 : D = 8'b00001001;
    4'd10: D = 8'b11111101; // ㄴ어퐑
    4'd11: D = 8'b01111110; // 쨁어퐑좥┳헕
    4'd12: D = 8'b11111100; // ㄴ어퐑좥┳헕
    4'd13: D = 8'b11101110; // 짾어퐑좥┳헕
    4'd14: D = 8'b11111111; // ��톞
    4'd15: D = 8'b01110001;
    default: D = 8'b11111110; //.
    endcase

endmodule

