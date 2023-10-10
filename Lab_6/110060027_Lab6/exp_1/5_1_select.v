`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 17:35:11
// Design Name: 
// Module Name: 5_1_select
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


module select_5to1(
    input [4:0] state,
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] stw,
    input [3:0] alarm,
    output [3:0] o
    );
    
reg [3:0] o;
    
always @*
begin
    case(state)
        5'b00000: o <= a;
        5'b00001: o <= alarm;
        5'b00010: o <= b;
        5'b00011: o <= alarm;
        5'b00100: o <= c;
        5'b00101: o <= alarm;
        
        5'b10000: o <= stw;
        5'b10010: o <= stw;
        5'b10110: o <= stw;
        5'b10100: o <= stw;
        
        5'b01000: o <= alarm;
        5'b01010: o <= a;
        5'b01110: o <= b;
        5'b01100: o <= c;
        
        default: o <= 4'd0;
    endcase 
end

endmodule
