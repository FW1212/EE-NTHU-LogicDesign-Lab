`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/25 14:26:34
// Design Name: 
// Module Name: FSM
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


module FSM(
    input in_stop,
    input in_lap,
    input in_lap_debounced,
    input reset,
    output count_reset,
    output count_en,
    output freeze_en,
    input clk
    );
   
reg count_en, freeze_en, count_reset;
reg [1:0] state, next_state;
reg [9:0] in_lap_window, in_lap_window_tmp;

always @*
begin 
    in_lap_window_tmp[9:0] <= {in_lap_debounced, in_lap_window[9:1]};
end

always @(state or in_stop or in_lap or in_lap_window)
begin
    case(state)
        2'b00:
        begin
            if (in_stop)
            begin
                next_state = 2'b10;
                count_en = 1;
                freeze_en = 0;
                count_reset = 0;
            end
            else if (~in_lap && in_lap_window == 10'b1111111111)
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 1;
            end
            else if (in_lap)
            begin
               next_state = 2'b01;
               count_en = 0;
               freeze_en = 1;
               count_reset = 0;
            end 
            else
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 0;
            end 
        end
        
        2'b10:
        begin
            if (in_stop)
            begin
                next_state = 2'b00;
                count_en = 0;
                freeze_en = 0;
                count_reset = 0;
            end
            else if (~in_lap && in_lap_window == 10'b1111111111)
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 1;
            end
            else if (in_lap)
            begin
               next_state = 2'b11;
               count_en = 1;
               freeze_en = 1;
               count_reset = 0;
            end 
            else
            begin
               next_state = 2'b10;
               count_en = 1;
               freeze_en = 0;
               count_reset = 0;
            end 
        end
        
        2'b11:
        begin
            if (in_stop)
            begin
                next_state = 2'b01;
                count_en = 0;
                freeze_en = 1;
                count_reset = 0;
            end
            else if (~in_lap && in_lap_window == 10'b1111111111)
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 1;
            end
            else if (in_lap)
            begin
               next_state = 2'b10;
               count_en = 1;
               freeze_en = 0;
               count_reset = 0;
            end 
            else
            begin
               next_state = 2'b11;
               count_en = 1;
               freeze_en = 1;
               count_reset = 0;
            end 
        end
        
        2'b01:
        begin
            if (in_stop)
            begin
                next_state = 2'b11;
                count_en = 1;
                freeze_en = 1;
                count_reset = 0;
            end
            else if (~in_lap && in_lap_window == 10'b1111111111)
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 1;
            end
            else if (in_lap)
            begin
               next_state = 2'b00;
               count_en = 0;
               freeze_en = 0;
               count_reset = 0;
            end 
            else
            begin
               next_state = 2'b01;
               count_en = 0;
               freeze_en = 1;
               count_reset = 0;
            end 
        end
    endcase
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        state = 2'b00;
        in_lap_window <= 10'd0;
    end
    else
    begin
        state <= next_state;
        in_lap_window <= in_lap_window_tmp;
    end
end
    
endmodule
