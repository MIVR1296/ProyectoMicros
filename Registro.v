`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 01:34:00 AM
// Design Name: 
// Module Name: Registro
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Este corresponde al banco de registros que se describe en el capítulo 5 y 6 del Patterson, 3era edición. 
// Es como el que se muestra en la figura 5.9 de la página 297 
// 
//////////////////////////////////////////////////////////////////////////////////

//*************************************************************
//                 Banco de registros
//*************************************************************

module Registro(clk, RegWrite, RN1, RN2, WN, RD1, RD2, WD);

  input clk;
  input RegWrite; // Señal de control de escitura
  input [4:0] RN1, RN2, WN; // Read register 1, Read REgister 2 , Write register, ( Recordemos que son los 5 bits de rs, rt, y rd)
  input [31:0] WD; // Write dsta
  output [31:0] RD1, RD2; // Salidas del banco de registros (Read data 1 y 2)

  reg [31:0] RD1, RD2;
  reg [31:0] file_array [31:1];

  always @(RN1 or file_array[RN1])
  begin   
    if (RN1 == 0) RD1 = 32'd0; // Si el registro es el $0 entonces a la salida de RD1 tenemos el dato cero en 32 bits
    else RD1 = file_array[RN1]; // De lo contrario el dato de salida es lo que hay en RN1
    $display($time, " reg_file[%d] => %d (Port 1)", RN1, RD1); 
  end

  always @(RN2 or file_array[RN2]) // Misma lógica que el anterior
  begin
    if (RN2 == 0) RD2 = 32'd0;
    else RD2 = file_array[RN2];
    $display($time, " reg_file[%d] => %d (Port 2)", RN2, RD2);
  end

  always @(negedge clk) // Recordemos que en este caso de usa el flanco negativo para escrituras
    if (RegWrite && (WN != 0)) // Si está en alto la señal de control de escritura y el registro de escritura es distinto de cero
    begin
      file_array[WN] <= WD; //  Se modifica el valor del registro por el nuevo dato
      $display($time, " reg_file[%d] <= %d (Write)", WN, WD);
    end
endmodule
