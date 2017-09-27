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



module Mips_Pipe_tb();
reg clk;
       reg reset;
       wire [31:0] IF_pc;// addres en teoria
       wire [31:0] ID_rd1, ID_rd2; //registros de datos
       wire [31:0] EX_ALUOut; //salida de la Alu
       wire [5:0] EX_funct; //funcion a realizar
       wire [2:0] EX_Operation; //tipo de instruccion
       wire [31:0] WB_wd;// registro de salid;
       
      Mips_Pipe Instancia (
      .clk(clk), 
      .reset(reset), 
      .IF_pc(IF_pc),
      .ID_rd1(ID_rd1), 
      .ID_rd2(ID_rd2),
      .EX_ALUOut(EX_ALUOut),
      .EX_funct(EX_funct),
      .EX_Operation(EX_Operation),
      .WB_wd(WB_wd));

  always
    #5 clk = ~clk;

  initial begin
    clk = 1'b0;
    reset = 1'b0; #10;
    reset = 1'b1; #10;
    reset = 1'b0;
  end

endmodule
