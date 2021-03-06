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
    output [15:0] led,
    input clk,
    input btnU,
    input RsRx,
    output RsTx
    );
    wire BTNU;
    singlePulser btnu(BTNU, btnU, clk); 
       
    
    // for 7 segment -- START
    wire targetClk;
    wire [25:0] tclk;
    wire [7:0] num0,num1,num2,num3;
    wire an0,an1,an2,an3;

    assign an = {an0,an1,an2,an3};
    
    assign tclk[0] = clk;
    genvar c;
    generate for(c = 0; c < 25; c = c + 1)
    begin
        clockDiv div(tclk[c + 1], tclk[c]);
    end
    endgenerate
    
    clockDiv divTarget(targetClk, tclk[18]);
    
    reg [3:0] before_num3; reg [3:0] before_num2;
    reg [3:0] before_num1; reg [3:0] before_num0; reg before_sign; wire final_sign;
    wire sign_input; wire sign_result ; wire overflow;
    wire[3:0] thous; wire[3:0] huns; wire[3:0] tens; wire[3:0] ones;
    wire[3:0] state; wire [15:0] BCD_result;
    
    
    always @(posedge clk) begin
        if (state == 0) begin
            before_sign = sign_result;
            before_num3 = BCD_result[15:12];
            before_num2 = BCD_result[11:8];
            before_num1 = BCD_result[7:4];
            before_num0 = BCD_result[3:0];
        end
        else begin
            before_sign = sign_input;
            before_num3 = thous;
            before_num2 = huns;
            before_num1 = tens;
            before_num0 = ones;
        end
    end
    assign final_sign = before_sign;
    assign led[15] = final_sign ; assign led[14] = final_sign ; assign led[13] = final_sign ;
    assign led[0] = overflow; assign led[1] = overflow; assign led[2] = overflow;
    assign num3 = before_num3;
    assign num2 = before_num2;
    assign num1 = before_num1;
    assign num0 = before_num0;
    
    quadSevenSeg QuadSevenSeg(seg,dp,an[0],an[1],an[2],an[3],num0,num1,num2,num3,targetClk);
    // for 7 segment -- END
    
    
    reg ena, last_rec;
    reg [7:0] data_in;
    reg [3:0] binary_in;
    wire [7:0] data_out;
    wire sent, received, baud, success;
    wire [13:0] binary_A; wire [13:0] binary_B; wire [26:0] binary_result;
    wire sign_A; wire sign_B;

    
    baudrate_gen baudrate_gen(clk, baud);
    transmitter transmitter(baud, data_in, ena, sent, RsTx);
    // flow part
    // 1.
    receiver receiver(baud, RsRx, success, received, data_out);
    // 2.
    input_state input_state(sign_input, thous, huns, tens, ones, sign_A, binary_A, sign_B , binary_B, state, binary_in, success, BTNU);
    // 3.
    calculator cal(sign_A, binary_A, sign_B, binary_B, binary_in , clk, BTNU , binary_result, sign_result, overflow);
    // 4.
    Binary2BCD BCD(binary_result[13:0], BCD_result);



    reg [7:0]K_0 = 8'h30; reg [7:0]K_1 = 8'h31; reg [7:0]K_2 = 8'h32; reg [7:0]K_3 = 8'h33;        
    reg [7:0]K_4 = 8'h34; reg [7:0]K_5 = 8'h35; reg [7:0]K_6 = 8'h36; reg [7:0]K_7 = 8'h37;         
    reg [7:0]K_8 = 8'h38; reg [7:0]K_9 = 8'h39; reg [7:0]K_PLUS  = 8'h2B; 
    reg [7:0]K_MINUS = 8'h2D; reg [7:0]K_MUL = 8'h2A; reg [7:0]K_DIV   = 8'h2F;
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
