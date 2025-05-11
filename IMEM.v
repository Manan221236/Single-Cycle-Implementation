`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2025 00:03:37
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input wire [31:0] addr,
    output reg [31:0] inst
    );
    reg [31:0] mem [0:(2**30)-1];
    //initial begin
        //$readmemh("C:/Users/manan/CA_Project/CA_Project.sim/sim_1/behav/inst.hex", mem);
    //end
    
    //Word aligned read
    always@(*) begin
        inst = mem[addr[31:2]];
    end
endmodule
