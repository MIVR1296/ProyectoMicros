`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 12:28:54 AM
// Design Name: 
// Module Name: OpControl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Alu de control basada en la tabla de control del libro Computer Organization and Design 3 edicion
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OpControl(opcode, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump);
    input [5:0] opcode; // Op code de la instruccion
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    output [1:0] ALUOp; // Señales de control
    reg    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    reg    [1:0] ALUOp;

    parameter R_FORMAT = 6'd0;
    parameter J = 6'd2;
    parameter LW = 6'd35;
    parameter SW = 6'd43;
    parameter BEQ = 6'd4;

    always @(opcode)
    begin
        case (opcode)
          R_FORMAT :
          begin
              RegDst=1'b1; ALUSrc=1'b0; MemtoReg=1'b0; RegWrite=1'b1; MemRead=1'b0;
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b10; Jump=1'b0;
          end
          J :
          begin
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0;
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00; Jump=1'b1;
          end
          LW :
          begin
              RegDst=1'b0; ALUSrc=1'b1; MemtoReg=1'b1; RegWrite=1'b1; MemRead=1'b1;
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0;
          end
          SW :
          begin
              RegDst=1'bx; ALUSrc=1'b1; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0;
              MemWrite=1'b1; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0;
          end
          BEQ :
          begin
              RegDst=1'bx; ALUSrc=1'b0; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0;
              MemWrite=1'b0; Branch=1'b1; ALUOp = 2'b01; Jump=1'b0;
          end
          default
          begin
              $display("control_single unimplemented opcode %d", opcode);
              RegDst=1'b0; ALUSrc=1'b0; MemtoReg=1'b0; RegWrite=1'b0; MemRead=1'b0;
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0;
          end
        endcase
    end
endmodule
