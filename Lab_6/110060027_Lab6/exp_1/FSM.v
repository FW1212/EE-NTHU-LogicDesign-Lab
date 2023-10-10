`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 14:30:17
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
    input clk,
    input reset,
    input sl_turn_up,
    input sl_turn_down,
    input sr_turn_up,
    input sr_turn_down,
    input bl_op,
    input br_op,
    input bm_op,
    input bl_debounced,
    input bm_debounced,
    output [4:0] state,
    output stw_count_en,
    output stw_freeze,
    output stw_reset
    );
    
reg [4:0] state, next_state;
reg [49:0] lap_window, lap_window_tmp;
reg [49:0] alarm_window, alarm_window_tmp;
reg stw_count_en, stw_freeze, stw_reset;

always @*
begin 
    lap_window_tmp[49:0] <= {~bl_debounced, lap_window[49:1]};
    alarm_window_tmp[49:0] <= {~bm_debounced, alarm_window[49:1]};
end

always @(state or sl_turn_up or sl_turn_down or sr_turn_up or sr_turn_down or lap_window or alarm_window or bl_op or br_op or bm_op)
begin
    case(state)
        5'b00000:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (alarm_window == 50'd0)
            begin
               next_state = 5'b00101;
            end
            else if (bm_op)
            begin
               next_state = 5'b00010;
            end 
            else
            begin
               next_state = 5'b00000;
            end 
        end

        5'b00010:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (alarm_window == 50'd0)
            begin
               next_state = 5'b00001;
            end
            else if (bm_op)
            begin
               next_state = 5'b00100;
            end 
            else
            begin
               next_state = 5'b00010;
            end 
        end
        
       5'b00100:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (alarm_window == 50'd0)
            begin
               next_state = 5'b00011;
            end
            else if (bm_op)
            begin
               next_state = 5'b00000;
            end 
            else
            begin
               next_state = 5'b00100;
            end 
        end
        
        5'b01000:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_down)
            begin
                next_state = 5'b00000;
            end
            else if (bm_op)
            begin
               next_state = 5'b01010;
            end 
            else
            begin
               next_state = 5'b01000;
            end 
        end
        
        5'b00001:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (~bm_debounced && alarm_window == 50'd0)
            begin
               next_state = 5'b00000;
            end
            else
            begin
               next_state = 5'b00001;
            end 
        end
        
        5'b00011:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (~bm_debounced && alarm_window == 50'd0)
            begin
               next_state = 5'b00010;
            end
            else
            begin
               next_state = 5'b00011;
            end 
        end
        
        5'b00101:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_up)
            begin
                next_state = 5'b01000;
            end
            else if (~bm_debounced && alarm_window == 50'd0)
            begin
               next_state = 5'b00100;
            end
            else
            begin
               next_state = 5'b00101;
            end 
        end

        5'b01010:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_down)
            begin
                next_state = 5'b00000;
            end
            else if (bm_op)
            begin
               next_state = 5'b01110;
            end 
            else
            begin
               next_state = 5'b01010;
            end 
        end

        5'b01110:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_down)
            begin
                next_state = 5'b00000;
            end
            else if (bm_op)
            begin
               next_state = 5'b01100;
            end 
            else
            begin
               next_state = 5'b01110;
            end 
        end

        5'b01100:
        begin
            if (sl_turn_up)
            begin
                next_state = 5'b10000;
            end
            else if (sr_turn_down)
            begin
                next_state = 5'b00000;
            end
            else if (bm_op)
            begin
                next_state = 5'b01000;
            end 
            else
            begin
                next_state = 5'b01100;
            end 
        end

        5'b10000:
        begin
            if (sr_turn_up)
            begin
                next_state = 5'b01000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (sl_turn_down)
            begin
                next_state = 5'b00000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (br_op)
            begin
                next_state = 5'b10010;
                stw_count_en = 1;
                stw_freeze = 0;
                stw_reset = 0;
            end 
            else if (~bl_debounced && lap_window == 50'd0)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 1;
            end
            else if (bl_op)
            begin
                next_state = 5'b10100;
                stw_count_en = 0;
                stw_freeze = 1;
                stw_reset = 0;
            end 
            else
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end 
        end
        
        5'b10010:
        begin
            if (sr_turn_up)
            begin
                next_state = 5'b01000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (sl_turn_down)
            begin
                next_state = 5'b00000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (br_op)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (~bl_debounced && lap_window == 50'd0)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 1;
            end 
            else if (bl_op)
            begin
                next_state = 5'b10110;
                stw_count_en = 1;
                stw_freeze = 1;
                stw_reset = 0;
            end 
            else
            begin
                next_state = 5'b10010;
                stw_count_en = 1;
                stw_freeze = 0;
                stw_reset = 0;
            end 
        end        
        
        5'b10110:
        begin
            if (sr_turn_up)
            begin
                next_state = 5'b01000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (sl_turn_down)
            begin
                next_state = 5'b00000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (br_op)
            begin
                next_state = 5'b10100;
                stw_count_en = 0;
                stw_freeze = 1;
                stw_reset = 0;
            end             
            else if (~bl_debounced && lap_window == 50'd0)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 1;
            end
            else if (bl_op)
            begin
                next_state = 5'b10010;
                stw_count_en = 1;
                stw_freeze = 0;
                stw_reset = 0;
            end 
            else
            begin
                next_state = 5'b10110;
                stw_count_en = 1;
                stw_freeze = 1;
                stw_reset = 0;
            end 
        end

        5'b10100:
        begin
            if (sr_turn_up)
            begin
                next_state = 5'b01000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (sl_turn_down)
            begin
                next_state = 5'b00000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end
            else if (br_op)
            begin
                next_state = 5'b10110;
                stw_count_en = 1;
                stw_freeze = 1;
                stw_reset = 0;
            end 
            else if (~bl_debounced && lap_window == 50'd0)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 1;
            end
            else if (bl_op)
            begin
                next_state = 5'b10000;
                stw_count_en = 0;
                stw_freeze = 0;
                stw_reset = 0;
            end 
            else
            begin
                next_state = 5'b10100;
                stw_count_en = 0;
                stw_freeze = 1;
                stw_reset = 0;
            end 
        end
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        state = 5'b00000;
        lap_window <= {50{1'b1}};
        alarm_window <= {50{1'b1}};
    end
    else
    begin
        state <= next_state;
        lap_window <= lap_window_tmp;
        alarm_window <= alarm_window_tmp;
    end
end

endmodule