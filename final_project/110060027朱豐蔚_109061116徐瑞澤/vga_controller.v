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

   
    assign HD = 640; // ���� display
    assign HF = 16;  // �����e�n 
    assign HS = 96;  // �����߽�
    assign HB = 48;  // ������n
    assign HT = 800; // �����`�@
    assign VD = 480; // ���� display
    assign VF = 10;  // �����e�n
    assign VS = 2;   // �����߽�
    assign VB = 33;  // ������n
    assign VT = 525; // �����`�@
    assign hsync_default = 1'b1;
    assign vsync_default = 1'b1;
     
    // �B�z�檺�p��
    always@(posedge pclk or negedge reset)
        if(~reset)
            pixel_cnt <= 0;
        else if(pixel_cnt < (HT - 1))
            pixel_cnt <= pixel_cnt + 1;
        else
            pixel_cnt <= 0;

    //   �B�z�����߽Īi
    always@(posedge pclk or negedge reset)
        if(~reset)
            hsync_i <= hsync_default;
        else if((pixel_cnt >= (HD + HF - 1))&&(pixel_cnt < (HD + HF + HS - 1)))
            hsync_i <= ~hsync_default;
        else
            hsync_i <= hsync_default; 
    
    // �B�z�����߽Īi
    always@(posedge pclk or negedge reset)
        if(~reset)
            vsync_i <= vsync_default; 
        else if((line_cnt >= (VD + VF - 1))&&(line_cnt < (VD + VF + VS - 1)))
            vsync_i <= ~vsync_default; 
        else
            vsync_i <= vsync_default; 
    
    // �B�z�C���p��
    always@(posedge pclk or negedge reset)
        if(~reset)
            line_cnt <= 0;
        else if(pixel_cnt == (HT -1)) // �Y�Ƨ��@�C
                if(line_cnt < (VT - 1))
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
                    
    assign hsync = hsync_i;
    assign vsync = vsync_i;
    assign valid = ((pixel_cnt < HD) && (line_cnt < VD)); // �X�z�T���P�_
    
    assign h_cnt = (pixel_cnt < HD) ? pixel_cnt:10'd0; // ���m�P�_
    assign v_cnt = (line_cnt < VD) ? line_cnt:10'd0; // �C��m�P�_
           
endmodule
