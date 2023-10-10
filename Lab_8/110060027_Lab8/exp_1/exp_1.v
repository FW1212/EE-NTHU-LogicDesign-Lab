`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 13:07:29
// Design Name: 
// Module Name: exp_1
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


module exp_1(
    inout ps2_data,
    inout ps2_clk,
    input reset,
    input clk,
    output [3:0]ssd_ctrl,
    output [7:0]ssd_out
    );
    
assign ssd_ctrl[3:0] = 4'b1110;
    
wire [511:0] key_down;
wire [8:0]last_change;
wire key_valid;
KeyboardDecoder K0(.key_down(key_down), .last_change(last_change), .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), .rst(~reset), .clk(clk));


reg [7:0]ssd_out, ssd_out_next;
always @(last_change)
begin
    case(last_change)
    9'h05A: // enter
        ssd_out_next[7:0] <= 8'b11111111;
    9'h045: // 0
        ssd_out_next[7:0] <= 8'b00000011;
    9'h016: // 1
        ssd_out_next[7:0] <= 8'b10011111;
    9'h01E: // 2
        ssd_out_next[7:0] <= 8'b00100101;
    9'h026: // 3
        ssd_out_next[7:0] <= 8'b00001101;
    9'h025: // 4
        ssd_out_next[7:0] <= 8'b10011001;
    9'h02E: // 5
        ssd_out_next[7:0] <= 8'b01001001;
    9'h036: // 6
        ssd_out_next[7:0] <= 8'b01000001;
    9'h03D: // 7
        ssd_out_next[7:0] <= 8'b00011111;
    9'h03E: // 8
        ssd_out_next[7:0] <= 8'b00000001;
    9'h046: // 9
        ssd_out_next[7:0] <= 8'b00001001;
    9'h01C: // A
        ssd_out_next[7:0] <= 8'b01111111;
    9'h01B: // S
        ssd_out_next[7:0] <= 8'b11111101;
    9'h03A: // M
        ssd_out_next[7:0] <= 8'b11101111;
    default:
        ssd_out_next <= ssd_out;
    endcase 
end

always @(posedge clk or negedge reset)
begin
    if(~reset)
        ssd_out[7:0] <= 8'b11111111;
    else
        ssd_out <= ssd_out_next;
end

endmodule
