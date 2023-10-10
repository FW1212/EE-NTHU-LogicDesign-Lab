`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 16:18:21
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
    clk,
    state,
    reset,
    last_change
);
    output reg state;
    input reset, clk;
    input [8:0] last_change;

    reg next_state;

    always @*
        case (state)
            0: // ¤p¼g
                if (last_change == 9'h058)
                    next_state = 1;
                else
                    next_state = 0;
                    
           1: // ¤j¼g
                if (last_change == 9'h058)
                    next_state = 0;
                else
                    next_state = 1;
                    
            default:
                next_state = state;
        endcase
    
    always @(posedge clk or negedge reset)
        if (~reset)
            state <= 0; 
        else
            state <= next_state;
            
endmodule
