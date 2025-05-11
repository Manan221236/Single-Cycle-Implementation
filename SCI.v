`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2025 22:08:35
// Design Name: 
// Module Name: SCI
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


module SCI(
    input wire clk, reset
    );
    //Internal Wires
    wire [31:0] pc_curr, pc_next;
    wire [31:0] instruction;
    
    //Control Signals
    wire RegDst, jump, branch, bnq, memtoReg, memRead, memWrite, aluSrc, RegWrite;
    wire [1:0] aluOp;
    
    //RegFile Wires
    wire [4:0] regWriteAddr;
    wire [31:0] regReadData1, regReadData2;
    wire [31:0] regWriteData;
    
    //ALU Wires
    wire [31:0] sign_imm;
    wire [31:0] aluSrcB;
    wire [3:0] aluControl;
    wire [31:0] aluRes;
    wire zero;
    
    //RAM Wires
    wire [31:0] memReadData;
    
    //PC+4
    wire [31:0] pc_4 = pc_curr + 4;
    
    //Branch Signals
    wire branch_taken;
    wire [31:0] shifted_imm;
    wire [31:0] branchAddr;
    wire [31:0] jumpAddr;
    
    //PC
    PC pc(
        .clk(clk),
        .reset(reset),
        .pc_in(pc_next),
        .pc_out(pc_curr)
    );
    //Instruction Memory
    IMEM imem(
        .addr(pc_curr),
        .inst(instruction)
    );
    //Control Unit
    control_unit CU(
        .opcode(instruction[31:26]),
        .RegDst(RegDst),
        .jump(jump),
        .branch(branch),
        .bnq(bnq),
        .memRead(memRead),
        .memWrite(memWrite),
        .memtoReg(memtoReg),
        .aluOp(aluOp),
        .RegWrite(RegWrite),
        .aluSrc(aluSrc)
    );
    //Reg File
    //Mux for destination reg Rd or Rt
    assign regWriteAddr = (RegDst) ? instruction[15:11]:instruction[20:16];
    RegisterFile RegFile(
        .clk(clk),
        .regWrite(RegWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(regWriteAddr),
        .writeData(regWriteData),
        .readData1(regReadData1),
        .readData2(regReadData2)
    );
    //Sign Extension
    SignExtend signextend(
        .in(instruction[15:0]),
        .out(sign_imm)
    );
    //ALU Control
    alu_control alu_ctrl(
        .funct(instruction[5:0]),
        .aluOp(aluOp),
        .aluControl(aluControl)
    );
    //ALU Input MUX
    assign aluSrcB = (aluSrc) ? sign_imm : regReadData2;
    //ALU
    alu ALU(
        .a(regReadData1),
        .b(aluSrcB),
        .control(aluControl),
        .shamt(instruction[10:6]),
        .res(aluRes),
        .zero(zero)
    );
    //RAM
    RAM DMEM(
        .clk(clk),
        .memRead(memRead),
        .memWrite(memWrite),
        .addr(aluRes),
        .data_in(regReadData2),
        .data_out(memReadData)
    );
    //Write Back MUX
    assign regWriteData = (memtoReg) ? memReadData:aluRes;
    //Branch and Jump
    //beq: zero = 1
    //bnq: zero = 0
    assign branch_taken = (branch & zero) | (bnq & ~zero);
    //Shift left 2
    ShiftLeft2 shiftleft(
        .in(sign_imm),
        .out(shifted_imm)
    );
    //branch_addr = PC+4 +(sign_imm<<2)
    assign branchAddr = pc_4 + shifted_imm;
    //jump_addr = { PC+4[31:28], instruction[25:0], 2'b00}
    assign jumpAddr = {pc_4[31:28], instruction[25:0], 2'b00};
    //Final PC MUX
    wire [31:0] pcBranchOr4 = (branch_taken) ? branchAddr : pc_4;
    assign pc_next = (jump) ? jumpAddr:pcBranchOr4;
endmodule
