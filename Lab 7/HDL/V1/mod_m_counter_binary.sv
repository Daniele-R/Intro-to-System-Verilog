`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 03:51:38 PM
// Design Name: 
// Module Name: mod_m_counter_binary
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


module mod_m_counter_binary
    #(parameter M = 8)
    (
        input logic clk, reset,
        input logic [M - 1:0] q,
        output logic max_tick
    );
    
    // signal declaration
    logic [M - 1:0] r_next, r_reg;
    
    // body
    // [1] Register segment
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end
    
    // [2] next-state logic segment
    assign r_next = (r_reg == (q - 1))? 0: r_reg + 1;
    
    // [3] output logic segment
    
    assign max_tick = (r_reg == q - 1) ? 1'b1: 1'b0;
    
endmodule
