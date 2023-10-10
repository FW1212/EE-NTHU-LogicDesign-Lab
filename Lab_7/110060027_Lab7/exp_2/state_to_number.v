`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/14 18:15:30
// Design Name: 
// Module Name: state_to_number
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


module state_to_number(
    input [3:0] state,
    output [3:0] dig_1,
    output [3:0] dig_0,
    output [15:0] volumn_max,
    output [15:0] volumn_min
    );
    
reg [3:0] dig_1, dig_0;
reg [15:0] volumn_max, volumn_min;

always @(state)
begin 
    case(state)
        4'd0:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd1;
            volumn_max = 16'b0111_1111_1111_1111;
            volumn_min = 16'b1000_0000_0000_0000;
        end
        
        4'd1:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd2;
            volumn_max = 16'b0111_0111_1111_1111;
            volumn_min = 16'b1000_1000_0000_0000;
        end
        
        4'd2:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd3;
            volumn_max = 16'b0110_1111_1111_1111;
            volumn_min = 16'b1001_0000_0000_0000;
        end
        
        4'd3:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd4;
            volumn_max = 16'b0110_0111_1111_1111;
            volumn_min = 16'b1001_1000_0000_0000;
        end
        
        4'd4:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd5;
            volumn_max = 16'b0101_1111_1111_1111;
            volumn_min = 16'b1010_0000_0000_0000;
        end
        
        4'd5:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd6;
            volumn_max = 16'b0101_0111_1111_1111;
            volumn_min = 16'b1010_1000_0000_0000;
        end
        
        4'd6:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd7;
            volumn_max = 16'b0100_1111_1111_1111;
            volumn_min = 16'b1011_0000_0000_0000;
        end
        
        4'd7:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd8;
            volumn_max = 16'b0100_0111_1111_1111;
            volumn_min = 16'b1011_1000_0000_0000;
        end
        
        4'd8:
        begin
            dig_1 = 4'd0;
            dig_0 = 4'd9;
            volumn_max = 16'b0011_1111_1111_1111;
            volumn_min = 16'b1100_0000_0000_0000;
        end
        
        4'd9:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd0;
            volumn_max = 16'b0011_0111_1111_1111;
            volumn_min = 16'b1100_1000_0000_0000;
        end
        
        4'd10:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd1;
            volumn_max = 16'b0010_1111_1111_1111;
            volumn_min = 16'b1101_0000_0000_0000;
        end
        
        4'd11:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd2;
            volumn_max = 16'b0010_0111_1111_1111;
            volumn_min = 16'b1101_1000_0000_0000;
        end
        
        4'd12:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd3;
            volumn_max = 16'b0001_1111_1111_1111;
            volumn_min = 16'b1110_0000_0000_0000;
        end
        
        4'd13:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd4;
            volumn_max = 16'b0001_0111_1111_1111;
            volumn_min = 16'b1110_1000_0000_0000;
        end
        
        4'd14:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd5;
            volumn_max = 16'b0000_1111_1111_1111;
            volumn_min = 16'b1111_0000_0000_0000;
        end
        
        4'd15:
        begin
            dig_1 = 4'd1;
            dig_0 = 4'd6;
            volumn_max = 16'b0000_0111_1111_1111;
            volumn_min = 16'b1111_1000_0000_0000;
        end
    endcase 
end
 
endmodule
