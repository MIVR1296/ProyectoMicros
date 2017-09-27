`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 10:06:50 AM
// Design Name: 
// Module Name: Mux_3x1
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


module Mux_3x1(sel, a, b, c, y);
    parameter bitwidth=32;
    input   [1:0] sel;
    input   [bitwidth-1:0] a, b, c;
    output  [bitwidth-1:0] y;
    reg     [bitwidth-1:0] y;

    always @(sel or a or b or c)
    begin
        case (sel)
            2'b00 : y = a;
            2'b01 : y = b;
            2'b10 : y = c;
        endcase
    end
endmodule
