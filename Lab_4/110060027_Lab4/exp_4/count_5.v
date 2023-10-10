`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/17 17:27:51
// Design Name: 
// Module Name: count_5
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


module count_5(
    input clk,
    output clk_new,
    input reset
    );
    
reg clk_new;
reg [2:0] count;
reg [2:0] count_tmp;

always @(count)
begin
    count_tmp[2:0] <= count[2:0] + 3'd1;
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        count[2:0] <= 3'd0;
        clk_new <= 1;
    end
    else
    begin
        count[2:0] <= count_tmp[2:0];
        if (count[2:0] == 3'd4)
        begin
            count[2:0] <= 3'd0;
            clk_new <= ~clk_new;
        end
    end
end

endmodule
