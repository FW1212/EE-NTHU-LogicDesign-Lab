`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 16:12:36
// Design Name: 
// Module Name: exp_4
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


module exp_4(
    inout ps2_data,
    inout ps2_clk,
    input reset,
    input clk,
    output [6:0] led,
    output state
    );

wire [511:0] key_down;
wire [8:0] last_change;
wire key_valid;
wire valid_singal;
KeyboardDecoder K0(.key_down(key_down), .last_change(last_change), .key_valid(key_valid), .PS2_DATA(ps2_data), .PS2_CLK(ps2_clk), .rst(~reset), .clk(clk));
assign valid_singal = key_down[last_change];

FSM FSM(.clk(valid_singal), .state(state), .reset(reset), .last_change(last_change));

wire capital;
assign capital = state ^ key_down[9'h012];

reg [6:0] led;
always @*
begin
    case(capital)
        0:
        begin
            if(key_down[9'h01C])
                led[6:0] <= 7'd97; 
            else if(key_down[9'h032])
                led[6:0] <= 7'd98; 
            else if(key_down[9'h021])
                led[6:0] <= 7'd99; 
            else if(key_down[9'h023])
                led[6:0] <= 7'd100; 
            else if(key_down[9'h024])
                led[6:0] <= 7'd101; 
            else if(key_down[9'h02B])
                led[6:0] <= 7'd102; 
            else if(key_down[9'h034])
                led[6:0] <= 7'd103; 
            else if(key_down[9'h033])
                led[6:0] <= 7'd104; 
            else if(key_down[9'h043])
                led[6:0] <= 7'd105; 
            else if(key_down[9'h03B])
                led[6:0] <= 7'd106; 
            else if(key_down[9'h042])
                led[6:0] <= 7'd107; 
            else if(key_down[9'h04B])
                led[6:0] <= 7'd108; 
            else if(key_down[9'h03A])
                led[6:0] <= 7'd109; 
            else if(key_down[9'h031])
                led[6:0] <= 7'd110; 
            else if(key_down[9'h044])
                led[6:0] <= 7'd111; 
            else if(key_down[9'h04D])
                led[6:0] <= 7'd112; 
            else if(key_down[9'h015])
                led[6:0] <= 7'd113; 
            else if(key_down[9'h02D])
                led[6:0] <= 7'd114; 
            else if(key_down[9'h01B])
                led[6:0] <= 7'd115; 
            else if(key_down[9'h02C])
                led[6:0] <= 7'd116; 
            else if(key_down[9'h03C])
                led[6:0] <= 7'd117; 
            else if(key_down[9'h02A])
                led[6:0] <= 7'd118; 
            else if(key_down[9'h01D])
                led[6:0] <= 7'd119; 
            else if(key_down[9'h022])
                led[6:0] <= 7'd120; 
            else if(key_down[9'h035])
                led[6:0] <= 7'd121; 
            else if(key_down[9'h01A])
                led[6:0] <= 7'd122; 
            else
                led[6:0] <= 7'd0;
        end
            
        1:
        begin
            if(key_down[9'h01C])
                led[6:0] <= 7'd65; 
            else if(key_down[9'h032])
                led[6:0] <= 7'd66;
            else if(key_down[9'h021])
                led[6:0] <= 7'd67; 
            else if(key_down[9'h023])
                led[6:0] <= 7'd68; 
            else if(key_down[9'h024])
                led[6:0] <= 7'd69; 
            else if(key_down[9'h02B])
                led[6:0] <= 7'd70; 
            else if(key_down[9'h034])
                led[6:0] <= 7'd71; 
            else if(key_down[9'h033])
                led[6:0] <= 7'd72; 
            else if(key_down[9'h043])
                led[6:0] <= 7'd73; 
            else if(key_down[9'h03B])
                led[6:0] <= 7'd74; 
            else if(key_down[9'h042])
                led[6:0] <= 7'd75; 
            else if(key_down[9'h04B])
                led[6:0] <= 7'd76; 
            else if(key_down[9'h03A])
                led[6:0] <= 7'd77; 
            else if(key_down[9'h031])
                led[6:0] <= 7'd78; 
            else if(key_down[9'h044])
                led[6:0] <= 7'd79; 
            else if(key_down[9'h04D])
                led[6:0] <= 7'd80; 
            else if(key_down[9'h015])
                led[6:0] <= 7'd81; 
            else if(key_down[9'h02D])
                led[6:0] <= 7'd82; 
            else if(key_down[9'h01B])
                led[6:0] <= 7'd83; 
            else if(key_down[9'h02C])
                led[6:0] <= 7'd84; 
            else if(key_down[9'h03C])
                led[6:0] <= 7'd85; 
            else if(key_down[9'h02A])
                led[6:0] <= 7'd86; 
            else if(key_down[9'h01D])
                led[6:0] <= 7'd87; 
            else if(key_down[9'h022])
                led[6:0] <= 7'd88; 
            else if(key_down[9'h035])
                led[6:0] <= 7'd89; 
            else if(key_down[9'h01A])
                led[6:0] <= 7'd90; 
            else
                led[6:0] <= 7'd0;
        end
    endcase
end

endmodule 
