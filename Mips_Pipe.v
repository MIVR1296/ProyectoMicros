`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2017 01:11:29 AM
// Design Name: 
// Module Name: MipsPipe
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
// Se implementa el pipeline del Patterson, 3ra edición. De la sección 6.3 
// Se diseña el pipeline de la figura 6.27, página 404
// 
////////////////////////////////////////////////////////////////////////////////


module Mips_Pipe(clk, reset, IF_pc,ID_rd1, ID_rd2,EX_ALUOut,EX_funct,EX_Operation,WB_wd);
  
      
 // ********************************************************************
 //                              Variables de entrada
 // ********************************************************************
   
input clk, reset;
 
 // ********************************************************************
 //                              Variables de salida
 // ********************************************************************

    output [31:0] IF_pc;// addres en teoria
    output [31:0] ID_rd1, ID_rd2; //registros de datos
    output [31:0] EX_ALUOut; //salida de la Alu
    output [5:0] EX_funct; //funcion a realizar
    output [2:0] EX_Operation; //tipo de instruccion
    output [31:0] WB_wd;// registro de salida
    wire [31:0] IF_pc;

 // ********************************************************************
 //                              Declaración de las señales
 // ********************************************************************

  
 // ********************************************************************
 //                            Declaración de señales del Fetch (IF)
 // ********************************************************************

    // Direcciones
    wire [31:0] IF_instr, IF_pc, IF_pc_maybestalled, IF_pc_jump, IF_pc_next, IF_pc4;

    // Se agrega la senal de atascamiento
    reg Stall;

 // ********************************************************************
 //                            Declaración de señales del Decode (ID)
 // ********************************************************************


    reg [31:0] ID_instr, ID_pc4;  // pipeline register values from EX

    wire [5:0] ID_op, ID_funct;
    wire [4:0] ID_rs, ID_rt, ID_rd;
    wire [15:0] ID_immed;
    wire [31:0] ID_extend, ID_rd1, ID_rd2;
    wire [31:0] ID_jaddr;

    assign ID_op = ID_instr[31:26]; // 6 bits del código de operación
    assign ID_rs = ID_instr[25:21]; // 5 bits del registro rs
    assign ID_rt = ID_instr[20:16]; // 5 bits del registro rt
    assign ID_rd = ID_instr[15:11]; // 5 bits del registro rd
    assign ID_immed = ID_instr[15:0]; // 16 bits para un inmediato

    
    
     // Las siguientes señales se encuentran entre la unidad de control y los muxes de atascamiento (stall)
    wire ID_RegWrite_v, ID_MemWrite_v, ID_MemRead_v, ID_Branch_v, ID_Jump_v;

    wire ID_RegWrite, ID_Branch, ID_RegDst, ID_MemtoReg,  // Señales de control del decode
         ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_Jump;
    wire [1:0] ID_ALUOp;

 // ********************************************************************
 //                            Declaración de señales del Execute (EX)
 // ********************************************************************

    reg  [31:0] EX_pc4, EX_extend, EX_rd1, EX_rd2;
    wire [31:0]  EX_offset, EX_btgt, EX_alub, EX_ALUOut;
    reg  [4:0]  EX_rs, EX_rt, EX_rd;
    wire [4:0]  EX_RegRd;
    wire [5:0] EX_funct;

    reg  EX_RegWrite, EX_Branch, EX_RegDst, EX_MemtoReg,  // Señales de control del EX
         EX_MemRead, EX_MemWrite, EX_ALUSrc;

    wire EX_Zero;

    reg  [1:0] EX_ALUOp;
    wire [2:0] EX_Operation;

    //Para la unidad de adelantamiento
    reg  [1:0] ForwardA, ForwardB;

 // ********************************************************************
 //                            Declaración de señales del MEM 
 // ********************************************************************
    wire MEM_PCSrc;

    reg  MEM_RegWrite, MEM_Branch, MEM_MemtoReg,
         MEM_MemRead, MEM_MemWrite, MEM_Zero;

    reg  [31:0] MEM_btgt, MEM_ALUOut, MEM_rd2;
    wire [31:0] MEM_memout;
    reg  [5:0] MEM_RegRd;

 // ********************************************************************
 //                            Declaración de señales del Writeback (WB)
 // ********************************************************************

    reg WB_RegWrite, WB_MemtoReg;  // Señales de control del Wb

    reg  [31:0] WB_memout, WB_ALUOut;
    wire [31:0] WB_wd;
    reg  [4:0] WB_RegRd;
 //  A continuación se muestran las 5 Estapas del pipeline con las unidades de detección de riesgos y adelantamiento:
 
 // ********************************************************************
 //                              Etapa 1: Fetch
 // ********************************************************************
    // IF Hardware

    // Registro que contiene la direccion de PC
    Registro_32		IF_PC(clk, reset, IF_pc_next, IF_pc);

    // Realiza la suma de PC+4
    Adder_32		IF_PCADD(IF_pc, 32'd4, IF_pc4);

    // Cuando ocurre un atascamiento se deja de incrementar el PC
    Mux_2x1 #(32)  IF_SMUX(Stall, IF_pc4, IF_pc, IF_pc_maybestalled);

    // Se identifica desde la etapa de  ID si había un jump
    Mux_2x1 #(32)  IF_JMPMUX(ID_Jump, IF_pc_maybestalled, ID_jaddr, IF_pc_jump);

    // Se identifica si habia un Branch, en la etapa de MEM tiene prioridad sobre el jump
    Mux_2x1 #(32)	IF_PCMUX(MEM_PCSrc, IF_pc_jump, MEM_btgt, IF_pc_next);

    ROM		IMEM(IF_pc, IF_instr); // Se accede la direccion de IF_pc en la memoria para obtener la 
                                // instruccion que se encuentra en esa direccion

 // ********************************************************************
 //                             Registro: IF/ID
 // ********************************************************************
    always @(posedge clk)		    
    begin
        if (reset)
        begin
            ID_instr <= 0; // Si hay un reset ID_instr es igual a cero
            ID_pc4   <= 0;
        end
        else begin
             // Si hay un jump pone en cero la instruccion
            if (ID_Jump)
                ID_instr <= 0;

            else if (Stall)
                ID_instr <= ID_instr;
            else
                ID_instr <= IF_instr; // Toma el valor obtenido del fetch
            ID_pc4   <= IF_pc4;      // Toma el valor del fetch
        end
    end

 
 // ********************************************************************
 //                              Etapa 2: Decode
 // ********************************************************************

    Registro RFILE(clk, WB_RegWrite, ID_rs, ID_rt, WB_RegRd, ID_rd1, ID_rd2, WB_wd);

    // Para la extensión de signo
    assign ID_extend = { {16{ID_immed[15]}}, ID_immed };

    // Calcula la direccion de salto 
    assign ID_jaddr = {ID_pc4[31:28], ID_instr[25:0], 2'b00};

   // Implementacion de la unidad de detencion de riesgos
    always @(*)
    begin
        if (EX_MemRead
          && ((EX_rt == ID_rs) || (EX_rt == ID_rt))) // Condicion para que se de un atascamiento
            Stall = 1'b1;
        else
            Stall = 1'b0;  // Si lo anterior no ocurre no hay atascamiento
    end


    // MODIFICATIONS HERE:
    // Connect ID_Jump to the control unit
    OpControl CTL(.opcode(ID_op), .RegDst(ID_RegDst),
                       .ALUSrc(ID_ALUSrc), .MemtoReg(ID_MemtoReg),
                       .RegWrite(ID_RegWrite_v), .MemRead(ID_MemRead_v),
                       .MemWrite(ID_MemWrite_v), .Branch(ID_Branch_v),
                       .ALUOp(ID_ALUOp), .Jump(ID_Jump_v));

    Mux_2x1 #(1)   ID_RW_SMUX(Stall, ID_RegWrite_v, 1'b0, ID_RegWrite);
    Mux_2x1 #(1)   ID_MR_SMUX(Stall, ID_MemRead_v,  1'b0, ID_MemRead);
    Mux_2x1 #(1)   ID_MW_SMUX(Stall, ID_MemWrite_v, 1'b0, ID_MemWrite);
    Mux_2x1 #(1)   ID_BR_SMUX(Stall, ID_Branch_v,   1'b0, ID_Branch);
    Mux_2x1 #(1)   ID_JU_SMUX(Stall, ID_Jump_v,     1'b0, ID_Jump);
    
  // ********************************************************************
  //                              Registro: ID/EX
  // ********************************************************************

    always @(posedge clk)		    
    begin
        if (reset)
        begin
            
            EX_RegDst   <= 0;
            EX_ALUOp    <= 0;
            EX_ALUSrc   <= 0;
            EX_Branch   <= 0;
            EX_MemRead  <= 0;
            EX_MemWrite <= 0;
            EX_RegWrite <= 0;
            EX_MemtoReg <= 0;

            EX_pc4      <= 0;
            EX_rd1      <= 0;
            EX_rd2      <= 0;
            EX_extend   <= 0;
            EX_rs       <= 0;
            EX_rt       <= 0;
            EX_rd       <= 0;
        end
        else begin
            
            EX_RegDst   <= ID_RegDst;
            EX_ALUOp    <= ID_ALUOp;
            EX_ALUSrc   <= ID_ALUSrc;
            EX_Branch   <= ID_Branch;
            EX_MemRead  <= ID_MemRead;
            EX_MemWrite <= ID_MemWrite;
            EX_RegWrite <= ID_RegWrite;
            EX_MemtoReg <= ID_MemtoReg;

            EX_pc4      <= ID_pc4;
            EX_rd1      <= ID_rd1;
            EX_rd2      <= ID_rd2;
            EX_extend   <= ID_extend;
            EX_rs       <= ID_rs;
            EX_rt       <= ID_rt;
            EX_rd       <= ID_rd;
        end
    end

  // ********************************************************************
  //                              Estapa 3: Ejecución (Exe)
  // ********************************************************************

    assign EX_offset = EX_extend << 2;

    assign EX_funct = EX_extend[5:0];

    Adder_32 		EX_BRADD(EX_pc4, EX_offset, EX_btgt);

    wire [31:0] MuxA_out, MuxB_out;


    Mux_3x1 #(32)  FMUXA(ForwardA, EX_rd1, WB_wd, MEM_ALUOut, MuxA_out);
    Mux_3x1 #(32)  FMUXB(ForwardB, EX_rd2, WB_wd, MEM_ALUOut, MuxB_out);

  
    Mux_2x1 #(32) 	ALUMUX(EX_ALUSrc, MuxB_out, EX_extend, EX_alub);

    Alu 	EX_ALU(EX_Operation, MuxA_out, EX_alub, EX_ALUOut, EX_Zero);

    Mux_2x1 #(5) 	EX_RFMUX(EX_RegDst, EX_rt, EX_rd, EX_RegRd);

    AluControl 	EX_ALUCTL(EX_ALUOp, EX_funct, EX_Operation);


    // MODIFICATIONS HERE:
    // Implement the forwarding unit based on logic described in page 369
    always @(*)
    begin
        // Set ForwardA
        // Forward around EX hazards
        if (MEM_RegWrite
            && (MEM_RegRd != 0)
            && (MEM_RegRd == EX_rs))
            ForwardA = 2'b10;
        // Forward around MEM hazards
        else if (WB_RegWrite
            && (WB_RegRd != 0)
            && !(MEM_RegWrite && (MEM_RegRd != 0) && (MEM_RegRd != EX_rs))
            && (WB_RegRd == EX_rs))
            ForwardA = 2'b01;
        // No hazards, use the value from ID/EX
        else
            ForwardA = 2'b00;


        // Set ForwardB
        // Forward around EX hazards
        if (MEM_RegWrite
            && (MEM_RegRd != 0)
            && (MEM_RegRd == EX_rt))
            ForwardB = 2'b10;
        // Forward around MEM hazards
        else if (WB_RegWrite
            && (WB_RegRd != 0)
            && !(MEM_RegWrite && (MEM_RegRd != 0) && (MEM_RegRd != EX_rt))
            && (WB_RegRd == EX_rt))
            ForwardB = 2'b01;
        // No hazards, use the value from ID/EX
        else
            ForwardB = 2'b00;
    end

// ********************************************************************
//                              Registro: EX/MEM
// ********************************************************************

    always @(posedge clk)		    
    begin
        if (reset)
        begin
            MEM_Branch   <= 0;
            MEM_MemRead  <= 0;
            MEM_MemWrite <= 0;
            MEM_RegWrite <= 0;
            MEM_MemtoReg <= 0;
            MEM_Zero     <= 0;

            MEM_btgt     <= 0;
            MEM_ALUOut   <= 0;
            MEM_rd2      <= 0;
            MEM_RegRd    <= 0;
        end
        else begin
            MEM_Branch   <= EX_Branch;
            MEM_MemRead  <= EX_MemRead;
            MEM_MemWrite <= EX_MemWrite;
            MEM_RegWrite <= EX_RegWrite;
            MEM_MemtoReg <= EX_MemtoReg;
            MEM_Zero     <= EX_Zero;

            MEM_btgt     <= EX_btgt;
            MEM_ALUOut   <= EX_ALUOut;
            MEM_rd2      <= EX_rd2;
            MEM_RegRd    <= EX_RegRd;
        end
    end

 // ********************************************************************
 //                              Etapa 4: Memory (MEM)
 // ********************************************************************

    Memoria 	MEM_DMEM(clk, MEM_MemRead, MEM_MemWrite, MEM_ALUOut, MEM_rd2, MEM_memout);

    and  		MEM_BR_AND(MEM_PCSrc, MEM_Branch, MEM_Zero);
    
 // ********************************************************************
 //                              Registro: MEM/WB
 // ********************************************************************

    always @(posedge clk)		
    begin
        if (reset)
        begin
            WB_RegWrite <= 0;
            WB_MemtoReg <= 0;
            WB_ALUOut   <= 0;
            WB_memout   <= 0;
            WB_RegRd    <= 0;
        end
        else begin
            WB_RegWrite <= MEM_RegWrite;
            WB_MemtoReg <= MEM_MemtoReg;
            WB_ALUOut   <= MEM_ALUOut;
            WB_memout   <= MEM_memout;
            WB_RegRd    <= MEM_RegRd;
        end
    end

  // ********************************************************************
  //                              Etapa 5: Writeback
  // ********************************************************************

    Mux_2x1 #(32)	WB_WRMUX(WB_MemtoReg, WB_ALUOut, WB_memout, WB_wd);


endmodule
