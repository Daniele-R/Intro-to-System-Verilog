`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2022 06:56:16 PM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input logic clk, reset_n,
    input logic level,
    output logic p_edge, n_edge, _edge
    );
    
    // Edge detector with Mealy outputs
    logic [1:0] state_reg, state_next;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 =3;
    
    // Sequential state registers
    always_ff @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            state_reg <= s0;
        else
            state_reg <= state_next;
    end
    
    // Next state logic
    always_comb
    begin
        case(state_reg)
            s0: if (level) state_next = s1;
                else       state_next = s0;
            s1: if (level) state_next = s2;
                else       state_next = s3;
            s2: if (level) state_next = s2; 
                else       state_next = s3;
            s3: if (level) state_next = s1;
                else       state_next = s0;
            default: state_next = s0;                
        endcase
    end
    
    // Output logic
    assign p_edge = (state_reg == s1);
    assign n_edge = (state_reg == s3);
    assign _edge = p_edge | n_edge;
    
endmodule

