`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/26 17:44:43
// Design Name: 
// Module Name: experiment_2_design
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


module experiment_2_design(
    input [3:0] a,
    input [3:0] b,
    input m,
    output [3:0] s,
    output v
    );
    
wire [3:0] c;
wire [3:0] d;

assign d[0] = b[0] ^ m;
assign d[1] = b[1] ^ m;
assign d[2] = b[2] ^ m;
assign d[3] = b[3] ^ m;

assign s[0] = a[0] ^ d[0] ^ m;
assign c[0] = (a[0] * d[0]) | (m * (a[0] ^ d[0]));

assign s[1] = a[1] ^ d[1] ^ c[0];
assign c[1] = (a[1] * d[1]) | (c[0] * (a[1] ^ d[1]));

assign s[2] = a[2] ^ d[2] ^ c[1];
assign c[2] = (a[2] * d[2]) | (c[1] * (a[2] ^ d[2]));

assign s[3] = a[3] ^ d[3] ^ c[2];
assign c[3] = (a[3] * d[3]) | (c[2] * (a[3] ^ d[3]));

assign v = c[3] ^ c[2];
    
endmodule
