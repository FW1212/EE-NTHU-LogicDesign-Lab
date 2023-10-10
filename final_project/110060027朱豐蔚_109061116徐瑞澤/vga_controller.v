`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/04 13:13:37
// Design Name: 
// Module Name: vga_controller
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


module vga_controller (
    pclk,
    reset,
    hsync,
    vsync,
    valid,
    h_cnt,
    v_cnt
    );
    output hsync, vsync, valid;
    output [9:0] h_cnt, v_cnt;
    input pclk, reset;

    reg [9:0]pixel_cnt;
    reg [9:0]line_cnt;
    reg hsync_i,vsync_i;
    wire hsync_default, vsync_default;
    wire [9:0] HD, HF, HS, HB, HT, VD, VF, VS, VB, VT;

   
    assign HD = 640; // 水平 display
    assign HF = 16;  // 水平前搖 
    assign HS = 96;  // 水平脈衝
    assign HB = 48;  // 水平後搖
    assign HT = 800; // 水平總共
    assign VD = 480; // 垂直 display
    assign VF = 10;  // 垂直前搖
    assign VS = 2;   // 垂直脈衝
    assign VB = 33;  // 垂直後搖
    assign VT = 525; // 垂直總共
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    // 處理欄的計數
    always@(posedge pclk or negedge reset)
        if(~reset)
            pixel_cnt <= 0;
        else if(pixel_cnt < (HT - 1))
            pixel_cnt <= pixel_cnt + 1;
        else
            pixel_cnt <= 0;

    //   處理水平脈衝波
    always@(posedge pclk or negedge reset)
        if(~reset)
            hsync_i <= hsync_default;
        else if((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
            hsync_i <= ~hsync_default;
        else
            hsync_i <= hsync_default; 
    
    // 處理垂直脈衝波
    always@(posedge pclk or negedge reset)
        if(~reset)
            vsync_i <= vsync_default; 
        else if((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 
    
    // 處理列的計數
    always@(posedge pclk or negedge reset)
        if(~reset)
            line_cnt <= 0;
        else if(pixel_cnt == (HT -1)) // 若數完一列
                if(line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
                    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD)); // 合理訊號判斷
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt:10'd0; // 欄位置判斷
    assign v_cnt = (line_cnt < VD) ? line_cnt:10'd0; // 列位置判斷
           
endmodule
