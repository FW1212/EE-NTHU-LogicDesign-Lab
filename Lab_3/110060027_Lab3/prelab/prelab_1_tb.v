`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 18:13:13
// Design Name: 
// Module Name: prelab_1_tb
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


module prelab_1_tb();
    
reg clk, reset;
wire [3:0] o; 

prelab_1 U0(.clk(clk), .reset(reset), .q(o));

initial 
begin
    clk = 0; reset = 0;
    #10 reset = 1;
end

always
begin
    #10 clk = ~clk;
end

endmodule
