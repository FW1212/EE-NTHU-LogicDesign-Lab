`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/09 14:37:33
// Design Name: 
// Module Name: mem_addr_gen
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


module mem_addr_gen(
    input [9:0] h_cnt,
    input [9:0] v_cnt,
    output reg [16:0] pixel_addr
    );
 
 // assign pixel_addr = ((h_cnt >> 1) + (v_cnt >> 1) * 300) % 60000;
 
 
  always @* begin
    if (h_cnt > 320)
        if (v_cnt > 377 && v_cnt < 438)
            if (h_cnt > 368 && h_cnt < 408)
                pixel_addr = (((h_cnt >> 1) - 185) + ((v_cnt >> 1) - 190) * 20) % 600;
            else if (h_cnt > 428 && h_cnt < 468)
                pixel_addr = (((h_cnt >> 1) - 215) + ((v_cnt >> 1) - 190) * 20) % 600;
            else if (h_cnt > 488 && h_cnt < 528)
                pixel_addr = (((h_cnt >> 1) - 245) + ((v_cnt >> 1) - 190) * 20) % 600;
            else if (h_cnt > 548 && h_cnt < 588)
                pixel_addr = (((h_cnt >> 1) - 274) + ((v_cnt >> 1) - 190) * 20) % 600;
            else
                pixel_addr = (((h_cnt >> 1) - 160) + (v_cnt >> 1) * 160) % 38400;
        else
            pixel_addr = (((h_cnt >> 1) - 160) + (v_cnt >> 1) * 160) % 38400;
    else if (h_cnt > 80 && h_cnt < 240)
        begin
        if (v_cnt < 320 && v_cnt > 160)
            pixel_addr = (((h_cnt >> 1) - 40) + ((v_cnt >> 1) - 80) * 80) % 6400;
        else
            pixel_addr = 17'd0;
        end
    else
        pixel_addr = 17'd0;

  end
  
  endmodule 
  
