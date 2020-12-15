`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2020 10:56:13 PM
// Design Name: 
// Module Name: BCD2Binary
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


module BCD2Binary
   (
    input [3:0] bcd3, 
    input [3:0] bcd2, 
    input [3:0] bcd1, 
    input [3:0] bcd0, 
    output wire [13:0] bin
   );

   assign bin = (bcd3 * 10'd1000) + (bcd2*7'd100) + (bcd1*4'd10) + bcd0;

endmodule
