`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 17:25:51
// Design Name: 
// Module Name: exp_2_tb
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


module exp_2_tb();

reg [3:0] I;
wire [3:0] o;
wire [7:0] O;

exp_2 U0(.i(I), .d(o), .D(O));
             
initial
begin
I = 4'd0;
#10 I = 4'd1;
#10 I = 4'd2;
#10 I = 4'd3;
#10 I = 4'd4;
#10 I = 4'd5;
#10 I = 4'd6;
#10 I = 4'd7;
#10 I = 4'd8;
#10 I = 4'd9;
#10 I = 4'd10;
#10 I = 4'd11;
#10 I = 4'd12;
#10 I = 4'd13;
#10 I = 4'd14;
#10 I = 4'd15;
end

endmodule
