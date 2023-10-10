`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 17:57:18
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
    input op_U,
    input op_D,
    output [3:0] state,
    input reset
    );
    
reg [3:0] state, state_next;

always @(state or op_D or op_U)
begin
    case(state)
        4'd0:
        begin 
            if(op_U)
                state_next <= 4'd1;
            else 
                state_next <= 4'd0;
        end
        
        4'd1:
        begin 
            if(op_U)
                state_next <= 4'd2;
            else if (op_D)
                state_next <= 4'd0;
            else 
                state_next <= 4'd1;
        end
        
        4'd2:
        begin 
            if(op_U)
                state_next <= 4'd3;
            else if (op_D)
                state_next <= 4'd1;
            else 
                state_next <= 4'd2;
        end
        
        4'd3:
        begin 
            if(op_U)
                state_next <= 4'd4;
            else if (op_D)
                state_next <= 4'd2;
            else 
                state_next <= 4'd3;
        end
        
        4'd4:
        begin 
            if(op_U)
                state_next <= 4'd5;
            else if (op_D)
                state_next <= 4'd3;
            else 
                state_next <= 4'd4;
        end
        
        4'd5:
        begin 
            if(op_U)
                state_next <= 4'd6;
            else if (op_D)
                state_next <= 4'd4;
            else 
                state_next <= 4'd5;
        end
        
        4'd6:
        begin 
            if(op_U)
                state_next <= 4'd7;
            else if (op_D)
                state_next <= 4'd5;
            else 
                state_next <= 4'd6;
        end
        
        4'd7:
        begin 
            if(op_U)
                state_next <= 4'd8;
            else if (op_D)
                state_next <= 4'd6;
            else 
                state_next <= 4'd7;
        end
        
        4'd8:
        begin 
            if(op_U)
                state_next <= 4'd9;
            else if (op_D)
                state_next <= 4'd7;
            else 
                state_next <= 4'd8;
        end
        
        4'd9:
        begin 
            if(op_U)
                state_next <= 4'd10;
            else if (op_D)
                state_next <= 4'd8;
            else 
                state_next <= 4'd9;
        end
        
        4'd10:
        begin 
            if(op_U)
                state_next <= 4'd11;
            else if (op_D)
                state_next <= 4'd9;
            else 
                state_next <= 4'd10;
        end
        
        4'd11:
        begin 
            if(op_U)
                state_next <= 4'd12;
            else if (op_D)
                state_next <= 4'd10;
            else 
                state_next <= 4'd11;
        end
        
        4'd12:
        begin 
            if(op_U)
                state_next <= 4'd13;
            else if (op_D)
                state_next <= 4'd11;
            else 
                state_next <= 4'd12;
        end
        
        4'd13:
        begin 
            if(op_U)
                state_next <= 4'd14;
            else if (op_D)
                state_next <= 4'd12;
            else 
                state_next <= 4'd13;
        end
        
        4'd14:
        begin 
            if(op_U)
                state_next <= 4'd15;
            else if (op_D)
                state_next <= 4'd13;
            else 
                state_next <= 4'd14;
        end
        
        4'd15:
        begin 
            if (op_D)
                state_next <= 4'd14;
            else 
                state_next <= 4'd15;
        end
    
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
    begin
        state <= 4'd7;
    end
    else
    begin
        state <= state_next;
    end
end
    
endmodule
