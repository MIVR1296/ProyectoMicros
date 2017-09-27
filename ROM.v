`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 01:35:34 AM
// Design Name: 
// Module Name: Rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Corresponde a la memoria de intrucciones que se describe en el Paterson. En las págs 292 293.
// 
//////////////////////////////////////////////////////////////////////////////////

////


module ROM(address, data_out); 
  
// ********************************************************************
//     Señales de entrada y salida de la memoria de instrucciones                      
// ********************************************************************


  input  [31:0] address; // Corresponde a la dirección que ingresa del PC para buscar la instrucción
  output [31:0] data_out; // Sale la instrucción
  reg    [31:0] data_out;

  parameter BASE_ADDRESS = 25'd0;
  wire [5:0] mem_offset; // se utiliza para los case
  wire address_select;

  assign mem_offset = address[7:2];  // Se toman los  LSB para utilizarlos en el case

  assign address_select = (address[31:8] == BASE_ADDRESS);  // address decoding

  always @(address_select or mem_offset)

  begin
    // en caso de que la dirección no sea múltiplo de 4
    if ((address % 4) != 0) $display($time, " rom32 error: unaligned address %d", address);
    if (address_select == 1) 
    begin
      case (mem_offset)
          5'd0  : data_out = {6'd35, 5'd0, 5'd2, 16'd4};            // lw $2, 4($0)     r2 = 1
          5'd1  : data_out = {6'd0, 5'd2, 5'd2, 5'd2, 5'd0, 6'd32}; // add $2, $2, $2   r2 = 2
          5'd2  : data_out = {6'd2, 26'd7};                         // jump to instruction 6
          5'd3  : data_out = {6'd0, 5'd2, 5'd2, 5'd2, 5'd0, 6'd32}; // add $2, $2, $2   r2 = 4 (should be skipped)
          5'd4  : data_out = 0;                                     // These are here just so our jump is more
          5'd5  : data_out = 0;                                     // visible
          5'd6  : data_out = 0;
          5'd7  : data_out = {6'd0, 5'd2, 5'd2, 5'd2, 5'd0, 6'd32}; // add $2, $2, $2   r2 = 4
          5'd8  : data_out = {6'd0, 5'd2, 5'd2, 5'd2, 5'd0, 6'd32}; // add $2, $2, $2   r2 = 8
          default data_out = 32'hxxxx;
      endcase
      
      // $display("<format>", exp1, exp2, ...); 
      //El primer grupo de tareas de visualización es muy similar a imprimir la función en el lenguaje ANSI C (la sintaxis es casi la misma). 
      //La tareas $ display añade un nuevo carácter de línea al final de la salida.

      $display($time, " reading data: rom32[%h] => %h", address, data_out);

    end
  end
endmodule
