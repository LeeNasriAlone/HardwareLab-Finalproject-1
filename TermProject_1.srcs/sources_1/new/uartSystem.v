`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2020 01:02:26 PM
// Design Name: 
// Module Name: uartSystem
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


module uartSystem(
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input clk,
    input RsRx,
    output RsTx
    );
    reg reset = 0;
    // for 7 segment -- START
    wire targetClk;
    wire [25:0] tclk;
    wire [7:0] num0,num1,num2,num3;
    wire an0,an1,an2,an3;
    wire [7:0] sw2, SW;

    assign an = {an0,an1,an2,an3};
    
    assign tclk[0] = clk;
    genvar c;
    generate for(c = 0; c < 25; c = c + 1)
    begin
        clockDiv div(tclk[c + 1], tclk[c]);
    end
    endgenerate
    
    clockDiv divTarget(targetClk, tclk[18]);
    
    assign num3 = BCD_result[15:12];
    assign num2 = BCD_result[11:8];
    assign num1 = BCD_result[7:4];
    assign num0 = BCD_result[3:0];
    
    quadSevenSeg QuadSevenSeg(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,targetClk);
    // for 7 segment -- END
    
    reg [7:0]K_0 = 8'h30; 
    reg [7:0]K_1 = 8'h31;            
    reg [7:0]K_2 = 8'h32;         
    reg [7:0]K_3 = 8'h33;        
    reg [7:0]K_4 = 8'h34;       
    reg [7:0]K_5 = 8'h35; 
    reg [7:0]K_6 = 8'h36;            
    reg [7:0]K_7 = 8'h37;         
    reg [7:0]K_8 = 8'h38;        
    reg [7:0]K_9 = 8'h39;    
        
    reg [7:0]K_PLUS  = 8'h2B;     // +    
    reg [7:0]K_MINUS = 8'h2D;     // - 
    reg [7:0]K_MUL   = 8'h2A;     // *     
    reg [7:0]K_DIV   = 8'h2F;     // /   
    
    reg ena, last_rec;
    reg [7:0] data_in;
    reg [3:0] binary_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    wire success, ready_to_calculate;
    wire [13:0] binary_A; wire [13:0] binary_B; wire [13:0] binary_result;
    wire [15:0] BCD_result;
    
    baudrate_gen baudrate_gen(clk, baud);
    transmitter transmitter(baud, data_in, ena, sent, RsTx);
    // flow part
    receiver receiver(baud, RsRx, success, received, data_out);
    input_state input_state(binary_A, binary_B, ready_to_calculate, binary_in, success, reset);
    calculator cal(binary_A, binary_B, ready_to_calculate, clk, binary_result);
    Binary2BCD BCD(binary_result, BCD_result);

    always @(posedge baud)
    begin
        if (ena == 1) ena = 0;
     
        if (~last_rec & received) begin
            if      (data_out == K_0) begin data_in = 8'h30; binary_in = 4'b0000; end
            else if (data_out == K_1) begin data_in = 8'h31; binary_in = 4'b0001; end
            else if (data_out == K_2) begin data_in = 8'h32; binary_in = 4'b0010; end
            else if (data_out == K_3) begin data_in = 8'h33; binary_in = 4'b0011; end
            else if (data_out == K_4) begin data_in = 8'h34; binary_in = 4'b0100; end
            else if (data_out == K_5) begin data_in = 8'h35; binary_in = 4'b0101; end
            else if (data_out == K_6) begin data_in = 8'h36; binary_in = 4'b0110; end
            else if (data_out == K_7) begin data_in = 8'h37; binary_in = 4'b0111; end
            else if (data_out == K_8) begin data_in = 8'h38; binary_in = 4'b1000; end
            else if (data_out == K_9) begin data_in = 8'h39; binary_in = 4'b1001; end
            else if (data_out == K_PLUS)  begin data_in = 8'h2B; binary_in = 4'b1010; end
            else if (data_out == K_MINUS) begin data_in = 8'h2D; binary_in = 4'b1011; end
            else if (data_out == K_MUL)   begin data_in = 8'h2A; binary_in = 4'b1100; end
            else if (data_out == K_DIV)   begin data_in = 8'h2F; binary_in = 4'b1101; end
            else begin data_in = 8'hFF; end
            
            if (data_in != 8'hFF) ena = 1;
         end
         last_rec = received;
    end

endmodule
