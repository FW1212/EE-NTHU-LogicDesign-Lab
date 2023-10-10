`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/27 00:21:56
// Design Name: 
// Module Name: SMUX_final_digit
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


module SMUX_final_digit(
    output [3:0] final_dig_0,
    output [3:0] final_dig_1,
    output [3:0] final_dig_2,
    output [3:0] final_dig_3,
    input [2:0] state_display,
    input [2:0] state_water,
    input [2:0] state_tem,
    input [3:0] washtime_dig_min_ten, 
    input [3:0] washtime_dig_min_one, 
    input [3:0] washtime_dig_hr,
    input [3:0] drytime_dig_min_ten, 
    input [3:0] drytime_dig_min_one, 
    input [3:0] drytime_dig_hr,
    input [3:0] downtime_dig_min_ten, 
    input [3:0] downtime_dig_min_one, 
    input [3:0] downtime_dig_hr,
    input [3:0] downtime_dig_sec_ten, 
    input [3:0] downtime_dig_sec_one, 
    input [3:0] reservetime_dig_min_ten, 
    input [3:0] reservetime_dig_min_one, 
    input [3:0] reservetime_dig_hr
    ); 
    
reg [3:0] final_dig_0, final_dig_1, final_dig_2, final_dig_3;    
    
always @*
begin
    case(state_display)
        3'd0: // 顯示倒數狀態
        begin
            final_dig_0 = downtime_dig_min_one;
            final_dig_1 = downtime_dig_min_ten;
            final_dig_2 = downtime_dig_hr;
            final_dig_3 = 4'd0;     // 之後要改成 0
        end
        3'd1: // 顯示洗衣時間
        begin
            final_dig_0 = washtime_dig_min_one;
            final_dig_1 = washtime_dig_min_ten;
            final_dig_2 = washtime_dig_hr;
            final_dig_3 = 4'd11;
        end
        3'd2: // 顯示水量
        begin
            final_dig_0 = (state_water[0]) ? 4'd10 : 4'd14;
            final_dig_1 = (state_water[1]) ? 4'd10 : 4'd14;
            final_dig_2 = (state_water[2]) ? 4'd10 : 4'd14;
            final_dig_3 = 4'd11;
        end
        3'd3: // 顯示烘衣時間
        begin
            final_dig_0 = drytime_dig_min_one;
            final_dig_1 = drytime_dig_min_ten;
            final_dig_2 = drytime_dig_hr;
            final_dig_3 = 4'd12;
        end
        3'd4: // 顯示溫度
        begin
            final_dig_0 = (state_tem[0]) ? 4'd10 : 4'd14;
            final_dig_1 = (state_tem[1]) ? 4'd10 : 4'd14;
            final_dig_2 = (state_tem[2]) ? 4'd10 : 4'd14;
            final_dig_3 = 4'd12;
        end
        3'd5: // 顯示排程時間
        begin
            final_dig_0 = reservetime_dig_min_one;
            final_dig_1 = reservetime_dig_min_ten;
            final_dig_2 = reservetime_dig_hr;
            final_dig_3 = 4'd13;
        end
        default:
        begin
            final_dig_0 = 4'd10;
            final_dig_1 = 4'd10;
            final_dig_2 = 4'd10;
            final_dig_3 = 4'd10;
        end
    endcase  
end
    
endmodule
