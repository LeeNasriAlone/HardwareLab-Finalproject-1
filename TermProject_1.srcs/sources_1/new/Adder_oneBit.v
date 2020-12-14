`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2020 06:12:17 PM
// Design Name: 
// Module Name: Adder_oneBit
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


module Adder_oneBit(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output reg [3:0] sum,
    output reg carry
    );

    //declare the inputs and outputs of the module with their sizes.
    //Internal variables
    reg [4:0] sum_temp;

    //always block for doing the addition
    always @(a,b,carry_in)
    begin
        sum_temp = a+b+carry_in; //add all the inputs
        if(sum_temp > 9)    begin
            sum_temp = sum_temp+6; //add 6, if result is more than 9.
            carry = 1;  //set the carry output
            sum = sum_temp[3:0];    end
        else    begin
            carry = 0;
            sum = sum_temp[3:0];
        end
    end  
endmodule
