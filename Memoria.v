`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 01:09:47 AM
// Design Name: 
// Module Name: Memoria
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Se modela de comportamiento de una memoria de lectura-escritura que emplea  implementaciones del MIPS
// Se usa como base el procesador que se describe en los capítulos 5 y 6 del Patterson, 3ra edición (pág 296)
//////////////////////////////////////////////////////////////////////////////////

//***********************************************
// Memoria de datos
//***********************************************
module Memoria (clk, mem_read, mem_write, address, data_in, data_out);

  input  clk, mem_read, mem_write; // Mem_read y Mem_write son las señales de control de lectura y escritura
  input  [31:0] address, data_in; // La dirección corresponde si es una lectura al lugar donde se ubica el dato de 32 bits
  // En caso de ser una escritura corresponde a la posición de memoria en donde se va a almacenar el data_in ( Write_data)
  output [31:0] data_out; 
  
  reg    [31:0] data_out;

  parameter BASE_ADDRESS = 25'd0; 

  reg [31:0] mem_array [0:31]; 
  wire [4:0] mem_offset;
  wire address_select;

  assign mem_offset = address[6:2];  // Se toman 2 LSB para el deesplazamiento de los words ( en caso de ser necesario)

  assign address_select = (address[31:7] == BASE_ADDRESS);  // se decodifica la dirección
  
  //****************************************************************************
  //                      Para la lectura de memoria
  //****************************************************************************
  always @(mem_read or address_select or mem_offset or mem_array[mem_offset])
  begin

    if (mem_read == 1'b1 && address_select == 1'b1) // Si la señal de control de lectura está activa y el selector de dirección también lo está
    begin
      if ((address % 4) != 0) // Entonces se evalua si la dirección no es múltiplo de 4 para desplegar el error
          $display($time, " rom32 error: unaligned address %d", address);
          data_out = mem_array[mem_offset];
          $display($time, " reading data: Mem[%h] => %h", address, data_out);
      end
      else data_out = 32'hxxxxxxxx; // si la dirección es múltiplo de 4 entonces el dato de salida es por defecto, pues estamos en una lectura
  end

  //****************************************************************************
  //                      Para la escritura de memoria
  //****************************************************************************
  always @(posedge clk) // Siempre que estemos en un flanco de reloj positivo
  begin
    if (mem_write == 1'b1 && address_select == 1'b1) // Si la señal de control de escritura y el selector de dirección está activo
      begin // entonces:
      // $display("<format>", exp1, exp2, ...); 
      //El primer grupo de tareas de visualización es muy similar a imprimir la función en el lenguaje ANSI C (la sintaxis es casi la misma). 
      //La tareas $ display añade un nuevo carácter de línea al final de la salida.
      $display($time, " writing data: Mem[%h] <= %h", address,data_in);
      mem_array[mem_offset] <= data_in;
    end
  end

  // Se inicializa con valores arbitrarios el mem_array

  integer i;
  initial begin
    for (i=0; i<7; i=i+1) mem_array[i] = i;
  end
endmodule
