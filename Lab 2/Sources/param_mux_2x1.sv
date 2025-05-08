`timescale 1ns / 1ps

module param_mux_2x1 #(parameter N = 3) // suppose we working with N=3
(
    input logic [(2**N)-1:0] x0,        // 7:0  input 1
    input logic [(2**N)-1:0] x1,        // 7:0  input 2
    input logic sel,                    // selector
    output logic [(2**N)-1:0] y         // 7:0  output
);
  
    assign y = sel ? x1 : x0;           // if selector=1 then y=x1 ; if selector=0 then y=x0

endmodule
