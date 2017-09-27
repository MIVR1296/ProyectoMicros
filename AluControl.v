`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 12:04:51 AM
// Design Name: 
// Module Name: AluControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Este modulo se encarga de implementar el control de la Alu, segun el codigo de la instruccion
//                      la funcion y para definir 
// 
//////////////////////////////////////////////////////////////////////////////////


module AluControl(ALUOp, Funct, ALUOperation);

    input [1:0] ALUOp; // Codigo de la instruccion, Tipo R, SW, LD, o Branch
    input [5:0] Funct; // Funcion de la instruccion
    output [2:0] ALUOperation; // Señal de control para definir la operacion de la ALU
    reg    [2:0] ALUOperation;

    // Constantes para los codigos de funcion de instrucciones MIPS
    parameter F_add = 6'd32; // Equivalente a 20hex del codigo add de MIPS
    parameter F_sub = 6'd34; // Equivalente a 22hex del codigo sub de MIPS
    parameter F_and = 6'd36; // Equivalente a 24hex del codigo and de MIPS
    parameter F_or  = 6'd37; // Equivalente a 25hex del codigo or de MIPS
    parameter F_slt = 6'd42; // Equivalente a 2Ahex del codigo slt de MIPS

    // Constantes para las funciones de la Alu
    parameter ALU_add = 3'b010; // Codigo asignado para add
    parameter ALU_sub = 3'b110; // Codigo asignado para sub
    parameter ALU_and = 3'b000; // Codigo asignado para and
    parameter ALU_or  = 3'b001; // Codigo asignado para or 
    parameter ALU_slt = 3'b111; // Codigo asignado para slt

    always @(ALUOp or Funct)
    begin
        case (ALUOp) 
            2'b00 : ALUOperation = ALU_add; // Realiza un add, valor fijo de suma si el codigo AluOp es 00
            2'b01 : ALUOperation = ALU_sub; // Realiza un sub, valor fijo de resta si el codigo AluOp es 01
            2'b10 : case (Funct) // En caso de que el codigo AluOp sea 10 se debe asignar un valor 
                                // de acuerdo a la funcion definida en la instruccion
                        F_add : ALUOperation = ALU_add; // 
                        F_sub : ALUOperation = ALU_sub; //
                        F_and : ALUOperation = ALU_and; //
                        F_or  : ALUOperation = ALU_or; //
                        F_slt : ALUOperation = ALU_slt; //
                        default ALUOperation = 3'bxxx;
                    endcase
            default ALUOperation = 3'bxxx;
        endcase
    end
endmodule
