`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 01:52:17 AM
// Design Name: 
// Module Name: Tb
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


module Tb(
    );
    reg reloj;
    reg reset;
    wire [31:0] IF_pc4;
    
   MipsPipe Este(.clk(reloj), 
             .reset(reset),
             .IF_pc4(IF_pc4));
   
    initial 
    begin
        reloj=0;
        reset=1;
        #10 reset=0;
    end 
    always
    begin
        #10 reloj=~reloj;
    end                 
endmodule
