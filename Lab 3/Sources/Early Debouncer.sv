`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2024 01:30:46 PM
// Design Name: 
// Module Name: Early Debouncer
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


module Early_Debouncer(
    input logic sw, reset, clk,
    output logic db
    );
    
    logic tick;
    
    mod_m_counter #(.M(1_000_000)) M1(
        .q(),
        .max_tick(tick),
        .*
    );
    
    //state reg
    typedef enum {zero, wait1_1, wait1_2, wait1_3, one, wait0_1, wait0_2, wait0_3} state_type;
    
    state_type state_next, state_reg;
    
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            state_reg <= zero;
        else
            state_reg <= state_next;
    end
    
    //next-state logic
    always_comb
    begin
        case(state_reg)
            zero:
                if(sw)
                    state_next = wait1_1;
                else
                    state_next = zero;
            wait1_1: 
                if(tick)
                    state_next = wait1_2;
                else
                    state_next = wait1_1;
            wait1_2:
                if(tick)
                    state_next = wait1_3;
                else
                    state_next = wait1_2;
            wait1_3:
                if(tick)
                    state_next = one;
                else
                    state_next = wait1_3;
            one:
                if(sw)
                    state_next = one;
                else
                    state_next = wait0_1;
            wait0_1:
                if(tick)
                    state_next = wait0_2;
                else
                    state_next = wait0_1;
            wait0_2:
                if(tick)
                    state_next = wait0_3;
                else
                    state_next = wait0_2;
            wait0_3:
                if(tick)
                    state_next = zero;
                else
                    state_next = wait0_3;
            default: state_next = zero;
         endcase
    end
    
    //mealy output logic
    
    
    //moore output logic 
    assign db = ((state_reg == wait1_1) || (state_reg == wait1_2) || (state_reg == wait1_3) || (state_reg == one));
    
endmodule
