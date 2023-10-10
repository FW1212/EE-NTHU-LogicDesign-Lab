`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/07 19:44:33
// Design Name: 
// Module Name: big_year
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


module big_year(
    input [3:0] year_0,
    input [3:0] year_1,
    output big_year
    );
    
reg big_year;

always @(year_0 or year_1)
begin
    if (year_1[0] && year_0[1:0] == 2'b10)
        big_year <= 1;
    else if (~year_1[0] && year_0[1:0] == 2'b00)
        big_year <= 1;
    else
        big_year <= 0;
end

endmodule
