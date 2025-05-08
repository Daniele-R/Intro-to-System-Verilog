// Taken from: https://github.com/aseddin/ece_3300/blob/main/M4%20Combinational-Circuit%20Building%20Blocks/Source/mux_4x1_nbit.v

`timescale 1ns / 1ps

module mux_4x1_nbit
    #(parameter N = 3)
    (
    input logic [N - 1:0] w0, w1, w2, w3,
    input logic [1:0] s,
    output logic [N - 1:0] f
    );
    
    always_comb
    begin
        f = 'bx;                 
        case(s)
            3'b000: f = w0;                
            3'b001: f = w1;
            3'b010: f = w2;
            3'b011: f = w3;
            default: f = 'bx;
        endcase              
    end
endmodule

