`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 10:02:57 AM
// Design Name: 
// Module Name: Mux_2x1
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


module Mux_2x1( sel, a, b, y );
    parameter bitwidth=32;
    input sel;
    input  [bitwidth-1:0] a, b;
    output [bitwidth-1:0] y;

    assign y = sel ? b : a;
endmodule

