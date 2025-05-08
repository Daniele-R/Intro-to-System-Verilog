`timescale 1ns / 1ps

module multi_barrel_shifter_reverser #(parameter N = 3)
(
    input logic [(2**N)-1:0] a,                     // 7:0 inputs
    input logic [N-1:0] amt,                        // 3:0 selector
    input logic lr,                                 // left/right bit (left=0) (right=1)
    output logic [(2**N)-1:0] y                     // 7:0 output
);
    
    logic [(2**N)-1:0] preRev;                      // wire for before reversed
    logic [(2**N)-1:0] shifted;                     // wire for shifted
    
    reverser #(.N(N)) preReverse
    (
        .a(a),                                      // reverse_input = input
        .en(~lr),                                   // reseverse_enable = LEFT (~lr = 0) 
        .y(preRev)                                  // reverse_output = wire b4 rev
    );
                        
    param_right_shifter #(.N(N)) right_shift
    (
        .a(preRev),                                 // reverse_input = wire b4 rev
        .amt(amt),                                  // reverse_selector = selector
        .y(shifted)                                 // reverse_output = wire shifted
    );
                        
    reverser #(.N(N)) postReverse
    (
        .a(shifted),                                // reverse_input = wire shifted
        .en(~lr),                                   // reverse_enable = LEFT (~lr = 0)
        .y(y)                                       // reverse_output = output
    );

endmodule
