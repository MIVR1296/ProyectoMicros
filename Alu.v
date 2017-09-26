`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2017 10:10:18 PM
// Design Name: 
// Module Name: Alu
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

module Alu(ctl, a, b, result, zero);
  input [2:0] ctl;
  input [31:0] a, b;
  output [31:0] result;
  output zero;

  reg [31:0] result;
  reg zero;

  always @(a or b or ctl)
  begin
    case (ctl)
      3'b000 : result = a & b; // AND
      3'b001 : result = a | b; // OR
      3'b010 : result = a + b; // ADD
      3'b110 : result = a - b; // SUBTRACT
      3'b111 : if (a < b) result = 32'd1; 
               else result = 32'd0; //SLT      
      default : result = 32'hxxxxxxxx;
   endcase
   if (result == 32'd0)
   zero = 1;
   else zero = 0;
 end
endmodule


