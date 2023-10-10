`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 14:09:20
// Design Name: 
// Module Name: fre_divider_50M_en
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


module fre_divider_50M_en(
    input clk,
    output clk_new,
    input reset,
    output [1:0] enable
    );
    
reg clk_new;
reg [26:0] count_n;
reg [26:0] count_p;

assign enable[1:0] = count_n[17:16];
        
always @(count_p)
begin
    count_n = count_p + 27'd1;
end 
       
always @(posedge clk or negedge reset)
begin
    if (~reset)
    begin
        count_p <= 27'd0;
        clk_new <= 0;
    end
    else
    begin
        count_p <= count_n;
        if (count_p == 27'd50000000)
        begin
            count_p <= 27'd0;
            clk_new <= ~clk_new;
        end
    end
end
  
endmodule
