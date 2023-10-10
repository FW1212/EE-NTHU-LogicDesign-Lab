`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 17:56:10
// Design Name: 
// Module Name: setting_hr_counter
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


module setting_hr_counter(
    output [3:0] value,
    input clk,
    input reset,
    input add,
    input sub,
    input SW_op_U_1, 
    input SW_op_U_2,
    input SW_op_U_3
    );
    
reg [3:0] value;
reg [3:0] value_tmp;
    
always @(value or add or sub)
begin
    if (value == 4'd9 && add)
        value_tmp = 4'd0;
    else if (value == 4'd0 && sub)
        value_tmp = 4'd9;
    else if (add)
        value_tmp = value + 4'd1;
    else if (sub)
        value_tmp = value - 4'd1;
    else
        value_tmp = value;
end
   
always @(posedge clk or negedge reset)
begin
    if(~reset)
        value <= 4'd0;
    else if(SW_op_U_1)
        value <= 4'd0;
    else if(SW_op_U_2)
        value <= 4'd0;
    else if(SW_op_U_3)
        value <= 4'd1;
    else
        value <= value_tmp;
end

endmodule
