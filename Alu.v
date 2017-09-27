`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2017 10:10:18 PM
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
// Additional Comments: Se realiza la implementacion de una Alu de 32 bits para un procesador MIPS, se utiliza como 
// base la descripcion de la misma en los capitulos 5 y 6 del Patterson, 3ra edición (pág 301) 
// 
//////////////////////////////////////////////////////////////////////////////////

module Alu(ctl, a, b, result, zero); 
  input [2:0] ctl; // Se utiliza 1 señal de 3 bits para identificar la funcion a realizar por la Alu
  input [31:0] a, b; // Se tiene como entrada los 2 registros de 32 bits del banco de registro
  output [31:0] result; // La salida es el resultado de la operacion que se realice
  output zero; // Se tiene una salida de señal de cero en caso de utilizar un branch

  reg [31:0] result;
  reg zero;

  always @(a or b or ctl)
  begin
    case (ctl) // Decodifica la funcion segun el valor que tenga ctl 
      3'b000 : result = a & b; // Funcion And 
      3'b001 : result = a | b; // Funcion Or
      3'b010 : result = a + b; // Funcion Add
      3'b110 : result = a - b; // Funcion Sub
      3'b111 : if (a < b) result = 32'd1; // Se revisa si el el registro a es menor que b
               else result = 32'd0; // Para implementar la funcion Slt  
      default : result = 32'hxxxxxxxx;
   endcase
    if (result == 32'd0) // Revisa si el resultado es igual a cero
   zero = 1; // En caso de ser asi se activa la señal zero
   else 
     zero = 0; // De lo contrario la señal de zero se mantiene en cero
 end 
endmodule


