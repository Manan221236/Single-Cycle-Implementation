`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2025 01:06:38
// Design Name: 
// Module Name: control_unit
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


module control_unit(
    input wire [5:0] opcode,
    output reg RegDst, jump, branch, bnq, memRead, memtoReg, memWrite,aluSrc, RegWrite,
    output reg [1:0] aluOp
    );
    always@(*)begin
        RegDst = 0;
        jump = 0;
        branch = 0;
        bnq = 0;
        memRead = 0;
        memtoReg = 0;
        aluOp = 2'b00;
        memWrite = 0;
        aluSrc = 0;
        RegWrite = 0;
        
        case (opcode)
            6'b000000: begin //R-Type
                RegDst = 1;
                RegWrite =1;
                aluOp = 2'b10;
            end
            6'b100011: begin //lw
                aluSrc =1;
                memtoReg =1;
                RegWrite =1;
                memRead = 1;
                aluOp = 2'b00;
            end
            6'b101011: begin //sw
                aluSrc = 1;
                memWrite =1;
                aluOp = 2'b00;
            end
            6'b000100: begin //beq
                branch =1;
                aluOp = 2'b01;
            end
            6'b000101: begin //bne
                bnq = 1;
                aluOp = 2'b01;
            end
            6'b000010: begin //j
                jump = 1;
            end
            6'b000011: begin //jal
                jump = 1;
                RegWrite = 1;
            end
            6'b001011: begin // sltiu
                aluSrc = 1;
                RegWrite = 1;
                aluOp = 2'b11;
            end
            6'b100101: begin //lhu
                aluSrc = 1;
                memtoReg = 1;
                RegWrite = 1;
                memRead = 1;
                aluOp = 2'b00;
            end
            default: begin
                //noop
            end
        endcase
    end     
endmodule
