`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2020 12:38:56 PM
// Design Name: 
// Module Name: calculator
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


module calculator(
    input [13:0] A,
    input [13:0] B,
    input [4:0] opcode,
    input clk,
    output reg [13:0] result
    );
always @(posedge clk)
    begin
    if (opcode == 4'b1010)
        result = A + B;
    else if (opcode == 4'b1011)
        result = A - B;
    else if (opcode == 4'b1100)
        result = A * B;
    else if (opcode == 4'b1101)
        if (B == 0)
            result = 0;
        else
            result = A / B;
    end
endmodule
