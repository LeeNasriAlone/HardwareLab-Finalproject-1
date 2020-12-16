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
    output reg          sign,
    output reg   [3:0] thous,
    output reg   [3:0] huns,
    output reg   [3:0] tens,
    output reg   [3:0] ones,
    output reg         sign_A,
    output wire [13:0] binary_A,
    output reg         sign_B,
    output wire [13:0] binary_B,
    output reg   [3:0] state,
    input        [3:0] data_in,
    input              success,
    input              reset
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
    
    assign binary_A = (thous_A * 10'd1000) + (huns_A*7'd100) + (tens_A*4'd10) + ones_A;
    assign binary_B = (thous_B * 10'd1000) + (huns_B*7'd100) + (tens_B*4'd10) + ones_B;
    
    initial begin
        state = 0;
    end
    
    always @(negedge success, posedge reset)
    begin
        if      (state ==  0) begin  sign_A = data_in[0];  sign =  data_in[0] ; state =  1; end
        else if (state ==  1) begin thous_A = data_in   ; thous =  data_in    ; state =  2; end
        else if (state ==  2) begin  huns_A = data_in   ;  huns =  data_in    ; state =  3; end
        else if (state ==  3) begin  tens_A = data_in   ;  tens =  data_in    ; state =  4; end
        else if (state ==  4) begin  ones_A = data_in   ;  ones =  data_in    ; state =  5; end
        else if (state ==  5) begin  sign_B = data_in[0];  sign =  data_in[0] ; state =  6; end
        else if (state ==  6) begin thous_B = data_in   ; thous =  data_in    ; state =  7; end
        else if (state ==  7) begin  huns_B = data_in   ;  huns =  data_in    ; state =  8; end
        else if (state ==  8) begin  tens_B = data_in   ;  tens =  data_in    ; state =  9; end
        else if (state ==  9) begin  ones_B = data_in   ;  ones =  data_in    ; state = 10; end
        else if (state == 10) begin  opcode = data_in   ; state = 0; end
        else begin 
            state = 0;
            sign_A = 0; thous_A = 4'b0000; huns_A  = 4'b0000; tens_A  = 4'b0000; ones_A  = 4'b0000;
            sign_B = 0; thous_B = 4'b0000; huns_B  = 4'b0000; tens_B  = 4'b0000; ones_B  = 4'b0000;
            opcode  = 4'b0000;
        end
        
        if (reset == 1) begin
            state = 0;
            sign_A = 0; thous_A = 4'b0000; huns_A  = 4'b0000; tens_A  = 4'b0000; ones_A  = 4'b0000;
            sign_B = 0; thous_B = 4'b0000; huns_B  = 4'b0000; tens_B  = 4'b0000; ones_B  = 4'b0000;
            thous  = 4'b0000; huns  = 4'b0000; tens  = 4'b0000; ones  = 4'b0000;
            opcode  = 4'b0000;
        end
   end
   
   
   
   // state for push receive data to each BCD digit

endmodule
