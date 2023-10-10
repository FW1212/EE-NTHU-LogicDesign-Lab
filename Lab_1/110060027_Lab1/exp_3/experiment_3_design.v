`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/26 18:39:04
// Design Name: 
// Module Name: experiment_3_design
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


module experiment_3_design(
    input [2:0] a,
    input [2:0] b,
    output [2:0] o
    );
    
reg [2:0] o;
   
always @(a or b)
    if (a[2] > b[2])
        o[2:0] = b[2:0];
    else if (a[2] < b[2])
        o[2:0] = a[2:0];
    else
        if (a[1] > b[1])
            o[2:0] = a[2:0];
        else if (a[1] < b[1])
            o[2:0] = b[2:0];
        else 
            if (a[0] > b[0])
                o[2:0] = a[2:0];
            else
                o[2:0] = b[2:0];

endmodule
