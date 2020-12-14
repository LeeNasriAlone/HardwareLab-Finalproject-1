`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2020 02:14:45 PM
// Design Name: 
// Module Name: input_state
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


module input_state(
    output [13:0]binary_A,
    output [13:0]binary_B,
    output reg ready_to_calculate,
    input [3:0]data_in,
    input success,
    input reset
    );
    
    reg [3:0]thous_A;
    reg [3:0]huns_A;
    reg [3:0]tens_A;
    reg [3:0]ones_A;
    reg [3:0]opcode;
    reg [3:0]thous_B;
    reg [3:0]huns_B;
    reg [3:0]tens_B;
    reg [3:0]ones_B;
    reg [3:0]state ;
    reg ready_to_calculate;
    
    BCD2Binary bi_A(Thous_A, huns_A, tens_A, ones_A, binary_A);
    BCD2Binary bi_B(Thous_B, huns_B, tens_B, ones_B, binary_B);
    
    initial begin
        state = 0;
        ready_to_calculate = 0;
    end
    
    always @(negedge success)
    begin
        if (reset) begin
            state = 0;
            thous_A = 4'b0000; huns_A  = 4'b0000; tens_A  = 4'b0000; ones_A  = 4'b0000;
            thous_B = 4'b0000; huns_B  = 4'b0000; tens_B  = 4'b0000; ones_B  = 4'b0000;
            opcode  = 4'b0000;
        end
        
        else if (state == 0) begin thous_A = data_in; state = 1; end
        else if (state == 1) begin  huns_A = data_in; state = 2; end
        else if (state == 2) begin  tens_A = data_in; state = 3; end
        else if (state == 3) begin  ones_A = data_in; state = 4; end
        else if (state == 4) begin thous_B = data_in; state = 5; end
        else if (state == 5) begin  huns_B = data_in; state = 6; end
        else if (state == 6) begin  tens_B = data_in; state = 7; end
        else if (state == 7) begin  ones_B = data_in; state = 8; end
        else if (state == 8) begin  opcode = data_in; state = 0; end
        else begin 
            state = 0;
            thous_A = 4'b0000; huns_A  = 4'b0000; tens_A  = 4'b0000; ones_A  = 4'b0000;
            thous_B = 4'b0000; huns_B  = 4'b0000; tens_B  = 4'b0000; ones_B  = 4'b0000;
            opcode  = 4'b0000;
        end
        
        if (state == 8 ) begin ready_to_calculate = 1; end
        else ready_to_calculate = 0;
   end

endmodule
