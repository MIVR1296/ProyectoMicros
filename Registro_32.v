`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2017 09:45:47 AM
// Design Name: 
// Module Name: Registro_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Este corresponde al registro que se muestra con el nombre de PC, en los diagramas que se describen en el Patterson
// era edición. En los capítulos 5 y 6
//////////////////////////////////////////////////////////////////////////////////


module Registro_32(clk, reset, d_in, d_out);
    input       	clk, reset;
    input	[31:0]	d_in;
    output 	[31:0] 	d_out;
    reg 	[31:0]	 d_out;
   
    always @(posedge clk)
    begin
        if (reset) d_out <= 0;
        else d_out <= d_in;
    end

endmodule
	
