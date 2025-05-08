`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 03:49:21 PM
// Design Name: 
// Module Name: alt_led
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


module alt_led(
        input logic clk,
        input logic reset,
        input logic [15:0] rate, //amount of milliseconds
        output logic led
    );
    
    logic tick;
    
    //timer parameter
    timer_parameter #(.FINAL_VALUE(100_000)) M3(//10^5 * 10ns = 1ms
        .clk(clk),
        .reset_n(~reset),
        .enable(1'b1),
        .done(tick)
    );
    
    logic toggle;
    
    mod_m_counter_binary #(.M(16)) M2 (
        .clk(tick),
        .reset(reset),
        .q(rate),
        .max_tick(toggle)
    );
    
    T_FF M1 (
        .clk(clk),
        .T(toggle),
        .reset_n(~reset),
        .Q(led)
    );
    
endmodule
