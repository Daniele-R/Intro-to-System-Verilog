`timescale 1ns / 1ps

module multi_barrel_shifter_mux #(parameter N = 3) 
(
    input logic [(2**N)-1:0] a,                     // 7:0 inputs
    input logic [N-1:0] amt,                        // 3:0 selectors
    input logic lr,                                 // left/right bit (left=0) (right=1)
    output logic [(2**N)-1:0] y                     // 7:0 output
);
    
    logic [(2**N)-1:0] yr;                          // wire 7:0 output RIGHT
    logic [(2**N)-1:0] yl;                          // wire 7:0 output LEFT
    
    param_left_shifter #(.N(N)) left_shift
    (
        .a(a),                                      // pls_input = input
        .amt(amt),                                  // pls_select = select
        .y(yl)                                      // pls_output = left output
    );
                        
    param_right_shifter #(.N(N)) right_shift
    (
        .a(a),                                      // prs_input = input
        .amt(amt),                                  // prs_select = select
        .y(yr)                                      // prs_output = right output
    );

    param_mux_2x1 #(.N(N)) selector
    (
        .x0(yl),                                    // mux_input1 = left output
        .x1(yr),                                    // mux_input2 = right output
        .sel(lr),                                   // mux_selector = left/right bit
        .y(y)                                       // mux_output = output
    );                

endmodule
