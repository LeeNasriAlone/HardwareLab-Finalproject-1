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
    input             sign_A,
    input [13:0]      A,
    input             sign_B,
    input [13:0]      B,
    input [4:0]       opcode,
    input             clk,
    input             reset,
    output reg [26:0] result,
    output reg        sign,
    output reg        overflow
    );  
    
always @(posedge clk, posedge reset)
    begin
    if (result > 9999) overflow = 1;
    if (result < 9999) overflow = 0;
    // Addition---------------------------------------------------------------------
    if (opcode == 4'b1010) begin
        if      (sign_A == 0 && sign_B == 0 ) begin result = A + B ; sign = 0; end
        else if (sign_A == 0 && sign_B == 1 ) begin
                if     (A >= B) begin result = A - B; sign = 0; end 
                else            begin result = B - A; sign = 1; end
        end
        else if (sign_A == 1 && sign_B == 0 ) begin
                if     (A > B)  begin result = A - B; sign = 1; end 
                else            begin result = B - A; sign = 0; end
        end
        else begin result = A + B ; sign = 1; end
    end
    // Subtraction---------------------------------------------------------------------    
    else if (opcode == 4'b1011) begin
        if      (sign_A == 0 && sign_B == 0 ) begin                                  // A - B
                if (A >= B) begin result = A - B; sign = 0; end
                else        begin result = B - A; sign = 1; end
        end
        else if (sign_A == 0 && sign_B == 1 ) begin result = A + B; sign = 0; end    //   A - (-B) = A + B
        else if (sign_A == 1 && sign_B == 0 ) begin result = A + B; sign = 1; end    // -(A)-   B  = -(A+B) 
        else begin                                                                   // -A  - (-B) = B-A 
                if (A > B) begin result = A - B; sign = 1; end
                else       begin result = B - A; sign = 0; end 
        end
    end
    
    // Multiplication---------------------------------------------------------------------     
    else if (opcode == 4'b1100) 
    begin
        result  = A * B;
        if      (sign_A == 0 && sign_B == 0 ) begin sign = 0; end // (+,+)
        else if (sign_A == 0 && sign_B == 1 ) begin sign = 1; end // (+,-)
        else if (sign_A == 1 && sign_B == 0 ) begin sign = 1; end// (-,+)
        else begin sign = 0;  end// (-,-)
    end   
    
    // Division---------------------------------------------------------------------
    else if (opcode == 4'b1101) begin // Division
        if (B == 0)
            result = 0;
        else begin
            result = A / B;
            if      (sign_A == 0 && sign_B == 0 ) begin sign = 0; end // (+,+)
            else if (sign_A == 0 && sign_B == 1 ) begin sign = 1; end // (+,-)
            else if (sign_A == 1 && sign_B == 0 ) begin sign = 1; end// (-,+)
            else begin sign = 0;  end// (-,-)
       end
    end
    if (reset == 1) begin
        sign = 0;
        result = 0;
    end
end
endmodule
