`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 15:07:21
// Design Name: 
// Module Name: reserve_hr_counter
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


module reserve_hr_counter(
    output [3:0] value,
    input clk,
    input reset,
    input borrow,
    input deborrow,
    input button_debounced_L,
    input button_debounced_R,
    input KB_L,
    input KB_R
    );
    
reg [3:0] value;
reg [3:0] value_tmp;

// ³B²zªø«ö
reg [49:0] add_window, add_window_tmp;
reg [49:0] sub_window, sub_window_tmp;

always @*
begin 
    add_window_tmp[49:0] <= { ~(button_debounced_R | KB_R), add_window[49:1]};
    sub_window_tmp[49:0] <= { ~(button_debounced_L | KB_L), sub_window[49:1]};
end

reg add, sub;
always @*
begin 
    if(add_window == 50'd1 || borrow)
        add = 1;
    else 
        add = 0;
    if(sub_window == 50'd1 || deborrow)
        sub = 1;
    else
        sub = 0;
end
    
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
    begin
        value <= 4'd0;
        add_window <= {50{1'b1}};
        sub_window <= {50{1'b1}};
    end
    else
    begin
        value <= value_tmp;
        add_window <= add_window_tmp;
        sub_window <= sub_window_tmp;
    end
end

endmodule
