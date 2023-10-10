`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/07 19:29:35
// Design Name: 
// Module Name: how_many_day
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


module how_many_day(
    input [3:0] month_0,
    input [3:0] month_1,
    output [3:0] day_0,
    output [3:0] day_1,
    input big_year
    );
    
reg [3:0] day_0, day_1;
reg [8:0] month_total;

always @(month_0 or month_1)
begin
    month_total <= {month_1, month_0};
end

always @(month_total or big_year)
begin 
    case(month_total)
        8'b00000001: // 1
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00000011: // 3
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00000101: // 5
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00000111: // 7 
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00001000: // 8
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00010000: // 10
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        8'b00010010: // 12
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
        
        8'b00000100: // 4
        begin
            day_0 <= 4'd1;
            day_1 <= 4'd3;
        end
        8'b00000110: // 6
        begin
            day_0 <= 4'd1;
            day_1 <= 4'd3;
        end
        8'b00001001: // 9
        begin
            day_0 <= 4'd1;
            day_1 <= 4'd3;
        end
        8'b00010001: // 11
        begin
            day_0 <= 4'd1;
            day_1 <= 4'd3;
        end
        
        8'b00000010: // 2
        begin
            if(big_year)
            begin
                day_0 <= 4'd0;
                day_1 <= 4'd3;
            end
            else
            begin
                day_0 <= 4'd9;
                day_1 <= 4'd2;
            end
        end
        
        default: // ¨ä¥L
        begin
            day_0 <= 4'd2;
            day_1 <= 4'd3;
        end
    endcase 
end
    
endmodule
